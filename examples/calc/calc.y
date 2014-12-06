%{
#include <stdio.h>
extern int yylineno;
int yylex(void);
void yyerror(char *);
int symtbl[26];
%}

%token INT VAR
%left '+' '-'
%left '*' '/'

%%

program:
	   program statement '\n'
	   |
;

statement:
		 expr { printf("%d\n", $1); }
		 | VAR '=' expr { symtbl[$1] = $3; }
;

expr:
	INT { $$ = $1; }
	| VAR { $$ = symtbl[$1]; }
	| expr '+' expr { $$ = $1 + $3; }
	| expr '-' expr { $$ = $1 - $3; }
	| expr '*' expr { $$ = $1 * $3; }
	| expr '/' expr { $$ = $1 / $3; }
	| '(' expr ')' { $$ = $2; }
;

%%

void yyerror(char* errmsg) {
	fprintf(stderr, "Error: %s encountered at line: %d\n", errmsg, yylineno);
}

int main(int argc, char *argv[]) {
	yyparse();

	return 0;
}
