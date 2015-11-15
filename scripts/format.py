#! /usr/bin/python3
#
# Formats key-value-pairs by using a template string.  For instance, you can
# pass a string like "My name is %name." as a template, and then some
# key-value-pairs like name=Wolfram from stdin and the script will output "My
# name is Wolfram".

import ast
import sys
import re

def main():

    template = ' '.join( sys.argv[1:] )

    for line in sys.stdin:
        parts = re.split( '(?<!\\\\)=', line.strip( '\n' ) )

        if len(parts) == 2:

            name = parts[0].strip()
            value = parts[1].replace( '\\=', '=' ).strip()
            template = template.replace( '%' + name, value )

    output = ast.literal_eval( '"' + template + '"' )
    print( output )

if __name__ == '__main__':
    main()
