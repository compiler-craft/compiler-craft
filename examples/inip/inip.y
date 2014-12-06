%{
/* ini file parser */
extern int yylineno;
int yylex(void);
void yyerror(char*);
#include <stdio.h>
#define YYSTYPE char*
%}

%token NAME OP VALUE

%%

file: lines
;
lines: lines line
	 | line
;

line: NAME OP VALUE {
	printf("name[%s] op[%s] value[%s]\n", $1, $2, $3);
free($1);
free($2);
free($3);
}

%%

void yyerror(char *errmsg) {
	fprintf(stderr, "Error: %s encountered at line: %d\n", errmsg, yylineno);
}

int main(int argc, char *argv[]) {
	yyparse();

	return 0;
}
