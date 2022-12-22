INSTALL = install
INSTALL_DIRECTORY = $(INSTALL) -d -m 0755
INSTALL_FILE = $(INSTALL) -m 0644
INSTALL_EXECUTABLE = $(INSTALL) -m 0755

# semi-standard dirs
DESTDIR :=
SYSCONFDIR := $(DESTDIR)/etc
BINDIR := $(DESTDIR)/usr/bin
PKGLIBDIR := $(DESTDIR)/usr/lib/pbuilder
SBINDIR := $(DESTDIR)/usr/sbin
PKGDATADIR := $(DESTDIR)/usr/share/pbuilder

define newline


endef

NULL :=

ALLDIRS += BASHCOMPLETION
BASHCOMPLETIONDIR := $(PKGDATADIR)/../bash-completion/completions/
BASHCOMPLETION_DATA += \
	bash_completion.d/pbuilder \
	$(NULL)
CHECK_SCRIPTS += bash_completion.d/pbuilder

ALLDIRS += PBUILDERCONF
PBUILDERCONFDIR := $(SYSCONFDIR)/pbuilder
PBUILDERCONF_DATA += \
	$(NULL)

ALLDIRS += BIN
BIN_SCRIPTS += \
	debuild-pbuilder \
	pdebuild \
	$(NULL)

ALLDIRS += PKGLIB
PKGLIB_SCRIPTS += \
	pbuilder-apt-config \
	pbuilder-buildpackage \
	pbuilder-buildpackage-funcs \
	pbuilder-checkparams \
	pbuilder-createbuildenv \
	pbuilder-loadconfig \
	pbuilder-modules \
	pbuilder-runhooks \
	pbuilder-satisfydepends-apt \
	pbuilder-satisfydepends-aptitude \
	pbuilder-satisfydepends-checkparams \
	pbuilder-satisfydepends-classic \
	pbuilder-satisfydepends-experimental \
	pbuilder-satisfydepends-funcs \
	pbuilder-satisfydepends-gdebi \
	pbuilder-unshare-wrapper \
	pbuilder-updatebuildenv \
	pdebuild-checkparams \
	pdebuild-internal \
	$(NULL)

ALLDIRS += SBIN
SBIN_SCRIPTS += \
	pbuilder \
	$(NULL)

ALLDIRS += EXAMPLE
EXAMPLEDIR := $(DESTDIR)/usr/share/doc/pbuilder/examples
EXAMPLE_DATA += \
	pbuilderrc \
	$(NULL)
CHECK_SCRIPTS += pbuilderrc
EXAMPLE_SCRIPTS += \
	examples/B90lintian \
	examples/B91dpkg-i \
	examples/B92test-pkg \
	examples/C10shell \
	examples/C11screen \
	examples/D10tmp \
	examples/D20addnonfree \
	examples/D65various-compiler-support \
	examples/D80no-man-db-rebuild \
	examples/D90chrootmemo \
	examples/F90chrootmemo \
	examples/B90list-missing \
	examples/B91debc \
	examples/B20autopkgtest \
	examples/execute_installtest.sh \
	examples/execute_paramtest.sh \
	examples/pbuilder-distribution.sh \
	$(NULL)

ALLDIRS += EXAMPLE_LVMPBUILDER
EXAMPLE_LVMPBUILDERDIR := $(EXAMPLEDIR)/lvmpbuilder
EXAMPLE_LVMPBUILDER_DATA += \
	examples/lvmpbuilder/README \
	examples/lvmpbuilder/STRATEGY \
	$(NULL)
EXAMPLE_LVMPBUILDER_SCRIPTS += \
	examples/lvmpbuilder/lvmbuilder \
	$(NULL)

ALLDIRS += EXAMPLE_LVMPBUILDER_LIB
EXAMPLE_LVMPBUILDER_LIBDIR := $(EXAMPLE_LVMPBUILDERDIR)/lib
EXAMPLE_LVMPBUILDER_LIB_SCRIPTS += \
	examples/lvmpbuilder/lib/lvmbuilder-checkparams \
	examples/lvmpbuilder/lib/lvmbuilder-modules \
	examples/lvmpbuilder/lib/lvmbuilder-unimplemented \
	$(NULL)

ALLDIRS += EXAMPLE_PBUILDERTEST
EXAMPLE_PBUILDERTESTDIR := $(EXAMPLEDIR)/pbuilder-test
EXAMPLE_PBUILDERTEST_DATA += \
	examples/pbuilder-test/README \
	examples/pbuilder-test/002_sample.c \
	$(NULL)
EXAMPLE_PBUILDERTEST_SCRIPTS += \
	examples/pbuilder-test/000_prepinstall \
	examples/pbuilder-test/001_apprun \
	examples/pbuilder-test/002_libfile \
	examples/pbuilder-test/003_makecheck \
	examples/pbuilder-test/004_ldd \
	$(NULL)

ALLDIRS += EXAMPLE_REBUILD
EXAMPLE_REBUILDDIR := $(EXAMPLEDIR)/rebuild
EXAMPLE_REBUILD_DATA += \
	examples/rebuild/README \
	$(NULL)
EXAMPLE_REBUILD_SCRIPTS += \
	examples/rebuild/buildall \
	examples/rebuild/getlist \
	$(NULL)

ALLDIRS += PKGDATA
PKGDATA_DATA += \
	pbuilderrc \
	$(NULL)
CHECK_SCRIPTS += \
	pbuilderrc \
	$(NULL)

NOINST_MANPAGES += \
	debuild-pbuilder.1 \
	pbuilder.8 \
	pbuilderrc.5 \
	pdebuild.1 \
	$(NULL)
CHECK_MANPAGES += $(NOINST_MANPAGES)

# TODO: check subdirs etc.

CHECK_SCRIPTS += $(foreach d,$(ALLDIRS),$($(d)_SCRIPTS))

all:
	$(MAKE) -C pbuildd $@
	$(MAKE) -C Documentation $@

check: export PBUILDER_CHECKOUT := $(CURDIR)
check:
	# syntax check.
	$(foreach script,$(CHECK_SCRIPTS),bash -n $(script)$(newline))
	$(foreach mp,$(CHECK_MANPAGES),LANG=C MANWIDTH=80 man --warnings -l $(mp) >/dev/null$(newline))
	# unit tests.
	$(foreach test,$(wildcard ./t/test_*),$(test)$(newline))

full-check:
	# system tests that might take long.
	cd testsuite && ./run-test.sh

clean:
	rm -f *.bak *~ TAGS
	rm -rfv testsuite/testimage \
		testsuite/testbuild \
		testsuite/testbuild2 \
		testsuite/regression/work
	$(MAKE) -C pbuildd $@
	$(MAKE) -C Documentation $@

TAGS:
	etags pbuilder-* pbuilder

define install_dir_impl
$(INSTALL_DIRECTORY) $($(1)DIR)$(newline)
$(foreach file,$($(1)_DATA),$(INSTALL_FILE) $(file) $($(1)DIR)$(newline))
$(foreach script,$($(1)_SCRIPTS),$(INSTALL_EXECUTABLE) $(script) $($(1)DIR)$(newline))
endef

install:
	$(foreach d,$(ALLDIRS),$(call install_dir_impl,$(d)))
	$(INSTALL_DIRECTORY) $(DESTDIR)/var/cache/pbuilder/pbuilder-mnt
	# install -aptitude flavour as the default satisfydepends
	ln -sf pbuilder-satisfydepends-aptitude $(PKGLIBDIR)/pbuilder-satisfydepends
	$(MAKE) -C pbuildd $@
	$(MAKE) -C Documentation $@

