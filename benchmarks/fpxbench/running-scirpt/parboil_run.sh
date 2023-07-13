#export GPUFPX_OBJ=/fpxbench/nvbit_release/tools/GPU-FPX/GPU-FPX.so
#export GPUFPX_PRELOAD_FLAG="LD_PRELOAD=${GPUFPX_OBJ}"

if $ENABLE_COMPILE;
then
	cd ..
	source ./compile.sh
fi

source /fpxbench/fpxbench/gpufpx-exps/share.sh
EXEs=$(find ./ -name "run.sh") # find all executable paths
for exe in ${EXEs}
do
        run=${exe##*/} # get the name of executable [[Bash -- get the last substring for a separator]]
        size=${#run} #[[Bash -- get the length of a string]]
        dir=${exe::(-$size+0)} #[[Bash -- get the specific substring]]
        cd $dir;
        echo "in ${dir}....." 
        #(time eval ${PRELOAD_FLAG} "./${run}") >stdout.txt 2>stderr.txt
        if $ENABLE_PLAIN;
	then
		comm_plain="eval bash run.sh"
        	echo ${comm_plain} > run_plain.sh
        	echo "run plain program"
        	(time timeout -k 1s 2000s bash run_plain.sh) >stdout.plain.txt 2>stderr.plain.txt
	fi
	if $ENABLE_GPUFPX;
	then
		comm_gpufpx="eval ${GPUFPX_PRELOAD_FLAG} bash run.sh"
        	echo ${comm_gpufpx} > run_gpufpx.sh
        	echo "run gpu-fpx on program"
        	(time timeout -k 1s 2000s bash run_gpufpx.sh) >${gpufpx_output_filename} 2>${gpufpx_err_filename}
	fi
	cd -;
done
