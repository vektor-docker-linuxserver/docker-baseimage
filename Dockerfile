FROM vektory79/i386-baseimage:0.9.19

MAINTAINER Vektory79 <vektory79@gmail.com>

ENV DEBIAN_FRONTEND="noninteractive" HOME="/root" TERM="xterm" LANG="ru_RU.UTF-8" LANGUAGE="ru" LC_ALL="ru_RU.UTF-8"

# Set the locale
RUN locale-gen ru_RU.UTF-8

COPY sources.list /etc/apt/sources.list
COPY my_init/*.sh /etc/my_init.d/
RUN useradd -u 911 -U -d /config -s /bin/false abc && \
      usermod -G users abc && \
      mkdir -p /app/aptselect /config /defaults && \
      LATEST_TAG=$(curl -sX GET "https://api.github.com/repos/jblakeman/apt-select/releases/latest" | awk '/tag_name/{print $4;exit}' FS='[""]') && \
      curl -L https://github.com/jblakeman/apt-select/archive/${LATEST_TAG}.tar.gz | tar xvz -C /app/aptselect --strip-components=1 && \
      apt-get update && \
      apt-get install -y python3-bs4 && \
      apt-get upgrade -y -o Dpkg::Options::="--force-confold" && \
      chmod +x /etc/my_init.d/*.sh && \
      apt-get clean && \
      rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
CMD ["/sbin/my_init"]
