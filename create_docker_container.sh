#!/bin/bash
    
set -ex
    
FROM="ubuntu:focal-20220404"
CONTAINER="b0x_temp"
IMAGE="b0x"
GZIP="$(which pigz)" # use pigz if available for multi-threaded gzipping
GZIP=${GZIP:-gzip}

docker container inspect ${CONTAINER} >/dev/null 2>&1 && docker rm ${CONTAINER}
docker run -v $PWD:/work -w /work --name ${CONTAINER} ${FROM} /bin/bash -c '
set -ex

export LANG=C.UTF-8
export LC_ALL=C.UTF-8
export DEBIAN_FRONTEND=noninteractive
 
   echo "# installing basic needs" \
&& apt update \
&& apt install -y --no-install-recommends \
        build-essential \
        git \
        make \
        openssh \
        python3 \
        sudo \
        vim \
&& echo "# create password-less sudo" \
&& echo "ALL ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
&& echo "# adding install scripts" \
&& mkdir -p /usr/local/bin \
&& cp -va /work/install_*.sh /usr/local/bin/ \
'

docker commit \
    -c "CMD /bin/bash" \
    -c "ENV LANG C.UTF-8" \
    -c "ENV LC_ALL C.UTF-8" \
    ${CONTAINER} ${IMAGE}
docker rm ${CONTAINER}
docker save ${IMAGE} | "${GZIP}" > "${IMAGE}.tar.gz"
