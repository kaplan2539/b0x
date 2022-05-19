#!/bin/bash

IMAGE="b0x"

set -ex


docker run --rm -it \
    -v $HOME:$HOME \
    -v $PWD:/work -w /work \
    -e _UID=$(id -u) -e _USER=$(id -un) -e _GID=$(id -g) -e _GROUP=$(id -gn) \
    ${IMAGE} /bin/bash -c '
    export PS1="\360\237\220\263 $PS1 "
    groupadd -g $_GID $_GROUP > /dev/null;
    adduser --no-create-home --gid $_GID --uid $_UID --gecos "" --disabled-password $_USER > /dev/null;
    su --shell /bin/bash $_USER
'
