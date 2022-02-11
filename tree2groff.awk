#! /bin/gawk -E

BEGIN {
    FS = " +"
    intree = 0
    firstline = 0
}

(intree == 0) && /^\.TREE([[:blank:]]+[[:alnum:]]+)?$/ {
    print ".br"
    print ".sp 0.5v"
    print ".vs 1m"
    printf ".fam %s\n", $2
    print ".nr halfwidth \\w'\\0'/2"
    print ".nr twohalfwidth 5*\\w'\\0'/2"
    print ".de ur"
    print "\\v'-0.8m'\\h'\\n[halfwidth]u'\\D'l 0 0.5m'\\D'l \\n[twohalfwidth]u 0'\\v'0.3m'\\ \\c"
    print ".."
    print ".de vr"
    print "\\v'-0.8m'\\h'\\n[halfwidth]u'\\D'l 0 1m'\\v'-0.5m'\\D'l \\n[twohalfwidth]u 0'\\v'0.3m'\\ \\c"
    print ".."
    print ".de vv"
    print "\\v'-0.8m'\\h'\\n[halfwidth]u'\\D'l 0 1m'\\v'-0.2m'\\h'\\n[twohalfwidth]u'\\ \\c"
    print ".."
    intree = 1
    next
}

(intree == 1) && /^\.TREE[[:blank:]]+(OFF|QUIT|X)[[:blank:]]*$/ {
    print ".fam"
    print ".sp"
    print ".vs"
    print ".rr halfwidth"
    print ".rr twohalfwidth"
    intree = 0
    next
}

intree == 1 {
    gsub(/^/, ".br\n")
    gsub(/└── /, ".ur\n")
    gsub(/├── /, ".vr\n")
    gsub(/│   /, ".vv\n")
    gsub(/    /, "\\h'(4*\\n[charwidth])u'\\c\n")
    print
    next
}

intree == 0 {
    print
    next
}
