## 使用文档

# 背景
centos7上跑python2.7应用,默认带的Python pip不能用

# 编译
docker build -t centos76-python27:1.0.0 .

# 推到dockerhub
- docker login
- docker tag [ImageId] jellywen/centos76-python27:[镜像版本号]
- docker push jellywen/centos76-python27:[镜像版本号]

# build机器上使用
- docker run -itd -p 88:80 --name centos centos76-python27:1.0.0 bash

# 非build机器上使用
- docker run -itd -p 88:80 --name centos centos76-python27:1.0.0 bash

# 本地访问
- http://localhost:88
- http://localhost:88/index.php
- http://localhost:88/index.html

