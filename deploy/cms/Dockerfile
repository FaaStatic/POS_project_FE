# Konteks build = dist/ yang disiapkan deploy.yml: web/ (hasil flutter build web) dan nginx.conf.
FROM nginxinc/nginx-unprivileged:1.30.6-alpine
COPY nginx.conf /etc/nginx/nginx.conf
COPY web/ /usr/share/nginx/html/
EXPOSE 8080
# Compose menjalankan container read-only (hanya /tmp yang bisa ditulis); skrip entrypoint bawaan
# mencoba mengubah /etc/nginx/conf.d, jadi nginx dijalankan langsung.
ENTRYPOINT ["nginx", "-g", "daemon off;"]
