%{
// used to parse english word
#include <stdio.h>
%}

%token NOUN PRONOUN VERB ADVERB ADJECTIVE PREPOSITION CONJUNCTION

%%
sentence: subject VERB object { printf("Sentence is valid.\n"); }
		;
subject: NOUN
	   | PRONOUN
	   ;
object: NOUN
%%

void yyerror(char *errmsg) {
	fprintf(stderr, "%s\n", errmsg);
}

int main(int argc, char *argv[]) {
	extern FILE* yyin;
	do {
		yyparse();
	} while (!feof(yyin));

	return 0;
}
