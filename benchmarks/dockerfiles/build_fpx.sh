bash before_push.sh
cp Dockerfile_fpx Dockerfile
cp Makefile_fpx Makefile
sudo docker build -t fpx .
