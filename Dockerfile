FROM teddysun/v2ray:latest

# استغلال كامل قوة المعالجة والذاكرة (ضبط البيئة)
ENV GOMAXPROCS=4
ENV GOGC=100
ENV V2RAY_VMESS_AEAD_FORCED=false

# نسخ الإعدادات الخاصة بك
COPY config.json /etc/v2ray/config.json

# إنشاء سكربت التشغيل الذكي لضبط التارمينال تلقائياً
RUN echo '#!/bin/sh \n\
# 1. رفع قيود الملفات لفتح آلاف الاتصالات المتزامنة \n\
ulimit -n 1048576 \n\
# 2. تحسين استجابة الشبكة وتقليل زمن الوصول (Latency) \n\
echo 3 > /proc/sys/net/ipv4/tcp_fastopen \n\
echo 65535 > /proc/sys/net/core/somaxconn \n\
echo 1 > /proc/sys/net/ipv4/tcp_tw_reuse \n\
echo 65535 > /proc/sys/net/ipv4/tcp_max_syn_backlog \n\
echo "1024 65535" > /proc/sys/net/ipv4/ip_local_port_range \n\
# 3. تشغيل السرفر بأعلى أولوية \n\
echo "Server Optimized for 200+ Users. Starting V2Ray..." \n\
exec v2ray run -config /etc/v2ray/config.json' > /entrypoint.sh

# إعطاء صلاحيات التنفيذ للسكربت
RUN chmod +x /entrypoint.sh

EXPOSE 8080

# نقطة الانطلاق (تنفيذ الأوامر ثم تشغيل السرفر)
ENTRYPOINT ["/entrypoint.sh"]
