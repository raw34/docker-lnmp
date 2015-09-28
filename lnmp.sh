# build ubuntu
docker build -t raw34/ubuntu ./ubuntu

# build mysql
docker build -t raw34/mysql ./mysql

# build redis
docker build -t raw34/redis ./redis

# build nginx
docker build -t raw34/nginx ./nginx

# build php
docker build -t raw34/php ./php

# run volume-wwwlogs
docker run -idt -P --name wwwlogs -v /src/wwwlogs:/opt/wwwlogs raw34/ubuntu /bin/bash
# docker run -idt -P --name wwwlogs -v /Users/randy/wwwlogs:/opt/wwwlogs raw34/ubuntu /bin/bash

# run volume-wwwdata
docker run -idt -P --name wwwdata -v /src/wwwdata:/opt/wwwdata raw34/ubuntu /bin/bash
# docker run -idt -P --name wwwdata -v /Users/randy/wwwdata:/opt/wwwdata raw34/ubuntu /bin/bash

# run volume-wwwroot
docker run -idt -P --name wwwroot -v /src/wwwroot:/opt/wwwroot raw34/ubuntu /bin/bash
# docker run -idt -P --name wwwroot -v /Users/randy/wwwroot:/opt/wwwroot raw34/ubuntu /bin/bash

#run mysql
docker run -idt --volumes-from wwwlogs --volumes-from wwwdata --volumes-from wwwroot --name mysql_1 raw34/mysql

#run redis
docker run -idt --volumes-from wwwlogs --volumes-from wwwdata --volumes-from wwwroot --name redis_1 raw34/redis

#run nginx
docker run -idt --volumes-from wwwlogs --volumes-from wwwdata --volumes-from wwwroot -p 80:80 -p 443:443 --name nginx_1 raw34/nginx

#run php
docker run -idt --volumes-from wwwlogs --volumes-from wwwdata --volumes-from wwwroot --name php_1 raw34/php
