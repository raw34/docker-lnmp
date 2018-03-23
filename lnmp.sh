# build jessie
docker build -t raw34/jessie ./jessie

# build ubuntu
docker build -t raw34/ubuntu ./ubuntu

# build mysql
docker build -t raw34/mysql ./mysql

# build redis
docker build -t raw34/redis ./redis

# build mongodb
docker build -t raw34/mongodb ./mongodb

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
docker run -idt --volumes-from wwwlogs --volumes-from wwwdata --volumes-from wwwroot -p 3306:3306 --name mysql raw34/mysql

#run redis
docker run -idt --volumes-from wwwlogs --volumes-from wwwdata --volumes-from wwwroot -p 6379:6379 --name redis raw34/redis

#run php
docker run -idt --volumes-from wwwlogs --volumes-from wwwdata --volumes-from wwwroot -p 9000:9000 --name php raw34/php

#run nginx
mkdir -p /src/wwwetc/nginx/sites-available
# mkdir -p /Users/randy/wwwetc/nginx/sites-available
cp ./nginx/default /src/wwwetc/nginx/sites-available
# cp ./nginx/default /Users/randy/wwwetc/nginx/sites-available
docker run -idt --volumes-from wwwlogs --volumes-from wwwdata --volumes-from wwwroot -v /src/wwwetc/nginx/sites-available:/etc/nginx/sites-available -p 80:80 -p 443:443 --link php:php --name lnmp raw34/nginx
# docker run -idt --volumes-from wwwlogs --volumes-from wwwdata --volumes-from wwwroot -v /Users/randy/wwwetc/nginx/sites-available:/etc/nginx/sites-available -p 80:80 -p 443:443 --link php:php --name lnmp raw34/nginx

docker run -idt --name myfpm5 -v ~/wwwroot/repo:/www php:5.6-fpm
docker run -idt -p 80:80 -p 433:433 --name mynginx -v ~/wwwetc/nginx/nginx.conf:/etc/nginx/nginx.conf -v ~/wwwetc/nginx/sites-available:/etc/nginx/sites-available --link myfpm5:myfpm5 nginx
