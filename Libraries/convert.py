#!/usr/bin/python3

def convert(s):
    print(s)
    print(type(s))
    c = s.decode(encoding="utf-8", errors="strict")
    return(c)

