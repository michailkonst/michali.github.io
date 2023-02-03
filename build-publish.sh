#!/bin/sh
SC_CHANGES=`git status --porcelain`
length=${#SC_CHANGES} 

if [ $length -gt 0 ]; then
echo "There are changes in the working directory. Please commit those changes and rerun the script."
exit
fi

bundle exec jekyll build
if [ $? -ne 0 ] ; then
    echo "Error when building the site. Exiting."
    exit 1
fi

echo "Site built"

cp -r _site/. ../michali.github.io/
MESSAGE=`git log -1 --pretty=%B`

git -C ../michali.github.io add -A
git -C ../michali.github.io commit -m "$MESSAGE"
git -C ../michali.github.io push

echo "Pushed to Github pages"
