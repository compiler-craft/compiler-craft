Introduction
============

compiler-craft is a project intend to demostrate how a compiler is constructed.
And there will be several examples included.

Infrastructure
==============

* Source Tree Infrastructure::

    .
    ├── doc
    │   ├── build
    │   │   ├── doctrees
    │   │   ├── html
    │   │   │   ├── _images
    │   │   │   ├── _sources
    │   │   │   └── _static
    │   │   └── latex
    │   └── source
    ├── examples
    │   ├── calc
    │   ├── cat
    │   ├── inip
    │   ├── micro
    │   ├── toy
    │   ├── wc
    │   └── word
    ├── exp
    ├── lexer
    │   └── production
    ├── parser
    └── tmp

* Note:

    * doc/build is auto-generated
    * doc/source is manual-crafted
    * examples is the demo directory
    * exp and parser is the front-end
    * backend is not included for now

