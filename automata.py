#!/usr/bin/env python
# -*- coding: utf-8 -*-
# ===============================================================
#
# Filename:	automata.py
#
# Author:		Oxnz
# Email:		yunxinyi@gmail.com
# Created:		[2014-11-21 02:19:40 CST]
# Last-update:	2014-11-21 02:19:40 CST
# Description: ANCHOR
#
# Version:		0.0.1
# Revision:	[None]
# Revision history:	[None]
# Date Author Remarks:	[None]
#
# License:
# Copyright (c) 2013 Oxnz
#
# Distributed under terms of the [LICENSE] license.
# [license]
#
# ===============================================================
#

class FA(object):
    def __init__(self, ptype, pvalue):
        try:
            self._type = ptype
            self._value = pvalue

            {
                're': self.parseRE,
            }[ptype]()
        except KeyError as e:
            raise NameError("can't parse '{}' which has type of '{}'".format(ptype, pvalue))

    def parseRE(self):
        print 're: {}'.format(self._value)
        pass

    def lex(self):
        pass

    def accept(self, string):
        return False
        pass

class NFA(FA):
    pass

class DFA(FA):
    pass

def test():
    fa = DFA('re', r'a*b')
    assert fa.accept('ab') == True
    assert fa.accept('aab') == True
    assert fa.accept('b') == False

if __name__ == '__main__':
    test()
