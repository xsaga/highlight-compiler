#!/usr/bin/awk -f

BEGIN {
    RS = "\n";  # record separator
    FS = "\t";  # field separator

    # https://stackoverflow.com/questions/4842424/list-of-ansi-color-escape-sequences
    # ANSI escape sequences, Select Graphic Rendition \033[...m
    # ... one number that represents a certain attribute
    #     or a sequence of numbers separated by ';'
    ansi_sgr_reset = "\\033[0m"

    colors["black"] = 30
    colors["red"] = 31
    colors["green"] = 32
    colors["yellow"] = 33
    colors["blue"] = 34
    colors["magenta"] = 35
    colors["cyan"] = 36
    colors["white"] = 37

    printf "#!/usr/bin/awk -f\n"
}

/^[[:space:]]*$/ {next;}
/^[[:space:]]*#/ {next;}

{
    if (!($2 in colors)) {
        print "Color code '" $2 "' not defined. Aborted." > "/dev/stderr";
        exit 1
    }
    color = "\\033[" colors[$2] "m"
    printf "/%s/ {\n", $1;  # pattern matching
    printf "\tprintf \"%s%%s%s\\n\", $0; next", color, ansi_sgr_reset  # colorize output
    printf "}\n";
}

END {
    printf "{print $0}\n"  # default option, copy the line.
}
