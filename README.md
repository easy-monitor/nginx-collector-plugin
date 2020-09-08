## 工作原理

1. nginx-collector-plugin 监控插件包使用了第三方的 Nginx Exporter 进行指标采集，GitHub 链接为 https://github.com/nginxinc/nginx-prometheus-exporter 。

## 准备工作

1. 确认要采集的 Nginx 开启了 “HTTP Stub Status” 模块，具体配置方法参考 http://nginx.org/en/docs/http/ngx_http_stub_status_module.html 。

## 使用方法

### 导入监控插件包

1. 下载该项目的压缩包（https://github.com/easy-monitor/nginx-collector-plugin/archive/master.zip ）。

2. 建议解压到 EasyOps 平台服务器上的 `/usr/local/easyops/monitor_plugin_packages` 该目录下。

3. 使用 EasyOps 平台内置的监控插件包导入工具进行导入，具体命令如下，请替换其中的 `8888` 为当前 EasyOps 平台具体的 `org`。

```sh
$ cd /usr/local/easyops/collector_plugin_service/tools
$ sh plugin_op.sh install 8888 /usr/local/easyops/monitor_plugin_packages/nginx-collector-plugin
```

4. 导入成功后访问 EasyOps 平台的「采集插件」小产品页面 (http://your-easyops-server/next/collector-plugin )，就能看到导入的 "nginx-collector-plugin" 采集插件。

### 启动 Nginx Exporter

1. 启动 Nginx Exporter，具体命令如下，请替换其中的 `--nginx-host`、`--nginx-status-port`、`--nginx-status-uri` 参数为采集的 Nginx 具体的 “HTTP Stub Status” 模块监听地址、端口和访问 URI。

```sh
$ cd /usr/local/easyops/monitor_plugin_packages/nginx-collector-plugin/script
$ sh deploy/start_script.sh --nginx-host 127.0.0.1 --nginx-port 8080 --nginx-status-uri /stub_status
```

2. 通过访问 http://127.0.0.1:9113/metrics 来获取指标数据，请替换其中的 `127.0.0.1:9113` 为 Exporter 具体的监听地址和端口。

```sh
$ curl http://127.0.0.1:9113/metrics 
```

3. 接下来可使用导入的采集插件为具体的资源实例创建采集任务。

## 启动参数

| 名称 | 类型 | 必填 | 默认值 | 说明 |
| --- | --- | --- | --- | --- |
| nginx-host | string | false | 127.0.0.1 | Nginx 监听地址 |
| nginx-status-port | int | false | 8080 | Nginx “HTTP Stub Status” 模块的监听端口 |
| nginx-status-uri | string | false | /stub_status | Nginx “HTTP Stub Status” 模块的访问 URI |
| exporter-host | string | false | 127.0.0.1 | Exporter 监听地址 |
| exporter-port | int | false | 9113 | Exporter 监听端口 |
| exporter-uri | string | false | /metrics | Exporter 获取指标数据的 URI |
