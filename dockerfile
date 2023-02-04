FROM registry.gitlab.com/skyant/runner/cloudrun/main:latest

ARG VERSION
ARG MAXMIND_KEY


COPY src/deb/ /tmp/deb
COPY src/pod $PWD
COPY odoo.req /var/pip/odoorunner.req


RUN \
    apt -y update; apt -y upgrade &&\
    apt -y install postgresql-client nodejs npm python3-phonenumbers \
        xz-utils python3-renderpm wget unzip ffmpeg \
        \
        python3-dev libxml2-dev libxslt1-dev libldap2-dev libsasl2-dev \
        libtiff5-dev libjpeg62-turbo-dev libopenjp2-7-dev zlib1g-dev libfreetype6-dev \
        liblcms2-dev libwebp-dev libharfbuzz-dev libfribidi-dev libxcb1-dev libpq-dev \
        xfonts-75dpi xfonts-100dpi xfonts-cyrillic xfonts-base fonts-inconsolata \
        fonts-font-awesome fonts-roboto-unhinted gsfonts &&\
    npm install -g rtlcss &&\
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
    cp /tmp/download/odoo-${VERSION}/requirements.txt /var/pip/odoosrc.req; \
    \
    rm -r /tmp/download ;\
    apt autoremove -y; apt clean --dry-run ;\
	chmod +x $PWD/run.sh; \
    ln -s /etc/odoo/odoo.conf /etc/odoo.conf

RUN \
    pip3.10 install --no-cache-dir --upgrade pip ;\
    pip3.10 install --no-cache-dir --upgrade \
        -r /var/pip/odoorunner.req -r /var/pip/odoosrc.req
