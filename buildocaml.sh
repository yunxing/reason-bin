#!/bin/sh
set -e

export OCAMLPARAM='_,bin-annot=1'
export OCAMLRUNPARAM=b

BSB=$(which bsb)
if [ $? -eq 0 ]
then
    BSBDIR=$(dirname $(realpath $BSB))
    LIBDIR="$($BSBDIR/bsc.exe -where)/.."
else
    OCAML=ocaml_src
    rm -rf $OCAML
    echo "creating ocaml from github"
    git clone -b master --depth 1 https://github.com/bloomberg/ocaml $OCAML

    cd $OCAML && ./configure -prefix "$(dirname "$PWD")"  -no-ocamldoc -no-ocamlbuild -no-shared-libs -no-curses -no-graph -no-pthread -no-debugger  && make -j9 world.opt && make install  && cd ..
    LIBDIR=$PWD/lib
fi
# generate findlib file
echo "destdir=\"$LIBDIR\"" > findlib.conf
echo "path=\"$LIBDIR\"" >> findlib.conf
