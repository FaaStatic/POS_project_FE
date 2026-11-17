# Dibangun dari root repo setelah `flutter build web` (lihat .dockerignore):
#   docker build -f deploy/cms/Dockerfile .
FROM nginxinc/nginx-unprivileged:1.30.6-alpine
COPY deploy/cms/nginx.conf /etc/nginx/conf.d/default.conf
COPY apps/cms/build/web /usr/share/nginx/html
