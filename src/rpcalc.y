/* Reverse polish notation calculator */
%{
#include <stdio.h>
#include <math.h>
#include <ctype.h>

int yylex(void);
void yyerror(char *);

#define YYSTYPE double
%}

%token NUM

%% /* grammer rules and actions follow */

program: /* empty */
	   | program line
;

line:
	'\n'
| exp '\n' { printf("%.10g\n", $1); }
;

exp:
   NUM	{ $$ = $1; }
| exp exp '+' { $$ = $1 + $2; }
| exp exp '-' { $$ = $1 - $2; }
| exp exp '*' { $$ = $1 * $2; }
| exp exp '/' {
	if ($2 < 1e-320) {
		fprintf(stderr, "%s\n", "divide by zero");
		$$ = 0;
	} else
		$$ = $1 / $2;
	}
| exp exp '^' { $$ = pow($1, $2); } /* exponentiation */
| exp 'n' { $$ = -$1; } /* unary minus */
;

%%

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

void yyerror(char* msg) {
	printf("%s\n", msg);
}

int main(int argc, char *argv[]) {
	return yyparse();
}

