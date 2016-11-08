FROM ankurgla22/c7-systemd
MAINTAINER      Ankur Kumar <ankur.kumar@opus.co.jp>

RUN yum update -y;\
        yum groupinstall -y "Development Tools";\
        yum -y install \
            autoconf automake19 libtool gettext \
            git scons cmake flex bison \
            libcurl-devel curl \
            ncurses-devel ruby bzip2-devel expat-devel;\
        yum clean all;

RUN mkdir /etc/consul.d

RUN yum install -y which gcc
RUN useradd -ms /bin/bash kumar398
WORKDIR /home/kumar398
RUN echo '%kumar398 ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER kumar398

RUN ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"

ENV PATH /home/kumar398/.linuxbrew/bin:$PATH
RUN echo $PATH; \
 brew install consul

RUN consul agent -server -bootstrap -data-dir="/tmp/consul" -ui -config-dir=/etc/consul.d

USER root

#EXPOSE 8300 8301 8301/udp 8302 8302/udp 8400 8500 53/udp

VOLUME [ "/sys/fs/cgroup" ]

CMD ["/usr/sbin/init"]

