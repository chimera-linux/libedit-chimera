/* customized for musl setups, tweak for others */

/* pick one */
#define HAVE_CURSES_H 1
/* #undef HAVE_NCURSES_H */

/* pick one */
/* #undef HAVE_GETPW_R_DRAFT */
#define HAVE_GETPW_R_POSIX 1

/* #undef HAVE_SYS_CDEFS_H */
#define HAVE_TERMCAP_H 1
#define HAVE_TERM_H 1

#define HAVE_GETLINE 1
#define HAVE_ISSETUGID 1
#define HAVE_STRLCAT 1
#define HAVE_STRLCPY 1
/* #undef HAVE_STRUCT_DIRENT_D_NAMLEN */
/* #undef HAVE_STRUNVIS */
/* #undef HAVE_STRVIS */
#define HAVE_U_INT32_T 1
/* #undef HAVE_VIS */

#ifndef _GNU_SOURCE
# define _GNU_SOURCE 1
#endif

#define HAVE_SIZE_MAX 1

#include "sys.h"
