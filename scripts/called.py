#! /usr/bin/python3
#
# This little script can be used in conjuction with the format script.
# format.py expects key-value-pairs as its input, but most existing tools do
# not delivier this kind of formatted data.  This script takes from stdin the
# output of another program or file and gives it a key, so that it can be used
# with format.py
#
# Example:
#
# > echo "Hello" | called greeting
# greeting=Hello
#
# This key-value-pair can be formatted by using format.py

import sys

def main():

    identifier = ' '.join(sys.argv[1:]).replace('=', '\\=')

    for line in sys.stdin:
        output = identifier + '=' + line

    print( output )

if __name__ == '__main__':
    main()
