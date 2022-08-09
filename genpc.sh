#!/bin/sh

sed -e "s,@prefix@,${PREFIX}," \
    -e "s,@exec_prefix@,\${prefix}," \
    -e "s,@libdir@,\${exec_prefix}/${LIBDIR}," \
    -e "s,@includedir@,\${prefix}/${INCDIR}," \
    -e "s,@VERSION@,${VERSION}," \
    -e "s,@REQUIRES@,${REQUIRES}," \
    -e "s,@LIBS@,${REQLIBS}," \
    $1.in > $1
