%{
#include "y.tab.h"
#define LOOKUP 0
int state;
%}
%%
\n { state = LOOKUP; }

\.\n { state = LOOKUP; return 0; } // sentence end

^verb	{ state = VERB; }
^adj	{ state = ADJECTIVE; }
^adv	{ state = ADVERB; }
^noun	{ state = NOUN; }
^prep	{ state = PREPOSITION; }
^pron	{ state = PRONOUN; }
^conj	{ state = CONJUNCTION; }

[a-zA-Z]+ {
	if (state != LOOKUP) {
		add_word(state, yytext);
	} else {
		switch (lookup_word(yytext)) {
			case VERB:
				return VERB;
				break;
			case ADJECTIVE:
				return ADJECTIVE;
				break;
			case ADVERB:
				return ADVERB;
				break;
			case NOUN:
				return NOUN;
				break;
			case PREPOSITION:
				return PREPOSITION;
			case PRONOUN:
				return PRONOUN;
			case CONJUNCTION:
				return CONJUNCTION;
			default:
				printf("%s: don't recognize\n", yytext);
		}
	}
}
