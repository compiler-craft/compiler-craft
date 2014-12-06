%{
#include <stdio.h>
#include <math.h>
#define YYSTYPE double
extern int yylineno;
int yylex(void);
void yyerror(char *);
%}

%token NUM

%%

program: lines
	   | /* NULL */
;

lines: line
	| lines line
;

line: '\n'
	| expr '\n' { printf("%.10g\n", $1); }
	| error '\n' { yyerrok; }
;

expr: NUM { $$ = $1; }
	| expr expr '+' { $$ = $1 + $2; }
	| expr expr '-' { $$ = $1 - $2; }
	| expr expr '*' { $$ = $1 * $2; }
	| expr expr '/' { $$ = $1 / $2; }
	| expr expr '^' { $$ = pow($1, $2); } /* Exponentiation */
	| expr 'n'		{ $$ = -$1; } /* Unary minus */
;

%%

void yyerror(char* errmsg) {
	fprintf(stderr, "Error: %s encountered at line: %d\n", errmsg, yylineno);
}

int main(int argc, char *argv[]) {
	yyparse();

	return 0;
}

int yylineno = 1;

int yylex(void) {
	int c;

	/* Skip whitespace */
	while ((c = getchar()) == ' ' || c == '\t')
		continue;

	switch (c) {
		case '.':
		case '0': case '1': case '2': case '3': case '4':
		case '5': case '6': case '7': case '8': case '9':
			ungetc(c, stdin);
			scanf("%lf", &yylval);
			return NUM;
		case EOF: /* Return EOF */
			return 0;
		case '\n':
			++yylineno;
			break;
		default:
			return c;
	}

	return c;
}
