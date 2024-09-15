#!/bin/sh

if [ $# -lt 1 ]; then
    echo "Usage: $0 <title> [date] [slug]"
    exit 1
fi

title="$1"

# Check if a date is provided, otherwise use the current date
if [ $# -ge 2 ] && [ -n "$2" ]; then
    if ! echo "$2" | grep -Eq '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'; then
        echo "Invalid date format. Please use YYYY-MM-DD."
        exit 1
    fi
    date="$2"
else
    date=$(date +'%Y-%m-%d')
fi

if [ $# -ge 3 ]; then
    slug="$3"
else
    slug=$(echo "$title" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -d "&’'")
    slug=$(echo "$slug" | cut -d '-' -f1-7)
fi

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