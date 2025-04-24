FROM ubuntu:14.04

ENV DEBIAN_FRONTEND=noninteractive

# Install basic dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    libssl-dev \
    libreadline-dev \
    zlib1g-dev \
    libpq-dev \
    libyaml-dev \
    libgdbm-dev \
    libncurses5-dev \
    libffi-dev \
    ca-certificates \
    nodejs \
    wget \
    postgresql \
    postgresql-contrib

# Install OpenSSL 1.0.2u (required for Ruby 2.1 compatibility)
RUN mkdir -p /opt/openssl && \
  cd /opt && \
  curl -L -A "Mozilla/5.0" -O https://www.openssl.org/source/old/1.0.2/openssl-1.0.2u.tar.gz && \
  tar -xzf openssl-1.0.2u.tar.gz && \
  cd openssl-1.0.2u && \
  CFLAGS="-fPIC" ./config --prefix=/opt/openssl shared zlib && \
  make -j$(nproc) && make install

# Install Ruby 2.1.2 from source
RUN curl -O https://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.2.tar.gz && \
    tar -xzf ruby-2.1.2.tar.gz && \
    cd ruby-2.1.2 && \
    CFLAGS="-fPIC -O2 -Wno-error=implicit-function-declaration" ./configure --prefix=/usr/local --with-openssl-dir=/opt/openssl && \
    make -j$(nproc) && make install && \
    cd .. && rm -rf ruby-2.1.2*

ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
ENV RAILS_RELATIVE_URL_ROOT=/plantfadb

RUN gem install bundler -v 1.17.3

WORKDIR /app
COPY . /app

RUN bundle install
RUN rake assets:precompile

# Expose port 3000 for Rails
EXPOSE 3000

RUN chmod +x /app/setup_postgresql.sh

CMD service postgresql start && \
    /app/setup_postgresql.sh && \
    rails s -b '0.0.0.0' -e production
