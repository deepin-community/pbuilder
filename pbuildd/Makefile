PBUILDDDIR=/usr/share/doc/pbuilder/examples/pbuildd/

all:

clean:
	rm -f *~

install:
	install -d $(DESTDIR)$(PBUILDDDIR)
	install -d $(DESTDIR)$(PBUILDDDIR)/hookdir
	install -d $(DESTDIR)/var/cache/pbuilder/pbuildd
	install -m 755 buildd.sh $(DESTDIR)$(PBUILDDDIR)
	install -m 644 buildd-config.sh $(DESTDIR)/etc/pbuilder/
	install -m 755 hookdir/A10dpkg-l.sh $(DESTDIR)$(PBUILDDDIR)/hookdir
