FROM deepnote/python:3.9

# The following snippet is licensed under MIT license
# SEE: https://github.com/jackfirth/racket-docker

RUN apt-get update && \
    apt-get install -y libzmq5

RUN pip install notebook

ENV RACKET_VERSION=8.6
ENV RACKET_INSTALLER_URL=http://mirror.racket-lang.org/installers/$RACKET_VERSION/racket-$RACKET_VERSION-x86_64-linux-natipkg.sh

RUN wget --output-document=racket-install.sh -q ${RACKET_INSTALLER_URL} && \
    echo "yes\n1\n" | sh racket-install.sh --create-dir --unix-style --dest /usr/ && \
    rm racket-install.sh

ENV SSL_CERT_FILE="/etc/ssl/certs/ca-certificates.crt"
ENV SSL_CERT_DIR="/etc/ssl/certs"

RUN raco setup
RUN raco pkg config --set catalogs \
    "https://download.racket-lang.org/releases/${RACKET_VERSION}/catalog/" \
    "https://pkg-build.racket-lang.org/server/built/catalog/" \
    "https://pkgs.racket-lang.org" \
    "https://planet-compats.racket-lang.org"

RUN raco pkg install --auto iracket
RUN raco iracket install

ENV DEFAULT_KERNEL_NAME "racket"
