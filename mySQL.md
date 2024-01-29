# Steps to works with My SQL
## Create folders with database
Create folder ".mysql-database" and ".mysql" for storing mysql database data and mysql workbench data: 
command `mkdir .mysql-database .mysql`

## Start SQL server
Command: `docker run --rm -d --name=mysql-server --network=host -v$(pwd)/.mysql-database:/var/lib/mysql -eMYSQL_ROOT_PASSWORD=1 mysql`

> **_NOTE:_**  Used password "1" set by MYSQL_ROOT_PASSWORD environment variable; server will work as daemon

## Stop SQL server
Command: `docker stop mysql-server`

## Launch mySQL workbench
Command: `docker run --rm -it -v$(pwd)/.mysql:/home/user/.mysql -v/tmp/.X11-unix:/tmp/.X11-unix -v${XAUTHORITY}:/home/user/.Xauthority:ro -eDISPLAY=${DISPLAY} --network=host mysql-workbench mysql-workbench`

## Tips
Use alias instead of full command.
Save them into bashrc file.
1. Open terminal `ctrl+alt+t`
2. Open text editor with command `nano ~/.bashrc`
3. Scroll down using key arrow down
4. Create aliases like this:
``` {bash} 
alias mysql-workbench="docker run --rm -it -v$(pwd)/.mysql:/home/user/.mysql -v/tmp/.X11-unix:/tmp/.X11-unix -v${XAUTHORITY}:/home/user/.Xauthority:ro -eDISPLAY=${DISPLAY} --network=host mysql-workbench mysql-workbench"

alias mysql-server-start="docker run --rm -d --name=mysql-server --network=host -v$(pwd)/.mysql-database:/var/lib/mysql -eMYSQL_ROOT_PASSWORD=1 mysql"

alias mysql-server-stop="docker stop mysql-server"
```
