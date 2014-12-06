%{
#ifndef YYSTYPE
	#define YYSTYPE char*
#endif
#include "inip.tab.h"
extern YYSTYPE yylval;
void yyerror(char*);
%}
char [a-zA-Z]
digit [0-9]
name {char}+
op =
value {digit}+
%%
{name} { yylval = strdup(yytext); return NAME; }
{op} { yylval = strdup(yytext); return OP; }
{value} { yylval = strdup(yytext); return VALUE; }
. { yyerror("invalid character"); }
\n { /* skip non-char */ }
