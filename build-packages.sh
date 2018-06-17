#!/bin/sh


opm install -l
oscript -make src/cmd/ovm.os ovm.exe
mv ovm.exe builders/deb/
VERSION=`mono ./builders/deb/ovm.exe -v`

docker-compose -f builders/docker-compose.yml build deb-builder
docker-compose -f builders/docker-compose.yml up deb-builder

#docker-compose up 
#TODO - надо подумать на тестовым запуском - фактически мы должны проверить что пакеты установились и можно установить движок и какую-нибудь библиотеку: например logos
# проверять нужно не под root пользователем, а с минимальными привелегиями