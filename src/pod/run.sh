#! /bin/bash

./odoo-bin \
	\
	$( [[ ${ODOO_INIT} == 'base' ]] && echo "-i base" ) \
	$( [[ -z ${ODOO_DB_FILTER} ]] || echo "--db-filter ${ODOO_DB_FILTER}" ) \
	\
	$( [[ -z ${ODOO_MEMORY_HARD} ]] || echo "--limit-memory-hard ${ODOO_MEMORY_HARD}" ) \
	$( [[ -z ${ODOO_MEMORY_SOFT} ]] || echo "--limit-memory-soft ${ODOO_MEMORY_SOFT}" ) \
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
	--db_port ${ODOO_PG_PORT:=5432} \
	--db_host ${ODOO_PG_HOST} \
	--db_user ${ODOO_PG_USER} \
	--db_password ${ODOO_PG_PWD} \
	--db_sslmode ${ODOO_PG_SSL:=verify-ca} \
	\
	--geoip-db /opt/maxmind/GeoLite2-City.mmdb
