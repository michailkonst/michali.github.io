BEGIN {
    IGNORE["a"] = 1
    IGNORE["an"] = 1
    IGNORE["the"] = 1
    IGNORE["and"] = 1
    IGNORE["but"] = 1
    IGNORE["or"] = 1
    IGNORE["for"] = 1
    IGNORE["nor"] = 1
    IGNORE["on"] = 1
    IGNORE["at"] = 1
    IGNORE["to"] = 1
    IGNORE["by"] = 1
}

{
    for (i = 1; i <= NF; i++) {
        word = $i
        # Check if the word has two or more letters and they are all uppercase
        if (length(word) > 1 && word == toupper(word)) {
            continue
        }
        
        word = tolower(word)
        
        # Always capitalise the first word, regardless of whether it's in IGNORE
        if (i == 1 || !(word in IGNORE)) {
            $i = toupper(substr($i, 1, 1)) tolower(substr($i, 2))
        }
    }
    print $0
}