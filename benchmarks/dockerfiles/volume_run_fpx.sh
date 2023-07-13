sudo docker run --gpus all -it \
  -v /home/xinyi/nvbit-exceptions/tools/GPU-FPX/:/fpxbench/GPU-FPX/ \
  -v /home/xinyi/nvbit-exceptions/tools/GPU-FPX-ana/:/fpxbench/GPU-FPX-ana/ \
  -v /home/xinyi/nvbit-exceptions/tools/instr_count_fp/:/fpxbench/instr_count_fp/ \
  -v /home/xinyi/nvbit-exceptions/tools/instr_count/:/fpxbench/instr_count/ \
  -v /home/xinyi/nvbit-exceptions/tools/detect_fp_exceptions_ori/:/fpxbench/detect_fp_exceptions_ori/ \
  -v /home/xinyi/nvbit-exceptions/tools/GPU-FPX-no-check/:/fpxbench/GPU-FPX-no-check/ \
  -v "$(pwd)"/fpxbench:/fpxbench/fpxbench/ \
  -v /home/xinyi/experiments_gpuchecker/exps_docker/Makefile:/fpxbench/Makefile fpx bash

