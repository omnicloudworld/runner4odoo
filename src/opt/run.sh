#! /bin/bash

./odoo-bin \
	\
	$( [[ ${INIT} == 'base' ]] && echo "-i base" ) \
	$( [[ -z ${ODOO_DB_FILTER} ]] || echo "--db-filter ${ODOO_DB_FILTER}" ) \
	\
	$( [[ -z ${MEMORY_HARD} ]] || echo "--limit-memory-hard ${MEMORY_HARD}" ) \
	$( [[ -z ${MEMORY_SOFT} ]] || echo "--limit-memory-soft ${MEMORY_SOFT}" ) \
	\
	$( [[ -z ${ODOO_DEV} ]] || echo "--dev ${ODOO_DEV}" ) \
	$( [[ -z ${ODOO_LOG_LEVEL} ]] || echo "--log-level ${ODOO_LOG_LEVEL}" ) \
	$( [[ -z ${ODOO_LOG_HANDLER} ]] || echo "--log-handler ${ODOO_LOG_HANDLER}" ) \
	\
	$( [[ ${ODOO_LOG_WEB} = "true" ]] && echo "--log-web" ) \
	$( [[ ${ODOO_LOG_SQL} = "true" ]] && echo "--log-sql" ) \
	$( [[ ${ODOO_LOG_REQ} = "true" ]] && echo "--log-request" ) \
	$( [[ ${ODOO_LOG_RESP} = "true" ]] && echo "--log-response" ) \
	\
	$( [[ ${ODOO_PROXY:=true} = "true" ]] && echo "--proxy-mode" ) \
	\
	--data-dir ${ODOO_DIR:=/var/odoo} \
	--http-port ${ODOO_PORT:=8008} \
	\
	--db_port ${ODOOPG_PORT:=5432} \
	--db_host ${ODOOPG_HOST} \
	--db_user ${ODOOPG_USER} \
	--db_password ${ODOOPG_PWD} \
	--db_sslmode ${DB_SSL:=verify-ca} \
	\
	--geoip-db /opt/maxmind/GeoLite2-City.mmdb
