examples
========

The project used several grammer and sub projects to demostrate the theory of compiler craft, all these are listed below:

* calc
  classic calaulator

.. code-block:: yacc

    program: program statement '\n' | NULL
    statement: expr | VAR '=' expr
    expr: INT | VAR | expr '+' expr
        | expr '-' expr
        | expr '*' expr
        | expr '/' expr
        | '(' expr ')'

* cat
* inip
* micro
* toc
* toy
* wc
* word

