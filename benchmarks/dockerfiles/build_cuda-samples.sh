bash before_push.sh
cp Dockerfile_cuda-samples Dockerfile
cp Makefile_cuda-samples Makefile
sudo docker build -t cuda-samples .
