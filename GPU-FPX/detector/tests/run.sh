export FP_EXCEPTION_HOME=/home/xinyi/nvbit_release/tools/detect_fp_exceptions
export PRELOAD_FLAG="LD_PRELOAD=${FP_EXCEPTION_HOME}/detect_fp_exceptions.so"

if_match(){
    OUT_FILE=$1
    GOLD_FILE=$2


## for each line in GOLD_FILE
    while read line ; do

        ## check if line exist in OUT_FILE; then assign result to variable
        #X=$(grep -Fxq"^${line}$" ${OUT_FILE})


        ## if variable is blank (meaning GOLD_FILE line not found in OUT_FILE)
        ## print 'false' and exit
        #if [[ -z $X ]] ; then
        if ! grep -Fxq -- "$line" ${OUT_FILE}; then
            echo "FAIL!"
            echo $line
            break
        fi
done < ${GOLD_FILE}

## if script does not exit after going through each line in GOLD_FILE,
## then script will print true
echo "PASS"

}

DIRs='test_fp32_nan_found test_fp32_underflow_found
test_fp64_underflow_found test_fp32_div0 test_fp32_overflow_found 
test_fp64_div0 test_fp64_nan_found test_fp64_overflow_found'
#DIRs='test_fp32_nan_found'
for dir in $DIRs; do
    cd $dir;
    echo "in ${dir}...."
    eval ${PRELOAD_FLAG} ./main > ${dir}.txt
    if_match ${dir}.txt ${dir}_gold.txt
    # r=$(diff ${dir}.txt ${dir}_gold.txt)
    # if [ $r = ""];
    # then
    #     echo "PASS!"
    # else
    #     echo "FAIL"
    #     echo $r > diff.txt
    #     echo "the diff files are stored in ${dir}/diff.txt"
    # fi
    echo
    cd ..;
done
