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

# Function to count words in the title
count_words() {
    echo "$1" | wc -w
}

# Activate virtual environment if needed
activate_venv() {
    VENV_PATH="./sluggen/bin/activate"
    if [ -f "$VENV_PATH" ]; then
        echo "Activating virtual environment..."
        # Source the venv to activate it
        . "$VENV_PATH"
    else
        echo "Virtual environment not found. Please set the correct path."
        exit 1
    fi
}

if [ $# -ge 3 ]; then
    slug="$3"
else
    # If the title has more than 6 words, use the NLP slug generator
    word_count=$(count_words "$title")
    if [ "$word_count" -gt 6 ]; then
        activate_venv  
        slug=$(python3 generate_slug.py "$title")
    else
        # Otherwise, generate the slug using simple transformation
        slug=$(echo "$title" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -d "&’'")
        slug=$(echo "$slug" | cut -d '-' -f1-7)
    fi
fi

echo "slug generated: $slug"

# Define the file path
file_path="./_posts/${date}-${slug}.md"

# Call the external awk file to capitalise the title
title=$(echo "$title" | awk -f capitalise_title.awk)

# Create the Markdown file with the specified content
echo "---" > "$file_path"
echo "layout: post" >> "$file_path"
echo "title: \"$title\"" >> "$file_path"
echo "date: ${date}" >> "$file_path"
echo "excerpt: " >> "$file_path"
echo "tags: " >> "$file_path"
echo "---" >> "$file_path"

echo "Markdown file '$file_path' created successfully."