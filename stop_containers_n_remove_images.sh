docker stop nginx0
docker stop php_fpm0
docker rm nginx0
docker rm php_fpm0
docker rmi test_ingipro_nginx0
docker rmi test_ingipro_php_fpm0
docker network prune
