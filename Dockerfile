FROM  leung0ng/nginx

#RUN rm /etc/nginx/conf.d/default.conf
##    git clone --recursive "https://github.com/0-ng/end_nginx.git" &&\
COPY ./default.conf /usr/local/nginx/conf/nginx.conf
COPY ./dist /usr/local/nginx/html
##    git clone --recursive "https://github.com/0-ng/end_vue.git" &&\

#EXPOSE 映射端口
EXPOSE 80 443

CMD ["/usr/local/nginx/sbin/nginx","-g","daemon off;"]



## Base images 基础镜像
#FROM centos:centos7 as build
##FROM hub.c.163.com/netease_comb/centos:7
#
##安装相关依赖
#RUN yum -y update && \
#    yum -y install  gcc gcc-c++ autoconf automake make && \
#    yum -y install  zlib zlib-devel openssl* pcre* wget lua-devel
#
##ADD  获取url中的文件,放在当前目录下
#ADD http://nginx.org/download/nginx-1.14.0.tar.gz /tmp/
##LuaJIT 2.1
##ADD http://luajit.org/download/LuaJIT-2.0.5.tar.gz /tmp/
#ADD https://github.com/LuaJIT/LuaJIT/archive/v2.0.5.tar.gz /tmp/
##ngx_devel_kit（NDK）模块
#ADD https://codeload.github.com/vision5/ngx_devel_kit/tar.gz/v0.3.0 /tmp/
##lua-nginx-module 模块
#ADD https://github.com/openresty/lua-nginx-module/archive/v0.10.13.tar.gz /tmp/
##nginx ngx_cache_purge模块
#ADD http://labs.frickle.com/files/ngx_cache_purge-2.3.tar.gz  /tmp/
#
#
#
##切换目录
#WORKDIR  /tmp
#
#RUN tar zxf v2.0.5.tar.gz && \
#    cd LuaJIT-2.0.5 && \
#    make PREFIX=/usr/local/luajit && \
#    make install PREFIX=/usr/local/luajit && \
#
#    cd  /tmp && \
#    tar -xzvf v0.3.0 && \
#    cp -r ngx_devel_kit-0.3.0/ /usr/local/src/ && \
#
#    tar -xzvf v0.10.13.tar.gz && \
#    cp -r lua-nginx-module-0.10.13/ /usr/local/src/ && \
#
#    tar -xzvf ngx_cache_purge-2.3.tar.gz && \
#    cp -r ngx_cache_purge-2.3/ /usr/local/src/ && \
#
#    export LUAJIT_LIB=/usr/local/lib && \
#    export LUAJIT_INC=/usr/local/include/luajit-2.0 && \
#
#    mkdir -p {/usr/local/nginx/logs,/var/lock} && \
#    useradd -M -s /sbin/nologin nginx && \
#    tar -zxvf nginx-1.14.0.tar.gz && \
#    mkdir -p /usr/local/nginx
#RUN cd /tmp/nginx-1.14.0 && \
#
#    ./configure --prefix=/usr/local/nginx --user=nginx --group=nginx \
#    --error-log-path=/usr/local/nginx/logs/error.log \
#    --http-log-path=/usr/local/nginx/logs/access.log \
#    --pid-path=/usr/local/nginx/logs/nginx.pid \
#    --lock-path=/var/lock/nginx.lock \
#    --with-ld-opt="-Wl,-rpath,/usr/local/luajit/lib" \
#    --with-http_stub_status_module \
#    --with-http_ssl_module \
#    --with-http_sub_module \
#    --add-module=/usr/local/src/lua-nginx-module-0.10.13 \
#    --add-module=/usr/local/src/ngx_devel_kit-0.3.0 \
#    --add-module=/usr/local/src/ngx_cache_purge-2.3 \
#    && make && make install && \
#
#    /usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf && \
#    ln -s /usr/local/nginx/sbin/* /usr/local/sbin/
#
##参数说明
##--prefix 用于指定nginx编译后的安装目录
##--add-module 为添加的第三方模块，此次添加了fdfs的nginx模块
##--with..._module 表示启用的nginx模块，如此处启用了http_ssl_module模块
#
##EXPOSE 映射端口
##EXPOSE 80 443
#
##CMD 运行以下命令
##CMD ["nginx"]
##CMD ["/usr/local/nginx/sbin/nginx","-g","daemon off;"]