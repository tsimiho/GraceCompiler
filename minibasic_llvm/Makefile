.PHONY: default all clean FORCE

LLVMCONFIG=llvm-config
LLVMLDFLAGS=-L`$(LLVMCONFIG) --libdir`
LLVMPACKAGES=llvm,llvm.analysis,llvm.all_backends,llvm.scalar_opts

OCAMLBUILD=ocamlbuild
OCAMLBUILDFLAGS=-pkgs $(LLVMPACKAGES) -lflags -cclib,$(LLVMLDFLAGS)

default: Main.native

Main.native: FORCE
	$(OCAMLBUILD) $(OCAMLBUILDFLAGS) $@

Main.byte: FORCE
	$(OCAMLBUILD) $(OCAMLBUILDFLAGS) $@

clean:
	$(OCAMLBUILD) -clean
	$(RM) a.ll a.s a.out
	$(RM) *~

