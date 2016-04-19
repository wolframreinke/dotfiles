BIBMAKER = bibtex&(FILENAME=Makefile)
PDFMAKER = pdflatex
GLSMAKER = makeglossaries
PDFJOIN  = pdftk

NAME     = %(name)

OUT_DIR  = out

BIBFILE  = $$(NAME).bib
TEXFILE  = $$(NAME).tex
DEPS     = src/*.tex #lst/* img/*

PDFFILE  = $$(OUT_DIR)/$$(NAME).pdf

.PHONY: all
all: $$(PDFFILE)

.PHONY: clean
clean:
	rm *.acn *.acr *.alg *.aux *.glg *.glo *.gls *.ist *.lof *.log *.out *.tdo *.toc *.pdf *.bbl *.blg > /dev/null 2>&1 || :

$$(PDFFILE): $$(TEXFILE) $$(DEPS)
	$$(PDFMAKER) $$(TEXFILE)
	$$(GLSMAKER) $$(NAME)
	$$(BIBMAKER) $$(NAME).aux
	$$(PDFMAKER) $$(TEXFILE)
	$$(PDFMAKER) $$(TEXFILE)
