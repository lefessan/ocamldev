all:
	$(MAKE) -f Makefile.depends all
byte:
	$(MAKE) -f Makefile.depends byte
opt:
	$(MAKE) -f Makefile.depends opt
depend:
	$(MAKE) -f Makefile.depends depend
clean:
	$(MAKE) -f Makefile.rules clean
distclean:
	$(MAKE) -f Makefile.rules distclean
doc:
	$(MAKE) -f Makefile.rules doc
