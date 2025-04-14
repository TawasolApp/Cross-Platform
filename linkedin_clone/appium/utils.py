import json

def get_user(username):
    with open("../users.json") as f:
        return json.load(f)[username]