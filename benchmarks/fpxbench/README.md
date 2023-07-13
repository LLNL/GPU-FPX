#### polybenchGpu

#### Paraboil
You need to download the benchmark, driver and dataset from [here](http://impact.crhc.illinois.edu/parboil/parboil_download_page.aspx).
Unzip these three files inside `fpxbench`. The 'driver' folder should be named as `paraboil`, the 'benchmark' folder should be named as `benchmark`, and the 'dataset' folder should be named as `dataset`.

##### Command to create the `paraboil` benchmark
```
mv dataset paraboil
mv benchmark paraboil
make paraboil

```
