#!/bin/bash

ps -ef | grep nginx_exporter | awk '{print $2}' | xargs kill -9
