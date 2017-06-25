#!/bin/bash
vims() {
    vim - -nes -u NONE $(for arg in "$@"; do echo "-c $arg"; done) -c ':q!' | tail -n +2
}
