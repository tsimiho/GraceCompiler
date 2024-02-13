.PHONY: clean distclean pack count

# OS type: Linux/Win DJGPP
ifdef OS
   EXE=.exe
else
   EXE=
endif

EXEFILE=grace$(EXE)
MLFILES=Hashcons.ml Identifier.ml Error.ml Types.ml Narray.ml Symbol.ml \
  Codegen.ml Lexer.ml Parser.ml Main.ml
MLIFILES=Hashcons.mli Identifier.mli Error.mli Types.mli Narray.mli Symbol.mli \
  Parser.mli Lexer.mli 
CMOFILES=$(patsubst %.ml,%.cmo,$(MLFILES))
CMIFILES=$(patsubst %.ml,%.cmi,$(MLFILES))
CMXFILES=$(patsubst %.ml,%.cmx,$(MLFILES))
OBJFILES=$(patsubst %.ml,%.o,$(MLFILES))
PARSERFILES=Parser.ml Parser.mli Parser.output Lexer.ml
SRCFILES=Makefile extend.ml Lexer.mll Parser.mly \
  $(filter-out Parser.% Lexer.%,$(MLFILES)) \
  $(filter-out Parser.%,$(MLIFILES))

CAMLP5_FLAGS=-pp "camlp5o ./extend.cmo"
OCAMLC_FLAGS=-g
OCAMLOPT_FLAGS=
OCAMLC=ocamlc $(OCAMLC_FLAGS)
OCAMLOPT=ocamlopt $(OCAMLOPT_FLAGS)
OCAMLDEP=ocamldep
LLVM_PACKAGES=-package llvm -package llvm.analysis -package llvm.scalar_opts \
	      -package llvm.ipo -package llvm.all_backends -package llvm.target
INCLUDES=

default: $(EXEFILE)

symbtest$(EXE): $(filter-out Lexer.cmo Parser.cmo,$(CMOFILES))
	$(OCAMLC) -o $@ $^

all: $(EXEFILE)

extend.cmo: extend.ml
	$(OCAMLC) -pp "camlp5o pa_extend.cmo q_MLast.cmo" -I `camlp5 -where` -c $<

%.cmo: %.ml %.mli extend.cmo
	$(OCAMLC) $(CAMLP5_FLAGS) -c $<

%.cmx: %.ml extend.cmo
	$(OCAMLOPT) $(CAMLP5_FLAGS) -c $<

%.cmi: %.mli extend.cmo
	$(OCAMLC) $(CAMLP5_FLAGS) -c $<

%.cmo %.cmi: %.ml extend.cmo
	ocamlfind $(OCAMLC) $(CAMLP5_FLAGS) $(LLVM_PACKAGES) -c $<

.PHONY: all clean count depend

$(EXEFILE): Parser.mli Lexer.ml $(CMOFILES)
	ocamlfind $(OCAMLC) $(LLVM_PACKAGES) -linkpkg -o $@ $(CMOFILES)

Parser.ml Parser.mli: Parser.mly
	ocamlyacc -v --unused-precedence-levels Parser.mly

Lexer.ml: Lexer.mll
	ocamllex Lexer.mll

Parser.cmi: Parser.mli
	ocamlfind $(OCAMLC) $(CAMLP5_FLAGS) $(LLVM_PACKAGES) -c Parser.mli

Parser.cmo: Parser.ml Parser.cmi
	ocamlfind $(OCAMLC) $(CAMLP5_FLAGS) $(LLVM_PACKAGES) -c Parser.ml

-include .depend

depend: $(MLFILES) $(MLIFILES) extend.cmo
	$(OCAMLDEP) $(CAMLP5_FLAGS) $(INCLUDES) \
          $(filter-out extend.cmo,$^) > .depend

# depend-symbtest: Hashcons.ml Identifier.ml Error.ml Types.ml Symbol.ml \
#                  Symbtest.ml Hashcons.mli Identifier.mli Error.mli Types.mli \
#                  Symbol.mli Narray.mli extend.cmo
# 	$(OCAMLDEP) $(CAMLP5_FLAGS) $(INCLUDES) \
#           $(filter-out extend.cmo,$^) > .depend

clean:
	$(RM) $(CMXFILES) $(CMOFILES) $(CMIFILES) $(OBJFILES) $(EXEFILES) \
           extend.cmi extend.cmo \
           $(patsubst %,%.cm?,$(EXEFILES)) $(PARSERFILES) pplib.cma *~

distclean: clean
	$(RM) $(EXEFILE) symbtest$(EXE) .depend Parser.automaton Parser.conflicts

pack: clean
	tar cvfz grace.tar.gz $(SRCFILES)

bonus.zip: distclean
	zip bonus.zip README Makefile extend.ml \
	    Hashcons.mli Identifier.mli Error.mli Types.mli Symbol.mli \
	    Hashcons.ml Identifier.ml Error.ml Types.ml Symbol.ml Symbtest.ml

bonus.tgz: distclean
	tar cvfz bonus.tgz README Makefile extend.ml \
	    Hashcons.mli Identifier.mli Error.mli Types.mli Symbol.mli \
	    Hashcons.ml Identifier.ml Error.ml Types.ml Symbol.ml Symbtest.ml

count:
	wc -l $(SRCFILES)
