#!/usr/bin/python
"""
zabbix-wecom-bot.py

功能: 接收 Zabbix 告警参数（机器人ID、主题、正文），
     格式化为 Markdown 内容，发送到企业微信机器人。

用法:
    python zabbix-wecom-bot.py <bot_id> <subject> <message>

参数说明:
    bot_id  - 企业微信机器人的 webhook key
    subject - 告警标题
    message - 告警正文内容（支持 Markdown）

示例:
    python zabbix-wecom-bot.py abc123 "[Zabbix告警]" "服务宕机，请检查"
"""


import sys
import json
import requests


bot_id  = sys.argv[1]
subject = sys.argv[2]
message = sys.argv[3]

QYWX_BOT_WEBHOOK = "https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=" + bot_id

zabbix_alert_message = {}
zabbix_alert_message["msgtype"] = "markdown"
zabbix_alert_message["markdown"] = {}
zabbix_alert_message["markdown"]["content"] = subject + "\n" + message

headers = {}
headers["Content-Type"] = "application/json"

r = requests.post(QYWX_BOT_WEBHOOK, data=json.dumps(zabbix_alert_message), headers=headers)

# Debug:
# print(r.status_code)
# print(r.text)