/*
 * Filename:	interpreter.c
 *
 * Author:		Oxnz
 * Email:		yunxinyi@gmail.com
 * Created:		[2014-11-20 09:41:54 CST]
 * Last-update:	2014-11-20 09:41:54 CST
 * Description: anchor
 *
 * Version:		0.0.1
 * Revision:	[NONE]
 * Revision history:	[NONE]
 * Date Author Remarks:	[NONE]
 *
 * License:
 * Copyright (c) 2013 Oxnz
 *
 * Distributed under terms of the [LICENSE] license.
 * [license]
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include "structure.h"
#include "micro.tab.h"

int ex(Node *p) { return interpret(p); }

int interpret(Node *p) {
	if (!p) return 0;
	switch (p->type) {
		case Constant:
			return p->constant.value;
		case Identifier:
			return symtbl[p->identifier.index];
		case Operator:
			switch (p->operator.operator) {
				case WHILE:
					while (interpret(p->operator.oprands[0]))
						interpret(p->operator.oprands[1]);
					return 0;
				case IF:
					if (interpret(p->operator.oprands[0]))
						interpret(p->operator.oprands[1]);
					else if (p->operator.noprands > 2)
						interpret(p->operator.oprands[2]);
					return 0;
				case PRINT:
					printf("%d\n", interpret(p->operator.oprands[0]));
					return 0;
				case ';':
					interpret(p->operator.oprands[0]);
					return interpret(p->operator.oprands[1]);
				case '=':
					return symtbl[p->operator.oprands[0]->identifier.index] = interpret(p->operator.oprands[1]);
				case UMINUS:
					return -interpret(p->operator.oprands[0]);
				case '+':
					return interpret(p->operator.oprands[0]) + interpret(p->operator.oprands[1]);
				case '-':
					return interpret(p->operator.oprands[0]) - interpret(p->operator.oprands[1]);
				case '*':
					return interpret(p->operator.oprands[0]) * interpret(p->operator.oprands[1]);
				case '/':
					return interpret(p->operator.oprands[0]) / interpret(p->operator.oprands[1]);
				case '<':
					return interpret(p->operator.oprands[0]) < interpret(p->operator.oprands[1]);
				case '>':
					return interpret(p->operator.oprands[0]) > interpret(p->operator.oprands[1]);
				case LE:
					return interpret(p->operator.oprands[0]) <= interpret(p->operator.oprands[1]);
				case GE:
					return interpret(p->operator.oprands[0]) >= interpret(p->operator.oprands[1]);
				case NE:
					return interpret(p->operator.oprands[0]) != interpret(p->operator.oprands[1]);
				case EQ:
					return interpret(p->operator.oprands[0]) == interpret(p->operator.oprands[1]);
				default:
					fprintf(stderr, "invalid operator");
					exit(-1);
			}
		default:
			fprintf(stderr, "invalid node type");
			exit(-1);
	}
	return 0;
}
