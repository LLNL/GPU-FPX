# export GPUFPX_OBJ=/cuda-examples/nvbit_release/tools/GPU-FPX/GPU-FPX.so
# #export GPUFPX_OBJ=/cuda-examples/nvbit_release/tools/GPU-FPX-no-check/GPU-FPX-no-check.so
# export BINFPE_OBJ=/cuda-examples/nvbit_release/tools/detect_fp_exceptions_ori/detect_fp_exceptions.so
# export COUNT_TOOL=/cuda-examples/nvbit_release/tools/instr_count_fp/instr_count_fp.so
# export TOTAL_COUNT_TOOL=/cuda-examples/nvbit_release/tools/instr_count/instr_count.so

export GPUFPX_DETECTOR=/cuda-examples/nvbit_release/tools/GPU-FPX/GPU-FPX.so
export GPUFPX_PRELOAD_FLAG="LD_PRELOAD=${GPUFPX_DETECTOR}"

# export GPUFPX_PRELOAD_FLAG="LD_PRELOAD=${GPUFPX_OBJ}"
# export BINFPE_PRELOAD_FLAG="LD_PRELOAD=${BINFPE_OBJ}"
# export COUNT_PRELOAD_FLAG="LD_PRELOAD=${COUNT_TOOL}"
# export TOTAL_COUNT_PRELOAD_FLAG="LD_PRELOAD=${TOTAL_COUNT_TOOL}"


EXEs=$(find ./ -name "Makefile")
#EXEs='5_Domain_Specific/MonteCarloMultiGPU/MonteCarloMultiGPU 5_Domain_Specific/FDTD3d/FDTD3d 5_Domain_Specific/dxtc/dxtc 4_CUDA_Libraries/cuSolverRf/cuSolverRf 4_CUDA_Libraries/cuSolverSp_LinearSolver/cuSolverSp_LinearSolver 4_CUDA_Libraries/cuSolverSp_LowlevelQR/cuSolverSp_LowlevelQR 4_CUDA_Libraries/cuSolverDn_LinearSolver/cuSolverDn_LinearSolver 4_CUDA_Libraries/cuSolverSp_LowlevelCholesky/cuSolverSp_LowlevelCholesky 2_Concepts_and_Techniques/interval/interval'
#EXEs="./5_Domain_Specific/simpleVulkan/simpleVulkan ./5_Domain_Specific/vulkanImageCUDA/vulkanImageCUDA ./5_Domain_Specific/BlackScholes/BlackScholes ./5_Domain_Specific/fastWalshTransform/fastWalshTransform ./5_Domain_Specific/NV12toBGRandResize/NV12toBGRandResize ./5_Domain_Specific/simpleVulkanMMAP/simpleVulkanMMAP ./5_Domain_Specific/HSOpticalFlow/HSOpticalFlow ./2_Concepts_and_Techniques/reduction/reduction ./2_Concepts_and_Techniques/dct8x8/dct8x8 ./2_Concepts_and_Techniques/shfl_scan/shfl_scan ./2_Concepts_and_Techniques/sortingNetworks/sortingNetworks ./2_Concepts_and_Techniques/streamOrderedAllocation/streamOrderedAllocation ./3_CUDA_Features/newdelete/newdelete ./3_CUDA_Features/graphMemoryNodes/graphMemoryNodes ./3_CUDA_Features/StreamPriorities/StreamPriorities ./3_CUDA_Features/cudaTensorCoreGemm/cudaTensorCoreGemm ./3_CUDA_Features/simpleCudaGraphs/simpleCudaGraphs ./0_Introduction/simpleCubemapTexture/simpleCubemapTexture ./0_Introduction/simpleAssert_nvrtc/simpleAssert_nvrtc ./4_CUDA_Libraries/conjugateGradientUM/conjugateGradientUM ./4_CUDA_Libraries/conjugateGradientMultiBlockCG/conjugateGradientMultiBlockCG"
for mkfile in ${EXEs}
do
        mk=${mkfile##*/}
        size=${#mk}
#       echo $size
#       echo ${mkfile::(-$size+0)}
        dir=${mkfile::(-$size+0)}
        cd $dir;
        echo "in ${dir}....."

 #       echo "compile..."
 #       make &> makelog
        run=$(find ./ -type f -executable)
 #       comm_plain="eval ./${run}"
 #       echo ${comm_plain} > run_plain.sh
 #       echo "run plain program"
 #       (time timeout -k 1s 2000s bash run_plain.sh) >stdout.plain.txt 2>stderr.plain.txt

 	export SAMPLING=16
        comm_gpufpx="eval ${GPUFPX_PRELOAD_FLAG} ./${run}"
        echo ${comm_gpufpx} > run_gpufpx.sh
        echo "run gpu-fpx on program"
        (time timeout -k 1s 2000s bash run_gpufpx.sh) >stdout.gpufpx-sampling.txt 2>stderr.gpufpx-sampling.txt

#        comm_binfpe="eval ${BINFPE_PRELOAD_FLAG} ./${run}"
#        echo ${comm_binfpe} > run_binfpe.sh
#        echo "run binfpe on program"
#        (time timeout -k 1s 2000s bash run_binfpe.sh) >stdout.binfpe.txt 2>stderr.binfpe.txt

#        comm_count="eval ${COUNT_PRELOAD_FLAG} ./${run}"
#        echo ${comm_count} > run_count.sh
#        echo "count the fp instructions"
#        (timeout -k 1s 2000s bash run_count.sh) > counts.txt

#        comm_total_counts="eval ${TOTAL_COUNT_PRELOAD_FLAG} ./${run}"
#        echo ${comm_total_counts} > run_total_count.sh
#        echo "count the total instructions"
#        (timeout -k 1s 2000s bash run_total_count.sh) > total_counts.txt
        #comm="eval ${PRELOAD_FLAG} ./${run}"
        #echo ${comm} > run.sh
        #comm2="eval ./${run}"
        #echo ${comm2} > run_ori.sh
        #echo "run original program"
        #(time timelimit -t2000 bash run_ori.sh) >stdout_ori.perf.txt 2>stderr_ori.perf.txt
        #echo "run checking program"
        #(time timelimit -t2000 bash run.sh) >stdout.perf.txt 2>stderr.perf.txt

        # comm_binfpe="eval ${BINFPE_PRELOAD_FLAG} ./${run}"
        # echo ${comm_binfpe} > run_binfpe.sh
        #comm2_soap="eval ./${run}"
        #echo ${comm2_soap} > run_ori_soap.sh
        #echo "run original soap program"
        #(time timelimit -t2000 bash run_ori_soap.sh) >stdout_ori.soap.perf.txt 2>stderr_ori.soap.perf.txt
        #echo "run checking soap program"
        #(time timelimit -t2000 bash run_soap.sh) >stdout.soap.perf.txt 2>stderr.soap.perf.txt
        cd -;
done
python3 read_perf_except_count.py
cat excp_perf.csv
cat excp_perf.csv | column -t -s, | less -S
