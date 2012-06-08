###############################################################################
#
# File:         Makefile
# RCS:          $Id: Makefile,v 1.2 2011/01/31 20:29:00 fabianb Exp $
# Language:     Makefile
# Status:       Experimental (Do Not Distribute)
#
# (C} Copyright 2005, Northwestern University, all rights reserved.
#
###############################################################################


LATEX= latex
PDFLATEX=pdflatex
BIBTEX= bibtex
XDVI = xdvi
DVIPDF= dvipdfm -p letter
PS2PDF= ps2pdf
DVIPS= dvips -t letter -P pdf
RM = /bin/rm -f
CAT = cat
ISPELL = ispell
SORT = sort

MAINDOC = transmem
MAINPDF = ${MAINDOC}.pdf

DVIDOCS = ${MAINPDF:.pdf=.dvi} ${AUXPDF:.pdf=.dvi}
DVIDOCS = ${MAINPS:.ps=.dvi} ${AUXPS:.ps=.dvi}

all: ${MAINPDF} ${MAINPS} ${AUXPDF} clean

%.pdf:  %.tex
	${PDFLATEX} $*
	if grep -s "^LaTeX Warning: Citation" $*.log ;  \
	then \
	        ${BIBTEX} $* ; \
	        ${PDFLATEX} $* ; \
	        ${PDFLATEX} $* ; \
	fi ; \
	while grep -s "Rerun to get cross-references right" $*.log ; \
	do \
	        ${PDFLATEX} $* ; \
	done

%.ps: %.dvi
	${DVIPS} $*

%.dvi: %.tex
	${LATEX} $*
	if grep -s "^LaTeX Warning: Citation" $*.log ;  \
	then \
		${BIBTEX} $* ; \
		${LATEX} $* ; \
		${LATEX} $* ; \
	fi ; \
	while grep -s "Rerun to get cross-references right" $*.log ; \
	do \
		${LATEX} $* ; \
	done

%.bbl: %.bib
	${BIBTEX} $*

spell:
	${CAT} *.tex *.bib | ${ISPELL} -t -l | ${SORT} -u > spell.out

clean:	
	${RM} *.aux *.bbl *.dvi *.log *.blg *~ *.bak figs/*.bak

cleanAll: clean
	${RM} *.dvi *.ps *.pdf
