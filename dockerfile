FROM registry.gitlab.com/skyant/runner/cloudrun/main

ARG VERSION
ARG MAXMIND_KEY


COPY src/deb/ /tmp/deb
COPY src/opt $PWD
COPY req.pip req.pip


RUN \
    apt -y update; apt -y upgrade &&\
    apt -y install postgresql-client nodejs npm \
        xz-utils python3-renderpm wget unzip \
        \
        python3-dev libxml2-dev libxslt1-dev libldap2-dev libsasl2-dev \
        libtiff5-dev libjpeg62-turbo-dev libopenjp2-7-dev zlib1g-dev libfreetype6-dev \
        liblcms2-dev libwebp-dev libharfbuzz-dev libfribidi-dev libxcb1-dev libpq-dev \
        xfonts-75dpi xfonts-100dpi xfonts-cyrillic xfonts-base &&\
    dpkg -i /tmp/deb/*.deb

RUN \
    wget https://github.com/odoo/odoo/archive/refs/heads/${VERSION}.zip -P /tmp/download &&\
    unzip /tmp/download/${VERSION}.zip -d /tmp/download

RUN \
    curl "https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-City&license_key=$MAXMIND_KEY&suffix=tar.gz" \
        -o /tmp/download/GeoLite2-City.tar.gz &&\
    tar -xzvf /tmp/download/GeoLite2-City.tar.gz --directory /tmp/download &&\
    mkdir -p /opt/maxmind &&\
    mv /tmp/download/GeoLite2-City_*/GeoLite2-City.mmdb /opt/maxmind/GeoLite2-City.mmdb

RUN \
    cp -r /tmp/download/odoo-${VERSION}/addons $PWD/addons; \
    cp -r /tmp/download/odoo-${VERSION}/odoo $PWD/odoo; \
    \
    cp /tmp/download/odoo-${VERSION}/odoo-bin $PWD/odoo-bin; \
    cp /tmp/download/odoo-${VERSION}/requirements.txt $PWD/requirements.txt; \
    \
    rm -r /tmp/download ;\
    apt autoremove -y; apt clean --dry-run ;\
	chmod +x $PWD/run.sh

RUN \
    pip3.10 install --no-cache-dir --upgrade pip ;\
    pip3.10 install --no-cache-dir --upgrade -r req.pip -r requirements.txt
