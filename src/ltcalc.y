%{
#include <stdio.h>
#include <math.H>
#include <ctype.h>

int yylex(void);
void yyerror(char *);
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
| expr '\n' { printf("\t%d\n", $1); }
| error '\n' { yyerrok; }
;

expr: NUM { $$ = $1; }
	| expr '+' expr { $$ = $1 + $3; }
	| expr '-' expr { $$ = $1 - $3; }
	| expr '*' expr { $$ = $1 * $3; }
	| expr '/' expr {
if ($3)
	$$ = $1 / $3;
else {
$$ = 1;
fprintf(stderr, "%d.%d-%d.%d: division by zero",
@3.first_line, @3.first_column,
@3.last_line, @3.last_column);
}
}
	| '-' expr %prec NEG { $$ = -$2; }
	| expr '^' expr { $$ = pow($1, $3); }
	| '(' expr ')' { $$ = $2; }
;

%%

void yyerror(char* errmsg) {
	fprintf(stderr, "%s\n", errmsg);
}

int main(int argc, char *argv[]) {
	yylloc.first_line = yylloc.last_line = 1;
	yylloc.first_column = yylloc.last_column = 0;
	return yyparse();
}

int yylex() {
	int c;

/* skip white space */
	while ((c = getchar()) == ' ' || c == '\t')
		++yylloc.last_column;

/* progress numbers */
	if (isdigit(c)) {
		yylval = c - '0';
		++yylloc.last_column;
		while (isdigit(c = getchar())) {
			++yylloc.last_column;
			yylval = yylval * 10 + c - '0';
		}
		ungetc(c, stdin);
		return NUM;
	}
	/* return EOF */
	if (c == EOF)
		return 0;
	/* return single chars */
	if (c == '\n') {
		++yylloc.last_line;
		yylloc.last_column = 0;
	} else
		++yylloc.last_column;
	return c;
}
