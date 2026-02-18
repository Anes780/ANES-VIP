FROM teddysun/v2ray:latest

# ضبط البيئة لمعالجة التشفير بسرعة فائقة
ENV GOMAXPROCS=4
ENV GOGC=100
ENV V2RAY_VMESS_AEAD_FORCED=false

COPY config.json /etc/v2ray/config.json

# سكربت الإقلاع لكسر قيود النظام (Kernel Tuning)
RUN echo '#!/bin/sh \n\
# رفع حدود الملفات المفتوحة لـ 200+ مستخدم \n\
ulimit -n 1048576 \n\
# أوامر التارمينال الشاملة لتحسين سرعة الاستجابة \n\
echo 3 > /proc/sys/net/ipv4/tcp_fastopen \n\
echo 65535 > /proc/sys/net/core/somaxconn \n\
echo 1 > /proc/sys/net/ipv4/tcp_tw_reuse \n\
echo 65535 > /proc/sys/net/ipv4/tcp_max_syn_backlog \n\
echo "1024 65535" > /proc/sys/net/ipv4/ip_local_port_range \n\
echo 1 > /proc/sys/net/ipv4/tcp_low_latency \n\
# تشغيل V2Ray مباشرة \n\
echo "ANES-VIP Server is Ready!" \n\
exec v2ray run -config /etc/v2ray/config.json' > /start.sh

RUN chmod +x /start.sh

EXPOSE 8080
ENTRYPOINT ["/start.sh"]
