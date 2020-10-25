import json
import requests

while True:
    post = input()
    if len(post) <= 139:
        break
    print('Too many characters')

# переменные для GH:
token = "your token to GitHab"
owner = "your name to GitHab"
repo = "name of your repo to GitHab"
query_url = f"https://api.github.com/repos/{owner}/{repo}/issues/1/comments"
Accept = "application/vnd.github.v3+json"

# переменные для VK:
owner_id = 'your owner_id to VK'
access_token = 'access_token of your app of VK'
url_vk = 'https://api.vk.com/method/wall.post'


def send_post_gh(url, **kwargs):
    response = requests.post(url, **kwargs)
    response = response.json()
    return response


headers = {'Authorization': f'token {token}', 'Accept': Accept}
data = {'body': post}
gh = send_post_gh(url=query_url, headers=headers, data=json.dumps(data))


def send_post_vk(*args):
    response = requests.get(*args)
    response = response.json()
    return response


vk = send_post_vk('https://api.vk.com/method/wall.post', {
    'user_id' : owner_id,
    'message' : post,
    'access_token' : access_token,
    'v' : '5.124'
})

print(json.dumps(gh, indent=4))
print(json.dumps(vk, indent=4))

