FROM fedora:39

RUN dnf install -y libpq libpq-devel openssl-devel gcc-gnat gprbuild wget unzip git

RUN wget https://github.com/alire-project/alire/releases/download/v1.2.2/alr-1.2.2-bin-x86_64-linux.zip -O /tmp/alr.zip

RUN unzip /tmp/alr.zip -d /tmp

RUN mv /tmp/bin/alr /usr/local/bin

WORKDIR /rinha

EXPOSE 9999
