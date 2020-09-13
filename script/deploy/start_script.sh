#!/bin/bash


PACKAGE_NAME=nginx-collector-plugin
PACKAGE_PATH=$(dirname $(dirname "$(cd `dirname $0`; pwd)"))
LOG_DIRECTORY=$PACKAGE_PATH/log
LOG_FILE=$LOG_DIRECTORY/$PACKAGE_NAME.log


if ! type getopt >/dev/null 2>&1 ; then
  message="command \"getopt\" is not found"
  echo "[ERROR] Message: $message" >& 2
  echo "$(date "+%Y-%m-%d %H:%M:%S") [ERROR] Message: $message" > $LOG_FILE
  exit 1
fi

getopt_cmd=`getopt -o h -a -l help:,nginx-host:,nginx-status-port:,nginx-status-uri:,exporter-host:,exporter-port:,exporter-uri: -n "start_script.sh" -- "$@"`
if [ $? -ne 0 ] ; then
    exit 1
fi
eval set -- "$getopt_cmd"


nginx_host="127.0.0.1"
nginx_status_port=8080
nginx_status_uri="/stub_status"
exporter_host="127.0.0.1"
exporter_port=9113
exporter_uri="/metrics"

print_help() {
    echo "Usage:"
    echo "    start_script.sh [options]"
    echo "    start_script.sh --nginx-host 127.0.0.1 --nginx-status-port 8080 --nginx-status-uri /stub_status [options]"
    echo ""
    echo "Options:"
    echo "  -h, --help                 show help"
    echo "      --nginx-host           the address of Nginx (\"127.0.0.1\" by default)"
    echo "      --nginx-status-port    the port of Nginx HTTP stub status service (8080 by default)"
    echo "      --nginx-status-uri     the location to fetch Nginx basic status data"
    echo "      --exporter-host        the listen address of exporter (\"127.0.0.1\" by default)"
    echo "      --exporter-port        the listen port of exporter (9113 by default)"
    echo "      --exporter-uri         the uri to expose metrics (\"/metrics\" by defualt)"
}

while true
do
    case "$1" in
        -h | --help)
            print_help
            shift 1
            exit 0
            ;;
        --nginx-host)
            case "$2" in
                "")
                    shift 2  
                    ;;
                *)
                    nginx_host="$2"
                    shift 2;
                    ;;
            esac
            ;;
        --nginx-status-port)
            case "$2" in
                "")
                    shift 2  
                    ;;
                *)
                    nginx_status_port="$2"
                    shift 2;
                    ;;
            esac
            ;;
        --nginx-status-uri)
            case "$2" in
                "")
                    shift 2  
                    ;;
                *)
                    nginx_status_uri="$2"
                    shift 2;
                    ;;
            esac
            ;;
        --exporter-host)
            case "$2" in
                "")
                    shift 2  
                    ;;
                *)
                    exporter_host="$2"
                    shift 2;
                    ;;
            esac
            ;;
        --exporter-port)
            case "$2" in
                "")
                    shift 2  
                    ;;
                *)
                    exporter_port="$2"
                    shift 2;
                    ;;
            esac
            ;;
        --exporter-uri)
            case "$2" in
                "")
                    shift 2  
                    ;;
                *)
                    exporter_uri="$2"
                    shift 2;
                    ;;
            esac
            ;;
        --)
            shift
            break
            ;;
        *)
            message="argument \"$1\" is invalid"
            echo "[ERROR] Message: $message" >& 2
            echo "$(date "+%Y-%m-%d %H:%M:%S") [ERROR] Message: $message" > $LOG_FILE
            print_help
            exit 1
            ;;
    esac
done

mkdir -p $LOG_DIRECTORY

message="start exporter"
echo "[INFO] Message: $message"
echo "$(date "+%Y-%m-%d %H:%M:%S") [INFO] Message: $message" >> $LOG_FILE

cd $PACKAGE_PATH/script
chmod +x src/nginx_exporter
./src/nginx_exporter --nginx.scrape-uri http://$nginx_host:$nginx_status_port$nginx_status_uri --web.listen-address=$exporter_host:$exporter_port --web.telemetry-path=$exporter_uri 2>&1 | tee -a $LOG_FILE
