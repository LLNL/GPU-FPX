cd cuda-samples
git clone https://github.com/NVIDIA/cuda-samples.git
cp valid-programs.txt ./cuda-samples/
cp delete-extra.py ./cuda-samples/
cd cuda-samples/
python3 delete-extra.py
