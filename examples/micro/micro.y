%{
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include "structure.h"

/* prototypes */
Node* operator(int operator, int noprands, ...);
Node* identifier(int index);
Node* constant(int value);
void freeNode(Node *p);
int ex(Node *);

int yylex(void);
void yyerror(char *, ...);
extern int yylineno;
int symtbl[26];
%}

%union {
	int val;	/* integer value */
	char idx;	/* symbol table index */
	Node *ptr;	/* node pointer */
}

%token <val> INT
%token <idx> VAR
%token WHILE IF PRINT
%nonassoc IFX
%nonassoc ELSE

%left GE LE EQ NE '>' '<'
%left '+' '-'
%left '*' '/'
%nonassoc UMINUS

%type <ptr> stmt stmt_list expr

%%

program: function { exit(0); }
;

function: function stmt { ex($2); freeNode($2); }
		| /* NULL */
;

stmt: ';' { $$ = operator(';', 2, NULL, NULL); }
	| expr ';' { $$ = $1; }
	| PRINT expr ';' { $$ = operator(PRINT, 1, $2); }
	| VAR '=' expr ';' { $$ = operator('=', 2, identifier($1), $3); }
	| WHILE '(' expr ')' stmt { $$ = operator(WHILE, 2, $3, $5); }
	| IF '(' expr ')' stmt %prec IFX { $$ = operator(IF, 2, $3, $5); }
	| IF '(' expr ')' stmt ELSE stmt { $$ = operator(IF, 3, $3, $5, $7); }
	| '{' stmt_list '}' { $$ = $2; }
	| error ';' { yyerrok; }
	| error '}' { yyerrok; }
;

stmt_list: stmt { $$ = $1; }
		 | stmt_list stmt { $$ = operator(';', 2, $1, $2); }
;

expr: INT { $$ = constant($1); }
	| VAR { $$ = identifier($1); }
	| '-' expr %prec UMINUS { $$ = operator(UMINUS, 1, $2); }
	| expr '+' expr { $$ = operator('+', 2, $1, $3); }
	| expr '-' expr { $$ = operator('-', 2, $1, $3); }
	| expr '*' expr { $$ = operator('*', 2, $1, $3); }
	| expr '/' expr { $$ = operator('/', 2, $1, $3); }
	| expr '<' expr { $$ = operator('<', 2, $1, $3); }
	| expr '>' expr { $$ = operator('>', 2, $1, $3); }
	| expr GE expr { $$ = operator(GE, 2, $1, $3); }
	| expr LE expr { $$ = operator(LE, 2, $1, $3); }
	| expr NE expr { $$ = operator(NE, 2, $1, $3); }
	| expr EQ expr { $$ = operator(EQ, 2, $1, $3); }
	| '(' expr ')' { $$ = $2; }
;

%%

#define SIZEOF_NODE ((char *)&p->constant - (char *)p)

Node* constant(int value) {
	Node *p = malloc(sizeof(Node));
	if (p == NULL)
		yyerror("out of memory");

	/* copy information */
	p->type = Constant;
	p->constant.value = value;

	return p;
}

Node* identifier(int index) {
	Node *p = malloc(sizeof(Node));

	if (!p)
		yyerror("out of memory");

	p->type = Identifier;
	p->identifier.index = index;

	return p;
}

Node* operator(int operator, int noprands, ...) {
	va_list ap;
	Node *p;
	int i;

	if ((p = malloc(sizeof(Node))) == NULL)
		yyerror("out of memory");
	if ((p->operator.oprands = malloc(noprands * sizeof(Node))) == NULL)
		yyerror("out of memory");

	p->type = Operator;
	p->operator.operator = operator;
	p->operator.noprands = noprands;
	va_start(ap, noprands);
	for (i = 0; i < noprands; ++i)
		p->operator.oprands[i] = va_arg(ap, Node *);
	va_end(ap);

	return p;
}

void freeNode(Node *p) {
	int i;
	if (!p)
		return;
	if (p->type == Operator) {
		for (i = 0; i < p->operator.noprands; ++i)
			freeNode(p->operator.oprands[i]);
		free(p->operator.oprands);
	}
	free(p);
}

void yyerror(char* errfmt, ...) {
	fprintf(stderr, "Error:%d\t", yylineno);
	va_list ap;
	va_start(ap, errfmt);
	vfprintf(stderr, errfmt, ap);
	fprintf(stderr, "\n");
	va_end(ap);
}

int main(int argc, char *argv[]) {
	yyparse();

	return 0;
}
