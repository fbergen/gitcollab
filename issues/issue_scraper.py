import sys
import requests

gh_access_token = sys.argv[1]
user = sys.argv[2]
repo = sys.argv[3]


headers = {'Authorization': 'token ' + gh_access_token}

# To see reaction summary add this to headers
#'Accept': 'application/vnd.github.squirrel-girl-preview'}

url = f'https://api.github.com/repos/{user}/{repo}/issues/comments'
r = requests.get(url, headers=headers)

print(r.links['last']['url'], file=sys.stderr)


print("updated_at,user,author_association") # Write headers

# TODO: Make this loop async
while url:
    print(url, file=sys.stderr)

    json = r.json()
    for l in json:
        print(f"{l['updated_at']},{l['user']['login']},{l['author_association']}")

    try:
        url = r.links['next']['url']
    except:
        break
    r = requests.get(url, headers=headers)
