import json

def get_user(username):
    with open("appium/users.json") as f:
        return json.load(f)[username]