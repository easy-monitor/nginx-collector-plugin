# nginx-collector-plugin

## 使用方法

1. 确保监控的 Nginx 开启了 "HTTP Stub Status" 模块，具体配置方法参考 http://nginx.org/en/docs/http/ngx_http_stub_status_module.html 。
2. 下载该项目的压缩包。
3. 解压到 EasyOps 平台服务器上的任意目录，例如 "/tmp/nginx-collector-plugin"。
4. 使用 EasyOps 平台内置的插件包导入工具导入该压缩包，具体命令如下（请替换其中的`8888`为当前 EasyOps 平台具体的`org`）。

```sh
$ cd /usr/local/easyops/collector_plugin_service/tools
$ sh plugin_op.sh install 8888 /tmp/nginx-collector-plugin
```

5. 导入成功后访问 EasyOps 平台的「采集插件」小产品页面 (http://your-easyops-server/next/collector-plugin)，就能看到导入的 "nginx-collector-plugin" 采集插件。
6. 启动该插件包的 Exporter，具体命令如下（请替换其中的参数为步骤1中 Nginx 的 "HTTP Stub Status" 的具体配置）

```sh
$ cd /tmp/nginx-collector-plugin/script
$ sh start_script.sh --nginx-host 127.0.0.1 --nginx-port 8080 --nginx-status-uri /stub_status
```

7. 接下来可使用该采集插件为具体的主机实例创建采集任务。
