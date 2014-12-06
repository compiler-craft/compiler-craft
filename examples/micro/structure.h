/*
 * Filename:	define.c
 *
 * Author:		Oxnz
 * Email:		yunxinyi@gmail.com
 * Created:		[2014-11-20 08:53:20 CST]
 * Last-update:	2014-11-20 08:53:20 CST
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

typedef enum { Constant, Identifier, Operator } NodeType;

typedef struct {
	int value;
} ConstantNode;

typedef struct {
	int index;	/* subscriptor to sym array */
} IdentifierNode;

typedef struct {
	int operator;	/* operator */
	int noprands;	/* number of operands */
	struct Node **oprands;	/* operands */
} OperatorNode;

typedef struct Node {
	NodeType type;

	union {
		ConstantNode constant;
		IdentifierNode identifier;
		OperatorNode operator;
	};
} Node;

extern int symtbl[26];
