FROM registry.gitlab.com/skyant/runner/cloudrun/main


ARG WORKDIR=/opt/skyodoo
ARG VERSION="15.0"

WORKDIR $WORKDIR



RUN \
    useradd -s /bin/bash -m -u 10001 skyodoo; \
    mkdir -p --mode=750 /home/skyodoo/.postgresql; chown skyodoo /home/skyodoo/.postgresql


COPY src/deb/ /tmp/deb
RUN \
    apt -y update; apt -y upgrade; \
    apt -y install postgresql-client nodejs npm \
        xz-utils python3-renderpm wget unzip \
        \
        python3-dev libxml2-dev libxslt1-dev libldap2-dev libsasl2-dev \
        libtiff5-dev libjpeg62-turbo-dev libopenjp2-7-dev zlib1g-dev libfreetype6-dev \
        liblcms2-dev libwebp-dev libharfbuzz-dev libfribidi-dev libxcb1-dev libpq-dev \
        xfonts-75dpi xfonts-100dpi xfonts-cyrillic xfonts-base; \
    dpkg -i /tmp/deb/*.deb



RUN \
    wget https://github.com/odoo/odoo/archive/refs/heads/${VERSION}.zip -P /tmp/download; \
    unzip /tmp/download/${VERSION}.zip -d /tmp/download

RUN \
    cp -r /tmp/download/odoo-${VERSION}/addons $WORKDIR/addons; \
    cp -r /tmp/download/odoo-${VERSION}/odoo $WORKDIR/odoo; \
    \
    cp /tmp/download/odoo-${VERSION}/odoo-bin $WORKDIR/odoo-bin; \
    cp /tmp/download/odoo-${VERSION}/requirements.txt $WORKDIR/requirements.txt; \
    \
    rm -r /tmp/download


COPY req.pip req.pip

RUN \
    pip3.10 install --no-cache-dir --upgrade pip; \
    pip3.10 install --no-cache-dir --upgrade -r req.pip -r requirements.txt
