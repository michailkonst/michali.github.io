#!/bin/sh

if [ $# -lt 1 ]; then
    echo "Usage: $0 <title> [slug]"
    exit 1
fi

title="$1"

if [ $# -ge 2 ]; then
    slug="$2"
else
    slug=$(echo "$title" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
fi

date=$(date +'%Y-%m-%d')

# Define the file path
file_path="./_posts/${date}-${slug}.md"

# Create the Markdown file with the specified content
echo "---" > "$file_path"
echo "layout: post" >> "$file_path"
echo "title: \"$title\"" >> "$file_path"
echo "date: ${date}" >> "$file_path"
echo "tags:" >> "$file_path"
echo "---" >> "$file_path"

echo "Markdown file '$file_path' created successfully."