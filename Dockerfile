# Copyright 2018-2019 Artem B. Smirnov
# Copyright 2018 Jon Azpiazu
# Copyright 2016 Bryan J. Hong
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM ubuntu:xenial

LABEL maintainer="urpylka@gmail.com"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-key adv --keyserver pool.sks-keyservers.net --recv-keys ED75B5A4483DA07C \
  && echo "deb http://repo.aptly.info/ squeeze main" >> /etc/apt/sources.list

# Update APT repository & install packages
RUN apt-get -q update \
  && apt-get -y install \
    aptly=1.3.0 \
    bzip2 \
    gnupg=1.4.20-1ubuntu3.3 \
    gpgv=1.4.20-1ubuntu3.3 \
    graphviz=2.38.0-12ubuntu2.1 \
    supervisor=3.2.0-2ubuntu0.2 \
    nginx=1.10.3-0ubuntu0.16.04.5 \
    wget \
    xz-utils=5.1.1alpha+20120614-2ubuntu2 \
    apt-utils \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install configurations
COPY assets/gpg.conf /root/.gnupg/gpg.conf
COPY assets/aptly.conf /etc/aptly.conf
COPY assets/nginx.conf /etc/nginx/conf.d/default.conf
COPY assets/supervisord.nginx.conf /etc/supervisor/conf.d/nginx.conf

# Aptly looks in /root/.gnupg for default keyrings
RUN ln -sf /opt/aptly/aptly.sec /root/.gnupg/secring.gpg && \
    ln -sf /opt/aptly/aptly.pub /root/.gnupg/pubring.gpg

# Install scripts
COPY assets/*.sh /opt/

# Install Nginx config
RUN rm /etc/nginx/sites-enabled/*

# Bind mount location
VOLUME [ "/opt/aptly" ]

# Execute startup.sh when container starts
ENTRYPOINT [ "/opt/startup.sh" ]
