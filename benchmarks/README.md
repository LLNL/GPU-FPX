# gpufpx-docker
### Overview
1. We have 144 GPU programs in total. 
2. We suggest all experiments are run in a container to ensure reproducibility.
3. Due to different Cuda version requirements, we need two containers. One is named fpx, one is named cuda-samples.
4. The architcture we are using is Turing and Ampere. 

### Create containers
#### Create `fpx`
```
cp Dockerfile_fpx Dockerfile
sudo docker build -t fpx .
```

#### Create `cuda-samples`
```
cp Dockerfile_cuda-samples Dockerfile
sudo docker build -t cuda-samples .
```

### Run containers
Check `volume_run_fpx.sh` and `volume_run_cuda-samples.sh`, change the local files you want to mount, notice that you may want to modify the corresponding `Makefile_*`. 
```
bash volume_run_fpx.sh
bash volume_run_cuda-samples.sh
```

### Run programs in the container
In each container, run 
```
find ./ -name "comp_run_all.sh"
```
Check how we organized the run
