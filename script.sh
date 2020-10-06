set -e

rm -rf garden
git clone -n https://github.com/garden-io/garden.git 
cd garden

git log --date=short --pretty=format:"%ae,%cd" | rev | sed 's/-/,/1' | rev > test.csv
vd test.csv --header=0 -p ../cmdlog.vd --batch --output=test.html

cat test.html
