%{
#include <stdlib.h>
#include "structure.h"
#include "micro.tab.h"
void yyerror(char *, ...);
%}

%%

[a-z] { yylval.idx = *yytext - 'a'; return VAR; }

0|[1-9][0-9]* { yylval.val = atoi(yytext); return INT; }

[-+*/()<>{}=;.] { return *yytext; }

">=" return GE;
"<=" return LE;
"==" return EQ;
"!=" return NE;
"while" return WHILE;
"if" return IF;
"else" return ELSE;
"print" return PRINT;

[ \t\n]+	{ /* ignore whitespace */ }

. { yyerror("invalid character: '%s'", yytext); }

%%

int yywrap() {
	return 1;
}
