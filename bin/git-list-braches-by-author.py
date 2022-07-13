#!/usr/bin/env python
# -*- coding: utf-8 -*-

import threading
import subprocess

def get_git_data_runner(branch, dest_dict: dict):
    last_commit_author_name = subprocess.run(
        ['git', 'log', '-1', '--format=%an', branch],
        stdout=subprocess.PIPE, encoding='utf-8')
    last_commit_email = subprocess.run(
        ['git', 'log', '-1', '--format=%aE', branch],
        stdout=subprocess.PIPE, encoding='utf-8')
    dest_dict[branch] = (
        last_commit_author_name.stdout.strip(),
        last_commit_email.stdout.strip()
    )

branches = list()
result = subprocess.run(
    ['git', 'branch', '-a'],
    stdout=subprocess.PIPE, encoding='utf-8'
)

for branch in result.stdout.split('\n'):
    if branch.strip().startswith('remotes/origin') and 'origin/HEAD' not in branch:
        branches.append(branch.strip())

dest_dict = dict()
for branch in branches:
    threading.Thread(target=get_git_data_runner, args=(branch, dest_dict)).start()

while threading.active_count() > 1:
    pass

fmt_list = '| {:100} | {:40} | {:40} |'
print(fmt_list.format('Repository', 'Author', 'Email'))
for branch, author in dest_dict.items():
    print(fmt_list.format(branch, author[0],author[1]))
