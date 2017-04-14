# reason-bin [![Build Status](https://travis-ci.org/yunxing/reason-bin.svg?branch=master)](https://travis-ci.org/yunxing/reason-bin)

Contains the prebuilt binaries needed for Reason's JavaScript workflow, as described [here](http://facebook.github.io/reason/jsWorkflow.html#javascript-workflow-editor-setup-global-utilities).

# Usage
```
npm install -g reason-bin
```
Make sure it works:
```
ocamlmerlin -version
```

# What's inside
Currently three binaries are provided:
- `refmt` -- For editors to reformat your reason files
- `ocamlmerlin` and `ocamlmerlin-reason` -- [Merlin](https://github.com/ocaml/merlin) provides SDK level integration with editors
- more -- Submit an issue to ask for more prebuilt binaries!

# Supported platforms
- Linux 64 bits
- Darwin 64 bits

**Help needed to get Windows support!**
