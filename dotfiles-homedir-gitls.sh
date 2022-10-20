#!/bin/sh

set -eu

cd || exit

rm -f .gitls
\ls -AF1 | grep -vxF .gitls > .gitls
$ dotfiles add .gitls
rm -f .gitls
