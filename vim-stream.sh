#!/bin/bash
vims() {
    vim - -nes -u NONE "$@" -c ':%p' -c ':q!' | tail -n +2
}
