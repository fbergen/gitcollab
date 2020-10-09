REPO_USR=$1
REPO_NAME=$2

git clone -n https://github.com/${REPO_USR}/${REPO_NAME}.git
cd ${REPO_NAME}

git log --date=short --pretty=format:"%ae,%cd" | rev | sed 's/-/,/1' | rev > tmp.csv
vd tmp.csv --header=0 -p ../cmdlog.vd --batch --output=test.csv

echo test.csv
# cp test.csv ../commiters-${REPO_NAME}.csv
