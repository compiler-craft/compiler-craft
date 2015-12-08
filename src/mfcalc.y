%{
#include <stdio.h>
#include <math.H>
#include <ctype.h>

int yylex(void);
void yyerror(char *);
#define YYSTYPE double
%}

%token NUM
%left '-' '+'
%left '*' '/'
%left NEG /* negation-unary minus */
%right '^' /* exponentiation */

%%

program: program line
	   |
;

line :
	 '\n'
| expr '\n' { printf("\t%.10g\n", $1); }
| error '\n' { yyerrok; }
;

expr: NUM { $$ = $1; }
	| expr '+' expr { $$ = $1 + $3; }
	| expr '-' expr { $$ = $1 - $3; }
	| expr '*' expr { $$ = $1 * $3; }
	| expr '/' expr { $$ = $1 / $3; }
	| '-' expr %prec NEG { $$ = -$2; }
	| expr '^' expr { $$ = pow($1, $3); }
	| '(' expr ')' { $$ = $2; }
;

%%

void yyerror(char* errmsg) {
	fprintf(stderr, "%s\n", errmsg);
}

int main(int argc, char *argv[]) {
	return yyparse();
}

int yylex() {
	int c;

/* skip white space */
	while ((c = getchar()) == ' ' || c == '\t')
		;

/* progress numbers */
	if (c == '.' || isdigit(c)) {
	ungetc(c, stdin);
	scanf("%lf", &yylval);
	return NUM;
	}
	/* return EOF */
	if (c == EOF)
	return 0;
	/* return single chars */
	return c;
}
