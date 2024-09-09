FROM ubuntu:24.04
MAINTAINER nankeen <nankeen@nankeen.me>

RUN dpkg --add-architecture i386 && \
    apt-get -y update && \
    apt-get install -y \
    libc6:i386 \
    libc6-dbg:i386 \
    build-essential \
    libc6-dbg \
    lib32stdc++6 \
    g++-multilib \
    cmake \
    gcc \
    ipython3 \
    vim \
    net-tools \
    iputils-ping \
    curl \
    libffi-dev \
    libssl-dev \
    python3-capstone \
    python3-dev \
    python3-pip \
    python3-unicorn \
    python3-z3 \
    build-essential \
    ruby \
    ruby-dev \
    tmux \
    glibc-source \
    cmake \
    strace \
    ltrace \
    nasm \
    socat\
    wget \
    radare2 \
    gdb \
    gdb-multiarch \
    netcat-openbsd \
    socat \
    git \
    patchelf \
    gawk \
    file \
    qemu-system \
    qemu-user \
    bison --fix-missing  \
    gcc-multilib \
    binwalk \
    libseccomp-dev \
    libseccomp2 \
    seccomp \
    musl-tools \
    stow \
    pipx && \
    rm -rf /var/lib/apt/lists/*

RUN pipx ensurepath

RUN pipx install \
    ropgadget \
    pwntools \
    ropper

RUN gem install one_gadget seccomp-tools && rm -rf /var/lib/gems/2.*/cache/*

RUN git clone --depth 1 https://github.com/pwndbg/pwndbg && \
    cd pwndbg && chmod +x setup.sh && ./setup.sh && \
    echo "source $PWD/pwndbg/gdbinit.py" > ~/.gdbinit_pwndbg

RUN git clone https://github.com/hugsy/gef.git && \
    cd gef && echo source $PWD/gef.py > ~/.gdbinit_gef

RUN git clone --depth 1 https://github.com/niklasb/libc-database.git libc-database && \
    cd libc-database && ./get || echo "/libc-database/" > ~/.libcdb_path

RUN python3 -m venv /ctf/.venv --system-site-packages && \
    . /ctf/.venv/bin/activate && \
    pip3 install --no-cache-dir \
    pwntools angr

WORKDIR /ctf/work/

#Disable these until I have my own glibc builder
COPY --from=skysider/glibc_builder64:2.19 /glibc/2.19/64 /glibc/2.19/64
COPY --from=skysider/glibc_builder32:2.19 /glibc/2.19/32 /glibc/2.19/32

COPY --from=skysider/glibc_builder64:2.23 /glibc/2.23/64 /glibc/2.23/64
COPY --from=skysider/glibc_builder32:2.23 /glibc/2.23/32 /glibc/2.23/32

COPY --from=skysider/glibc_builder64:2.24 /glibc/2.24/64 /glibc/2.24/64
COPY --from=skysider/glibc_builder32:2.24 /glibc/2.24/32 /glibc/2.24/32

COPY --from=skysider/glibc_builder64:2.27 /glibc/2.27/64 /glibc/2.27/64
COPY --from=skysider/glibc_builder32:2.27 /glibc/2.27/32 /glibc/2.27/32

COPY --from=skysider/glibc_builder64:2.28 /glibc/2.28/64 /glibc/2.28/64
COPY --from=skysider/glibc_builder32:2.28 /glibc/2.28/32 /glibc/2.28/32

COPY --from=skysider/glibc_builder64:2.29 /glibc/2.29/64 /glibc/2.29/64
COPY --from=skysider/glibc_builder32:2.29 /glibc/2.29/32 /glibc/2.29/32

COPY --from=skysider/glibc_builder64:2.30 /glibc/2.30/64 /glibc/2.30/64
COPY --from=skysider/glibc_builder32:2.30 /glibc/2.30/32 /glibc/2.30/32

COPY --from=skysider/glibc_builder64:2.31 /glibc/2.31/64 /glibc/2.31/64
COPY --from=skysider/glibc_builder32:2.31 /glibc/2.31/32 /glibc/2.31/32

COPY --from=skysider/glibc_builder64:2.33 /glibc/2.33/64 /glibc/2.33/64
COPY --from=skysider/glibc_builder32:2.33 /glibc/2.33/32 /glibc/2.33/32

COPY --from=skysider/glibc_builder64:2.34 /glibc/2.34/64 /glibc/2.34/64
COPY --from=skysider/glibc_builder32:2.34 /glibc/2.34/32 /glibc/2.34/32

COPY --from=skysider/glibc_builder64:2.35 /glibc/2.35/64 /glibc/2.35/64
COPY --from=skysider/glibc_builder32:2.35 /glibc/2.35/32 /glibc/2.35/32

COPY --from=skysider/glibc_builder64:2.36 /glibc/2.36/64 /glibc/2.36/64
COPY --from=skysider/glibc_builder32:2.36 /glibc/2.36/32 /glibc/2.36/32

RUN git clone --depth 1 https://github.com/nankeen/rcfiles.git /root/.rcfiles && \
    cd /root/.rcfiles && rm /root/.bashrc && stow --target /root home && \
    mkdir -p /root/.config && stow --target /root/.config xdg_config_home

CMD ["/bin/bash"]
