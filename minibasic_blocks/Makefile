# OS type: Linux/Win DJGPP
ifdef OS
   EXE=.exe
else
   EXE=
endif

OCAMLC_FLAGS=-g
OCAMLC=ocamlc
OCAMLDEP=ocamldep

%.cmo: %.ml %.mli
	$(OCAMLC) $(OCAMLC_FLAGS) -c $<

%.cmi: %.mli
	$(OCAMLC) $(OCAMLC_FLAGS) -c $<

%.cmo %.cmi: %.ml
	$(OCAMLC) $(OCAMLC_FLAGS) -c $<

minibasic$(EXE): Ast.cmo Lexer.cmo Parser.cmo Symbol.cmo \
	Sem.cmo Interp.cmo Main.cmo
	$(OCAMLC) $(OCAMLC_FLAGS) -o $@ $^

Lexer.ml: Lexer.mll
	ocamllex -o $@ $<

Parser.ml Parser.mli: Parser.mly
	ocamlyacc -v Parser.mly

.PHONY: clean distclean

-include .depend

depend: Ast.ml Lexer.ml Lexer.mli Parser.ml Parser.mli Sem.ml Sem.mli \
	Symbol.ml Symbol.mli Interp.ml Interp.mli Main.ml
	$(OCAMLDEP) $^ > .depend

clean:
	$(RM) Lexer.ml Parser.ml Parser.mli Parser.output *.cmo *.cmi *~

distclean: clean
	$(RM) minibasic$(EXE) .depend
