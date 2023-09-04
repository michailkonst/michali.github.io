#!/bin/sh
set -e

RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'

if [ $# -eq 0 ]; then
    echo "${RED}Please enter a commit message for the Github Pages site.${NC}"
    exit 1
fi

SC_CHANGES=`git status --porcelain`
length=${#SC_CHANGES} 

if [ $length -gt 0 ]; then
    echo "${RED}There are changes in the working directory. Please commit those changes and rerun the script.${NC}"
    exit 1
fi

bundle exec jekyll build

echo "Site built"

cp -r _site/. ../michali.github.io/

git -C ../michali.github.io add -A
git -C ../michali.github.io commit -m "$1"
git -C ../michali.github.io push

echo "${GREEN}Pushed to Github pages${NC}"
