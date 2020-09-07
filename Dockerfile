FROM phusion/baseimage:master-amd64
MAINTAINER nankeen <nankeen@nankeen.me>

RUN dpkg --add-architecture i386 && \
    apt-get -y update && \
    apt install -y \
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
    python3-dev \
    python3-pip \
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
    netcat\
    wget \
    radare2 \
    gdb \
    gdb-multiarch \
    netcat \
    socat \
    git \
    patchelf \
    gawk \
    file \
    zsh \
    qemu-system \
    qemu-user \
    bison --fix-missing  \
    gcc-multilib \
    binwalk \
    libseccomp-dev \
    libseccomp2 \
    seccomp 

RUN python3 -m pip install --no-cache-dir \
    ropgadget \
    pwntools \
    z3-solver \
    ropper \
    unicorn \
    keystone-engine \
    capstone \
    angr

RUN gem install one_gadget seccomp-tools && rm -rf /var/lib/gems/2.*/cache/*

# Oh-my-zsh
RUN chsh -s /bin/zsh
RUN sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

RUN git clone --depth 1 https://github.com/pwndbg/pwndbg && \
    cd pwndbg && chmod +x setup.sh && ./setup.sh && \
    echo "source $PWD/pwndbg/gdbinit.py" > ~/.gdbinit_pwndbg

RUN git clone https://github.com/hugsy/gef.git && \
    cd gef && echo source $PWD/gef.py > ~/.gdbinit_gef

RUN git clone --depth 1 https://github.com/niklasb/libc-database.git libc-database && \
    cd libc-database && ./get || echo "/libc-database/" > ~/.libcdb_path

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

COPY zshrc /root/.zshrc
COPY tmux.conf /root/.tmux.conf

CMD ["/bin/zsh"]
