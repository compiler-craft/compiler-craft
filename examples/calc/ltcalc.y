%{
#include <stdio.h>
#include <math.h>
int yylex(void);
void yyerror(char *);
%}

%define api.value.type {long}
%token NUM
%left '+' '-'
%left '*' '/'
%precedence NEG /* unary negtive minus */
%right '^'

%%

program: lines
	   | /* nullable */
;

lines: line
	| lines line
;

line: '\n'
	| expr '\n' { printf("=> %ld\n", $1); }
	| error '\n' { yyerrok; }
;

expr: NUM { $$ = $1; }
	| expr '+' expr { $$ = $1 + $3; }
	| expr '-' expr { $$ = $1 - $3; }
	| expr '*' expr { $$ = $1 * $3; }
	| expr '/' expr {
		if ($3) $$ = $1 / $3;
		else {
			$$ = 1;
			fprintf(stderr, "%d.%d-%d.%d: division by zero\n",
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
	fprintf(stderr, "Error: %s encountered\n", errmsg);
}

int yylex(void) {
	int c;

	while ((c = getchar()) == ' ' || c == '\t')
		++yylloc.last_column;
	yylloc.first_line = yylloc.last_line;
	yylloc.first_column = yylloc.last_column;

	switch (c) {
		case '0': case '1': case '2': case '3': case '4':
		case '5': case '6': case '7': case '8': case '9':
			yylval = c - '0';
			while (isdigit(c = getchar())) {
				++yylloc.last_column;
				yylval = yylval * 10 + c - '0';
			}
			ungetc(c, stdin);
			return NUM;
		case EOF: /* Return EOF */
			return 0;
		case '\n':
			++yylloc.last_line;
			yylloc.last_column = 0;
			break;
		default:
			++yylloc.last_column;
			return c;
	}

	return c;
}

int main(int argc, char *argv[]) {
	yylloc.first_line = yylloc.last_line = 1;
	yylloc.first_column = yylloc.last_column = 0;
	return yyparse();
}

