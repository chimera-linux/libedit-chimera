# libedit-chimera

Current version: 20220921 (NetBSD trunk: PR/57016: Ricky Zhou: declare lastidx)

This is a simplistic port of libedit from NetBSD upstream.

It provides the same functionality as https://www.thrysoee.dk/editline/
except it's in sync with NetBSD upstream (so we get latest features)
instead of random snapshots without any kind of version control and
has a simpler build system without requiring autotools.

The current configuration is most likely very much tied to musl and
you may run into issues in other setups (e.g. `glibc` will be missing
the BSD `strl*` functions which we don't provide fallbacks for, etc.)
