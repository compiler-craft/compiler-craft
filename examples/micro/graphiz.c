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
#include <string.h>
#include "structure.h"
#include "micro.tab.h"

int ex(Node *p) { return graphiz(p); }

int del = 1; /* distance of graph columns */
int eps = 3; /* distance of graph lines */
/* interface for drawing (can be replaced by "real" graphic using GD or
 * other) */
void graphInit (void);
void graphFinish();
void graphBox (char *s, int *w, int *h);
void graphDrawBox (char *s, int c, int l);
void graphDrawArrow (int c1, int l1, int c2, int l2);
/* recursive drawing of the syntax tree */
void graphizNode (Node *p, int c, int l, int *ce, int *cm);
/***********************************************************/
/* main entry point of the manipulation of the syntax tree */
int graphiz (Node *p) {
	int rte, rtm;
	graphInit ();
	graphizNode (p, 0, 0, &rte, &rtm);
	graphFinish();
	return 0;
}

void graphizNode(Node *p,
		int c, int l, /* start column and line */
		int *ce, int *cm /* resulting end column and mid of node */
		) {
	int w, h;	/* node width and height */
	char *s;	/* node text */
	int cbar;	/* real start column of node (centered above subnodes) */
	int k;		/* children number */
	int che, chm;
	int cs;
	char word[20];

	if (!p) return;

	strcpy(word, "???");	/* should never appear */
	s = word;
	switch (p->type) {
		case Constant:
			sprintf(word, "c(%d)", p->constant.value);
			break;
		case Identifier:
			sprintf(word, "id(%d)", p->identifier.index + 'a');
			break;
		case Operator:
			switch(p->operator.operator){
				case WHILE: s = "while";break;
				case IF:	s = "if";	break;
				case PRINT: s = "print";break;
				case ';':	s = "[;]";	break;
				case '=':	s = "[=]";	break;
				case UMINUS:s = "[_]";	break;
				case '+':	s = "[+]";	break;
				case '-':	s = "[-]";	break;
				case '*':	s = "[*]";	break;
				case '/':	s = "[/]";	break;
				case '<':	s = "[<]";	break;
				case '>':	s = "[>]";	break;
				case GE:	s = "[>=]"; break;
				case LE:	s = "[<=]"; break;
				case NE:	s = "[!=]"; break;
				case EQ:	s = "[==]"; break;
				default:
					fprintf(stderr, "invalid operator");
					exit(-1);
			}
			break;
		default:
			fprintf(stderr, "invalid node type");
			exit(-1);
	}
	graphBox(s, &w, &h);
	cbar = c;
	*ce = c+w;
	*cm = c+w/2;

	if (p->type == Constant || p->type == Identifier || p->operator.noprands == 0) {
		graphDrawBox (s, cbar, l);
		return;
	}

	cs = c;
	for (k = 0; k < p->operator.noprands; k++) {
		graphizNode (p->operator.oprands[k], cs, l+h+eps, &che, &chm);
		cs = che;
	}
	/* total node width */
	if (w < che - c) {
		cbar += (che - c - w) / 2;
		*ce = che;
		*cm = (c + che) / 2;
	}
	/* draw node */
	graphDrawBox (s, cbar, l);
	/* draw arrows (not optimal: children are drawn a second time) */
	cs = c;
	for (k = 0; k < p->operator.noprands; k++) {
		graphizNode (p->operator.oprands[k], cs, l+h+eps, &che, &chm);
		graphDrawArrow (*cm, l+h, chm, l+h+eps-1);
		cs = che;
	}
}

#define lmax 200
#define cmax 200

char graph[lmax][cmax]; /* array for ASCII-Graphic */
int graphNumber = 0;
void graphTest (int l, int c)
{
	int ok;
	ok = 1;
	if (l < 0) ok = 0;
	if (l >= lmax) ok = 0;
	if (c < 0) ok = 0;
	if (c >= cmax) ok = 0;
	if (ok) return;
	printf ("\n+++error: l=%d, c=%d not in drawing rectangle 0, 0 ...  %d, %d",
			l, c, lmax, cmax);
	exit (1);
}
void graphInit (void) {
	int i, j;
	for (i = 0; i < lmax; i++) {
		for (j = 0; j < cmax; j++) {
			graph[i][j] = ' ';
		}
	}
}

void graphFinish() {
	int i, j;
	for (i = 0; i < lmax; i++) {
		for (j = cmax-1; j > 0 && graph[i][j] == ' '; j--);
		graph[i][cmax-1] = 0;
		if (j < cmax-1) graph[i][j+1] = 0;
		if (graph[i][j] == ' ') graph[i][j] = 0;
	}
	for (i = lmax-1; i > 0 && graph[i][0] == 0; i--);
	printf ("\n\nGraph %d:\n", graphNumber++);
	for (j = 0; j <= i; j++) printf ("\n%s", graph[j]);
	printf("\n");
}
void graphBox (char *s, int *w, int *h) {
	*w = strlen (s) + del;
	*h = 1;
}
void graphDrawBox (char *s, int c, int l) {
	int i;
	graphTest (l, c+strlen(s)-1+del);
	for (i = 0; i < strlen (s); i++) {
		graph[l][c+i+del] = s[i];
	}
}

void graphDrawArrow (int c1, int l1, int c2, int l2) {
		int m;
		graphTest (l1, c1);
		graphTest (l2, c2);
		m = (l1 + l2) / 2;
		while (l1 != m) {
			graph[l1][c1] = '|'; if (l1 < l2) l1++; else l1--;
		}
		while (c1 != c2) {
			graph[l1][c1] = '-'; if (c1 < c2) c1++; else c1--;
		}
		while (l1 != l2) {
			graph[l1][c1] = '|'; if (l1 < l2) l1++; else l1--;
		}
		graph[l1][c1] = '|';
}
