VERSION = 20220411

CC ?= cc
AR ?= ar
CFLAGS ?= -O2

PREFIX ?= /usr/local
INCDIR ?= include
LIBDIR ?= lib
MANDIR ?= share/man

REQUIRES = ncursesw
REQ_LIBS = `pkg-config --libs $(REQUIRES)`
REQ_CFLAGS = `pkg-config --cflags $(REQUIRES)`
REQ_LLIBS = `pkg-config --libs-only-l $(REQUIRES)`

EXTRA_CFLAGS = -I. -Wall -Wextra -fPIC

PATCHVER = 0
SOBASE = libedit.so
SONAME = $(SOBASE).0
SHAREDLIB = $(SONAME).0.$(PATCHVER)
STATICLIB = libedit.a
PCFILE = libedit.pc
MANS = editline.3 editline.7 editrc.5

MAN3_LINKS = el_init el_init_fd el_end el_reset el_gets el_wgets el_getc \
 el_wgetc el_push el_wpush el_parse el_wparse el_set el_wset el_get el_wget \
 el_source el_resize el_cursor el_line el_wline el_insertstr el_winsertstr \
 el_deletestr el_wdeletestr history_init history_winit history_end \
 history_wend history history_w tok_init tok_winit tok_end tok_wend \
 tok_reset tok_wreset tok_line tok_wline tok_str tok_wstr

AWK = awk

AHDR = vi.h emacs.h common.h
ASRC = vi.c emacs.c common.c
GHDR = fcns.h help.h func.h

OBJS = chared.o chartype.o common.o el.o eln.o emacs.o filecomplete.o \
 hist.o history.o historyn.o keymacro.o literal.o map.o parse.o prompt.o \
 read.o readline.o refresh.o search.o sig.o terminal.o tokenizer.o \
 tokenizern.o tty.o vi.o

# extra sources from netbsd
OBJS += unvis.o vis.o

all: $(SHAREDLIB) $(STATICLIB) $(PCFILE)

vi.h:
	AWK=$(AWK) sh makelist -h vi.c > vi.h

emacs.h:
	AWK=$(AWK) sh makelist -h emacs.c > emacs.h

common.h:
	AWK=$(AWK) sh makelist -h common.c > common.h

fcns.h: $(AHDR)
	AWK=$(AWK) sh makelist -fh $(AHDR) > fcns.h

help.h: $(ASRC)
	AWK=$(AWK) sh makelist -bh $(ASRC) > help.h

func.h: $(AHDR)
	AWK=$(AWK) sh makelist -fc $(AHDR) > func.h

%.o: %.c $(GHDR)
	$(CC) $(EXTRA_CFLAGS) $(REQ_CFLAGS) $(CFLAGS) -c -o $@ $<

# we special-case (un)vis.c so that they don't become public ABI by default

vis.o: vis.c
	$(CC) $(EXTRA_CFLAGS) $(CFLAGS) -fvisibility=hidden -c -o vis.o vis.c

unvis.o: unvis.c
	$(CC) $(EXTRA_CFLAGS) $(CFLAGS) -fvisibility=hidden -c -o unvis.o unvis.c

$(SHAREDLIB): $(OBJS)
	$(CC) $(OBJS) $(EXTRA_CFLAGS) $(REQ_CFLAGS) $(REQ_LIBS) \
		$(CFLAGS) $(LDFLAGS) -shared -Wl,-soname,$(SONAME) -o $(SHAREDLIB)

$(STATICLIB): $(OBJS)
	$(AR) -rcs $(STATICLIB) $(OBJS)

$(PCFILE): $(PCFILE).in
	PREFIX=$(PREFIX) LIBDIR=$(LIBDIR) INCDIR=$(INCDIR) VERSION=$(VERSION) \
	REQUIRES=$(REQUIRES) REQLIBS=$(REQ_LLIBS) sh genpc.sh $(PCFILE)

# no tests yet
check:
	:

clean:
	rm -f $(OBJS) $(AHDR) fcns.h help.h func.h \
		$(SHAREDLIB) $(STATICLIB) $(PCFILE)

install: $(SHAREDLIB) $(STATICLIB) $(PCFILE)
	# install the library
	install -d $(DESTDIR)$(PREFIX)/$(LIBDIR)
	install -m 755 $(SHAREDLIB) $(DESTDIR)$(PREFIX)/$(LIBDIR)/$(SHAREDLIB)
	install -m 644 $(STATICLIB) $(DESTDIR)$(PREFIX)/$(LIBDIR)/$(STATICLIB)
	ln -sf $(SHAREDLIB) $(DESTDIR)$(PREFIX)/$(LIBDIR)/$(SOBASE)
	ln -sf $(SHAREDLIB) $(DESTDIR)$(PREFIX)/$(LIBDIR)/$(SONAME)
	# install the headers
	install -d $(DESTDIR)$(PREFIX)/$(INCDIR)/editline
	install -m 644 histedit.h $(DESTDIR)$(PREFIX)/$(INCDIR)/histedit.h
	install -m 644 readline/readline.h \
		$(DESTDIR)$(PREFIX)/$(INCDIR)/editline/readline.h
	# install the pkg-config file
	install -d $(DESTDIR)$(PREFIX)/$(LIBDIR)/pkgconfig
	install -m 644 $(PCFILE) $(DESTDIR)$(PREFIX)/$(LIBDIR)/pkgconfig/$(PCFILE)
	# install the manpages
	install -d $(DESTDIR)$(PREFIX)/$(MANDIR)/man3
	install -d $(DESTDIR)$(PREFIX)/$(MANDIR)/man5
	install -d $(DESTDIR)$(PREFIX)/$(MANDIR)/man7
	install -m 644 editline.3 $(DESTDIR)$(PREFIX)/$(MANDIR)/man3/editline.3
	install -m 644 editrc.5 $(DESTDIR)$(PREFIX)/$(MANDIR)/man5/editrc.5
	install -m 644 editline.7 $(DESTDIR)$(PREFIX)/$(MANDIR)/man7/editline.7
	# install man3 links
	for link in $(MAN3_LINKS); do \
		ln -sf editline.3 $(DESTDIR)$(PREFIX)/$(MANDIR)/man3/$${link}.3; \
	done
