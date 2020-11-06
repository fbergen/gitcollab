# gitcollab


## Pull requests

Starts a simple webserver displaying MAU who have interacted on a PR

### Run locally 

```
$ # Start docker container
$ cd pullrequests
$ docker rm -f gc && docker build --tag gitcollab . && docker run --publish 8080:8080 --name gc gitcollab
$ http://localhost:8080/repo/GitbookIO/gitbook
```


## Issues

Dumps users active on Issues

### Run locally

Get an access key from github 

Dump issues by date and user
```
$ python issue_scraper.py GH_ACCESS_KEY GitbookIO gitbook > gitbook.txt
```

Display MAU
```
$ cat gitbook.txt | sed 's/-[^-]*,/,/g' | vd -fcsv -p cmdlog.vd
```


