# docker

Bash-wrapper for pgadmin4 docker-container

### Running

- git clone https://github.com/itksb/docker.git
- cd docker
- checkout pgadmin4
- edit .env file
- run service: ./run.sh -s  
- open http://localhost:8050 (according to .env param) your browser
- enjoy
- see status: ./run.sh -p
- enter to the running service container: ./run.sh -e
- stop service: ./run.sh -k

All user sessions, server settings and pgadmin4 database will be in the "private" folder of cloned project.
You can change the location by editing "run.sh" file (start_service() function)