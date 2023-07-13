#export GPUFPX_OBJ=/fpxbench/nvbit_release/tools/GPU-FPX/GPU-FPX.so
#export GPUFPX_PRELOAD_FLAG="LD_PRELOAD=${GPUFPX_OBJ}"
export GPUFPX_OBJ=/fpxbench/nvbit_release/tools/GPU-FPX-no-check/GPU-FPX-no-check.so
export GPUFPX_PRELOAD_FLAG="LD_PRELOAD=${GPUFPX_OBJ}"

#export GPUFPX_OBJ=/fpxbench/nvbit_release/tools/detect_fp_exceptions_ori/detect_fp_exceptions_ori.so
#export GPUFPX_PRELOAD_FLAG="LD_PRELOAD=${GPUFPX_OBJ}"



#export SAMPLING=16
#gpufpx_output_filename="stdout.gpufpx-smapling.txt"
#gpufpx_err_filename="stderr.gpufpx-smapling.txt"

#export SAMPLING=0
#gpufpx_output_filename="stdout.gpufpx.txt"
#gpufpx_err_filename="stderr.gpufpx.txt"

#export SAMPLING=0
#gpufpx_output_filename="stdout.gpufpx.fastmath.txt"
#gpufpx_err_filename="stderr.gpufpx.fastmath.txt"

export SAMPLING=0
gpufpx_output_filename="stdout.gpufpx-nocheck.txt"
gpufpx_err_filename="stderr.gpufpx-nocheck.txt"

#export SAMPLING=0
#gpufpx_output_filename="stdout.binfpe.txt"
#gpufpx_err_filename="stderr.binfpe.txt"



export ENABLE_COMPILE=false
export ENABLE_PLAIN=false
export ENABLE_GPUFPX=true
