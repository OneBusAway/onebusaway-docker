docker rm $(docker ps -aq) ; docker rmi $(docker images -q) ; docker volume rm $(docker volume ls -q)

docker-compose up --build