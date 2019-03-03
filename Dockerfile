FROM centos:7.6.1810
MAINTAINER jellywen <1307553378@qq.com>

ENV PYTHON_VERSION 2.7.13
ADD Python-$PYTHON_VERSION.tgz /home/extension/

ADD requirements.txt /

RUN set -x && \
    yum install -y gcc \
    gcc-c++ \
    autoconf \
    automake \
    libtool \
    make \
    cmake && \

    yum install -y tar \
    git bzip2-devel ncurses-devel sqlite-devel readline-devel tk-devel openssl-devel zlib-devel && \

#for python
    cd /home/extension/Python-$PYTHON_VERSION && \
    ./configure --prefix=/usr/local && \
    make -j8 && make install && \
    /usr/local/bin/python2.7 -m ensurepip && \
    pip install -r $dir/requirements.txt && \

# Install Other
    yum install -y vim \
    cronie \
    crontabs && \
    sed -i '/session    required   pam_loginuid.so/c\#session    required   pam_loginuid.so' /etc/pam.d/crond && \

#Add user
    mkdir -p /data/{www,phpext} && \
    useradd -r -s /sbin/nologin -d /data/www -m -k no www && \

#Install supervisor
    easy_install supervisor && \
    mkdir -p /var/{log/supervisor,run/{sshd,supervisord}} && \
    touch /tmp/supervisor.sock && \
    chmod 777 /tmp/supervisor.sock && \

#Clean OS
    yum remove -y gcc \
    gcc-c++ \
    autoconf \
    automake \
    libtool \
    make \
    cmake && \
    yum clean all && \
    rm -rf /tmp/* /var/cache/{yum,ldconfig} /etc/my.cnf{,.d} && \
    mkdir -p --mode=0755 /var/cache/{yum,ldconfig} && \
    find /var/log -type f -delete && \
    rm -rf /home/extension && \

#Change Mod from webdir
    chown -R www:www /data/www && \
    mkdir -p /data/logs && \
    chown -R www:www /data/logs && \
    mkdir -p /home/www/.ssh && \
    chmod 700 /home/www/.ssh && \
    chown -R www:www /home/www && \

    #启用www用户
    usermod -s /bin/bash www && \
    #修改www的主目录
    usermod -d /home/www www && \

    #修复中文乱码(直接登录)
    echo "export LC_ALL=zh_CN.utf8" >> /root/.bash_profile && \

    #修复中文乱码
    localedef -c -f UTF-8 -i zh_CN zh_CN.utf8 && \
    export LC_ALL=zh_CN.utf8 && \

    #校准时间
    \cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \

    #防止提示
    rm -rf /etc/ssh/ssh_host_rsa_key && \
    rm -rf /etc/ssh/ssh_host_ecdsa_key && \
    rm -rf /etc/ssh/ssh_host_ed25519_key && \
    ssh-keygen -q -t rsa -b 2048 -f /etc/ssh/ssh_host_rsa_key -N '' && \
    ssh-keygen -q -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N '' && \
    ssh-keygen -t dsa -f /etc/ssh/ssh_host_ed25519_key -N '' && \
    /usr/sbin/sshd && \
    echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config

#防止宽度高度不足
ENV LC_ALL zh_CN.utf8
ENV COLUMNS 204
ENV LINES 50

#Add supervisord conf
ADD supervisord.conf /etc/
ADD supervisor.d/ /etc/supervisor.d/

#Update nginx config
ADD extfile/logrotate.d/ /etc/logrotate.d/


#Start
ADD start.sh /

#Set port
EXPOSE 80 443

#Start it
ENTRYPOINT ["/start.sh"]

WORKDIR /data/www

#Start web server
#CMD ["/bin/bash", "/start.sh"]

