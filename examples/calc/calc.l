%{
#include <stdlib.h>
void yyerror(char *);
#include "calc.tab.h"
%}

%%

[a-z] { yylval = *yytext - 'a'; return VAR; }

[0-9]+ { yylval = atoi(yytext); return INT; }

[-+()=*/\n] { return *yytext; }

[ \t] { /* skip */ }

. { yyerror("invalid character"); }

%%

int yywrap() {
	return 1;
}

