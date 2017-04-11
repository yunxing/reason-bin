#!/bin/sh
set -e

export OCAMLPARAM='_,bin-annot=1'
export OCAMLRUNPARAM=b

OCAML=ocaml_src
if [  -f "ocaml.tar.gz" ]
then
    echo "ocaml.tar.gz already exists"
    rm -rf $OCAML
    mkdir -p $OCAML
    tar -zxvf ./ocaml.tar.gz -C $OCAML
else
    echo "creating ocaml from github"
    if [ -d "$OCAML" ]
    then
        cd $OCAML && git reset --hard && git pull --depth 1 && cd -
    else
        git clone -b master --depth 1 https://github.com/bloomberg/ocaml $OCAML
    fi
fi

cd $OCAML && ./configure -prefix "$(dirname "$PWD")"  -no-ocamldoc -no-ocamlbuild -no-shared-libs -no-curses -no-graph -no-pthread -no-debugger  && make -j9 world.opt && make install  && cd ..

# generate findlib file
echo "destdir=\"$PWD/lib\"" > findlib.conf
echo "path=\"$PWD/lib\"" >> findlib.conf
