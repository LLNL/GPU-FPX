export GPUFPX_OBJ=/cuda-examples/nvbit_release/tools/GPU-FPX/GPU-FPX.so
export BINFPE_OBJ=/cuda-examples/nvbit_release/tools/detect_fp_exceptions_ori/detect_fp_exceptions.so
export COUNT_TOOL=/cuda-examples/nvbit_release/tools/instr_count_fp/instr_count_fp.so
export TOTAL_COUNT_TOOL=/cuda-examples/nvbit_release/tools/instr_count/instr_count.so

export GPUFPX_PRELOAD_FLAG="LD_PRELOAD=${GPUFPX_OBJ}"
export BINFPE_PRELOAD_FLAG="LD_PRELOAD=${BINFPE_OBJ}"
export COUNT_PRELOAD_FLAG="LD_PRELOAD=${COUNT_TOOL}"
export TOTAL_COUNT_PRELOAD_FLAG="LD_PRELOAD=${TOTAL_COUNT_TOOL}"

DIRs='./5_Domain_Specific/dwtHaar1D ./4_CUDA_Libraries/simpleCUFFT ./2_Concepts_and_Techniques/scalarProd ./3_CUDA_Features/cdpBezierTessellation ./5_Domain_Specific/FDTD3d ./4_CUDA_Libraries/cuSolverSp_LowlevelQR '
for dir in ${DIRs}
do
#        mk=${mkfile##*/}
#        size=${#mk}
#       echo $size
#       echo ${mkfile::(-$size+0)}
#        dir=${mkfile::(-$size+0)}
        cd $dir;
        echo "in ${dir}....."

        echo "compile..."
        make &> makelog
	run=$(find ./ -type f -executable)
	comm_plain="eval ./${run}"
	echo ${comm_plain} > run_plain.sh
	echo "run plain program"
	(time timelimit -t2000 bash run_plain.sh) >stdout.plain.txt 2>stderr.plain.txt
	
	comm_gpufpx="eval ${GPUFPX_PRELOAD_FLAG} ./${run}"
	echo ${comm_gpufpx} > run_gpufpx.sh
	echo "run gpu-fpx on program"
	(time timelimit -t2000 bash run_gpufpx.sh) >stdout.gpufpx.txt 2>stderr.gpufpx.txt

	comm_binfpe="eval ${BINFPE_PRELOAD_FLAG} ./${run}"
	echo ${comm_binfpe} > run_binfpe.sh
	echo "run binfpe on program"
	(time timelimit -t2000 bash run_binfpe.sh) >stdout.binfpe.txt 2>stderr.binfpe.txt
	
	comm_count="eval ${COUNT_PRELOAD_FLAG} ./${run}"
	echo ${comm_count} > run_count.sh
	echo "count the fp instructions"
	(timelimit -t1000 bash run_count.sh) > counts.txt

	comm_total_counts="eval ${TOTAL_COUNT_PRELOAD_FLAG} ./${run}"
	echo ${comm_total_counts} > run_total_count.sh
	echo "count the total instructions"
	(timelimit -t1000 bash run_total_count.sh) > total_counts.txt
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
