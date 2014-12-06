/*
 * Filename:	compiler.c
 *
 * Author:		Oxnz
 * Email:		yunxinyi@gmail.com
 * Created:		[2014-11-20 09:42:55 CST]
 * Last-update:	2014-11-20 09:42:55 CST
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

int ex(Node *p) { return compile(p); }

int compile(Node *p) {
	static int label = -1;
	int label1, label2;

	if (!p) return 0;
	switch (p->type) {
		case Constant:
			printf("\tpush\t%d\n", p->constant.value);
			break;
		case Identifier:
			printf("\tpush\t%c\n", p->identifier.index + 'a');
			break;
		case Operator:
			switch (p->operator.operator) {
				case WHILE:
					printf("L%03d:\n", label1 = ++label);
					compile(p->operator.oprands[0]);
					printf("\tjz\tL%03d\n", label2 = ++label);
					compile(p->operator.oprands[1]);
					printf("\tjmp\tL%03d\n", label1);
					printf("L%03d:\n", label2);
					break;
				case IF:
					compile(p->operator.oprands[0]);
					if (p->operator.noprands > 2) {
						/* test else
						 * jz else
						 * ...
						 * jmp done
						 * else:
						 * ...
						 * done
						 */
						printf("\tjz\tL%03d\n", label1 = ++label);
						compile(p->operator.oprands[1]);
						printf("\tjmp\tL%03d\n", label2 = ++label);
						printf("L%03d:\n", label1);
						compile(p->operator.oprands[2]);
						printf("L%03d:\n", label2);
					} else {
						/* if */
						printf("\tjz\tL%03d\n", label1 = ++label);
						compile(p->operator.oprands[1]);
						printf("L%03d:\n", label1);
					}
					break;
				case PRINT:
					compile(p->operator.oprands[0]);
					printf("\tprint\n");
					break;
				case ';':
					compile(p->operator.oprands[0]);
					compile(p->operator.oprands[1]);
					break;
				case '=':
					compile(p->operator.oprands[1]);
					printf("\tpop\t%c\n", p->operator.oprands[0]->identifier.index + 'a');
					break;
				case UMINUS:
					compile(p->operator.oprands[0]);
					printf("\tneg\n");
					break;
				case '+':
					compile(p->operator.oprands[0]);
					compile(p->operator.oprands[1]);
					printf("\tadd\n");
					break;
				case '-':
					compile(p->operator.oprands[0]);
					compile(p->operator.oprands[1]);
					printf("\tsub\n");
					break;
				case '*':
					compile(p->operator.oprands[0]);
					compile(p->operator.oprands[1]);
					printf("\tmul\n");
					break;
				case '/':
					compile(p->operator.oprands[0]);
					compile(p->operator.oprands[1]);
					printf("\tdiv\n");
					break;
				case '<':
					compile(p->operator.oprands[0]);
					compile(p->operator.oprands[1]);
					printf("\tlt\n");
					break;
				case '>':
					compile(p->operator.oprands[0]);
					compile(p->operator.oprands[1]);
					printf("\tgt\n");
					break;
				case LE:
					compile(p->operator.oprands[0]);
					compile(p->operator.oprands[1]);
					printf("\tle\n");
					break;
				case GE:
					compile(p->operator.oprands[0]);
					compile(p->operator.oprands[1]);
					printf("\tge\n");
					break;
				case NE:
					compile(p->operator.oprands[0]);
					compile(p->operator.oprands[1]);
					printf("\tne\n");
					break;
				case EQ:
					compile(p->operator.oprands[0]);
					compile(p->operator.oprands[1]);
					printf("\teq\n");
					break;
				default:
					fprintf(stderr, "invalid operator");
					exit(-1);
			}
			break;
		default:
			fprintf(stderr, "invalid node type");
			exit(-1);
	}

	return 0;
}
