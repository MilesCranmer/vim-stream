#!/bin/bash
vims() {
    vim - -nes -u NONE "$(for arg in "$@"; do echo -n -c $arg ; done)" -c ':%p' -c ':q!' | tail -n +2
}
