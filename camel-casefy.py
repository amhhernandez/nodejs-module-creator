#!/usr/bin/python
import sys

def to_camel_case(snake_str):
    components = snake_str.split('-')
    return components[0] + ''.join(x.title() for x in components[1:])

if __name__ == '__main__':
  print(to_camel_case(sys.argv[1]))
