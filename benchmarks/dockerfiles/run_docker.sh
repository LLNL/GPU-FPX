# (time sudo docker run --gpus all gpufpx/sc22-artifact:fpxbench make fpxbench_small) >small_output.txt 2>small_time.txt
# (time sudo docker run --gpus all gpufpx/sc22-artifact:fpxbench make fpxbench_except) >except_output.txt 2>except_time.txt
# (time sudo docker run --gpus all gpufpx/sc22-artifact:fpxbench make fpxbench_varopt) >var_output.txt 2>var_time.txt
# (time sudo docker run --gpus all gpufpx/sc22-artifact:fpxbench make fpxbench_all) > all_output.txt 2>all_time.txt
# (time sudo docker run --gpus all gpufpx/sc22-artifact:cuda-samples make cuda-samples_small) > cuda-small.txt 2>cuda-small_time.txt
# (time sudo docker run --gpus all gpufpx/sc22-artifact:cuda-samples make cuda-samples_all) > cuda-all_output.txt 2>cuda-all_time.txt
(time sudo docker run --gpus all fpxbench make fpxbench_all) > fpx_all_output.txt 2>fpx_all_time.txt
(time sudo docker run --gpus all gpufpx/artifact:cuda-samples make cuda-samples_all) > cuda-all_output.txt 2>cuda-all_time.txt
