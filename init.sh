sed -i "s/__APP_ENV__/$APP_ENV/g" /usr/local/nginx/html/static/js/app.*.js
/usr/local/nginx/sbin/nginx -g "daemon off;"
