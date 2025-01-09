#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import sys
import base64
import json

import urllib.request
import urllib.parse

from datetime import datetime


def get_oauth_token(client_id, client_secret):
    url = "https://bitbucket.org/site/oauth2/access_token"
    data = urllib.parse.urlencode({"grant_type": "client_credentials"}).encode()
    credentials = f"{client_id}:{client_secret}"
    encoded_credentials = base64.b64encode(credentials.encode()).decode()
    headers = {
        "Authorization": f"Basic {encoded_credentials}",
        "Content-Type": "application/x-www-form-urlencoded",
    }

    req = urllib.request.Request(url, data=data, headers=headers)
    with urllib.request.urlopen(req) as response:
        response_data = json.loads(response.read().decode())
        return response_data["access_token"]


def get_branches(workspace, repository, token):
    url = f"https://api.bitbucket.org/2.0/repositories/{workspace}/{repository}/refs/branches?pagelen=100"
    headers = {"Authorization": f"Bearer {token}"}

    branches = []
    size = None
    while url:
        req = urllib.request.Request(url, headers=headers)
        with urllib.request.urlopen(req) as response:
            response_data = json.loads(response.read().decode())
            if size is None:
                size = response_data["size"]
            branches.extend(response_data["values"])
            url = response_data.get("next")
    print(f"Total branches: {size}")
    return branches


def parse_branches(branches, sort_by_date=False):
    result = []
    for branch in branches:
        name = branch["name"]
        date = branch["target"]["date"]
        author = branch["target"]["author"]["raw"]
        result.append({"name": name, "date": datetime.fromisoformat(date), "author": author})

    if sort_by_date:
        return sorted(result, key=lambda x: x["date"], reverse=True)
    return sorted(result, key=lambda x: x["name"], reverse=False)


def print_branches(branches):
    lengt_name = 115
    lengt_date = 27
    lengt_author = 65
    header = f"{'Branch Name':<{lengt_name}} {'Last Commit Date':<{lengt_date}} {'Last Commit Author':<{lengt_author}}"
    print(header)
    print("=" * (lengt_name + lengt_date + lengt_author))
    for branch in branches:
        name = branch["name"]
        date = branch["date"].strftime("%Y-%m-%d %H:%M:%S")
        author = branch["author"]
        print(f"{name:<{lengt_name}} {date:<{lengt_date}} {author:<{lengt_author}}")


def main():
    if len(sys.argv) < 3:
        print("Usage: bitbucket.py <Workspace> <Repository> <Option>")
        sys.exit(1)

    workspace = sys.argv[1]
    repository = sys.argv[2]

    sorted_by_date = False

    if len(sys.argv) == 4:
        option = sys.argv[3].lower()
        if option == "date":
            sorted_by_date = True

    client_id = os.getenv("BITBUCKET_CLIENT_ID")
    client_secret = os.getenv("BITBUCKET_CLIENT_SECRET")

    if not client_id or not client_secret:
        print("Environment variables BITBUCKET_CLIENT_ID and BITBUCKET_CLIENT_SECRET must be set.")
        sys.exit(1)

    token = get_oauth_token(client_id, client_secret)
    branches = get_branches(workspace, repository, token)
    print_branches(parse_branches(branches, sort_by_date=sorted_by_date))


if __name__ == "__main__":
    main()
