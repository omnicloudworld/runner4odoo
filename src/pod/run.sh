#! /bin/bash


ADDONS_PATH=/opt/skyant/odoo/addons,/opt/skyant/addons/free
if [[ -v ODOO_MORE_ADDONS ]]; then
	ADDONS_PATH=${ADDONS_PATH},${ODOO_MORE_ADDONS}
fi


./odoo-bin --http-port=${ODOO_PORT:=8008} \
	\
	--addons-path=${ADDONS_PATH} \
	--data-dir=${ODOO_DIR:=/var/odoo} \
	--geoip-db=/opt/maxmind/GeoLite2-City.mmdb \
	\
	--db_sslmode=${ODOO_PG_SSL:=verify-ca} \
	$( [[ -z ${ODOO_DB_FILTER} ]] || echo "--db-filter=${ODOO_DB_FILTER}" ) \
	$( [[ -z ${ODOO_PG_PORT} ]] || echo "--db_port=${ODOO_PG_PORT}" ) \
	$( [[ -z ${ODOO_PG_HOST} ]] || echo "--db_host=${ODOO_PG_HOST}" ) \
	$( [[ -z ${ODOO_PG_USER} ]] || echo "--db_user=${ODOO_PG_USER}" ) \
	$( [[ -z ${ODOO_PG_PWD} ]] || echo "--db_password=${ODOO_PG_PWD}" ) \
	\
	$( [[ -z ${ODOO_GEVENT_PORT} ]] || echo "--gevent-port=${ODOO_GEVENT_PORT}" ) \
	$( [[ -z ${ODOO_WORKERS} ]] || echo "--workers=${ODOO_WORKERS}" ) \
	\
	$( [[ -z ${ODOO_MEMORY_HARD} ]] || echo "--limit-memory-hard=${ODOO_MEMORY_HARD}" ) \
	$( [[ -z ${ODOO_MEMORY_SOFT} ]] || echo "--limit-memory-soft=${ODOO_MEMORY_SOFT}" ) \
	\
	$( [[ -z ${ODOO_DEV} ]] || echo "--dev=${ODOO_DEV}" ) \
	$( [[ -z ${ODOO_LOG_LEVEL} ]] || echo "--log-level=${ODOO_LOG_LEVEL}" ) \
	$( [[ -z ${ODOO_LOG_HANDLER} ]] || echo "--log-handler=${ODOO_LOG_HANDLER}" ) \
	\
	$( [[ ${ODOO_LOG_WEB} = "true" ]] && echo "--log-web" ) \
	$( [[ ${ODOO_LOG_SQL} = "true" ]] && echo "--log-sql" ) \
	$( [[ ${ODOO_LOG_REQ} = "true" ]] && echo "--log-request" ) \
	$( [[ ${ODOO_LOG_RESP} = "true" ]] && echo "--log-response" ) \
	\
	$( [[ ${ODOO_PROXY:=true} = "true" ]] && echo "--proxy-mode" ) \
	\
	$( [[ ${ODOO_INIT} == 'base' ]] && echo "-i base" )
