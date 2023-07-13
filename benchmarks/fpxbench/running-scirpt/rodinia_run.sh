#EXEs=$(find Samples/ -type f -executable) # find all executable paths
#export GPUFPX_OBJ=/fpxbench/nvbit_release/tools/GPU-FPX/GPU-FPX.so
#export GPUFPX_PRELOAD_FLAG="LD_PRELOAD=${GPUFPX_OBJ}"
source /fpxbench/fpxbench/gpufpx-exps/share.sh
MAKEFILES=$(find ./ -name "Makefile") # find all executable paths
for mkfile in ${MAKEFILES}
do
        mk=${mkfile##*/} # get the name of executable [[Bash -- get the last substring for a separator]]
        size=${#mk} #[[Bash -- get the length of a string]]
        dir=${mkfile::(-$size+0)} #[[Bash -- get the specific substring]]
        cd $dir;
        echo "in ${dir}....." 
        #(time eval ${PRELOAD_FLAG} "./${run}") >stdout.txt 2>stderr.txt
#	./run
#	run=$(find ./ -type f -executable)
	if $ENABLE_COMPILE;
	then
		make clean
        	make&>makelog 
	fi
	if $ENABLE_PLAIN; 
	then
		comm_plain="eval ./run"
        	echo ${comm_plain} > run_plain.sh
        	echo "run plain program"
        	(time timeout -k 1s 2000s bash run_plain.sh) >stdout.plain.txt 2>stderr.plain.txt
	fi
	if $ENABLE_GPUFPX;
	then
        	comm_gpufpx="eval ${GPUFPX_PRELOAD_FLAG} ./run"
        	echo ${comm_gpufpx} > run_gpufpx.sh
        	echo "run gpu-fpx on program"
        	(time timeout -k 1s 2000s bash run_gpufpx.sh) >${gpufpx_output_filename} 2>${gpufpx_err_filename}
	fi
	cd -;
done
