---
title: ceph cluster benchmark
tags:
  - Debian
id: '9064'
categories:
  - - GNU/Linux
date: 2019-11-14 10:34:06
---


<!-- more -->
创建测试使用的pool
```js
$ ceph osd pool create testbench 32 32
```

写测试
```js
$ rados bench -p testbench 10 write --no-cleanup
hints = 1
Maintaining 16 concurrent writes of 4194304 bytes to objects of size 4194304 for up to 10 seconds or 0 objects
Object prefix: benchmark_data_work_17785
 sec Cur ops started finished avg MB/s cur MB/s last lat(s) avg lat(s)
 0 0 0 0 0 0 - 0
 1 16 18 2 7.99976 8 0.743612 0.641529
 2 16 30 14 27.9973 48 1.85864 1.29122
 3 16 42 26 34.663 48 1.28555 1.39395
 4 16 55 39 38.9956 52 1.32261 1.43965
 5 16 58 42 33.5958 12 1.53666 1.44482
 6 16 68 52 34.662 40 2.08014 1.50223
 7 16 84 68 38.8516 64 0.823587 1.5045
 8 16 96 80 39.9944 48 0.899492 1.44845
 9 16 114 98 43.5496 72 0.633734 1.40136
 10 16 123 107 42.7941 36 0.856593 1.3861
Total time run: 10.6523
Total writes made: 124
Write size: 4194304
Object size: 4194304
Bandwidth (MB/sec): 46.5625
Stddev Bandwidth: 20.2254
Max bandwidth (MB/sec): 72
Min bandwidth (MB/sec): 8
Average IOPS: 11
Stddev IOPS: 5.05635
Max IOPS: 18
Min IOPS: 2
Average Latency(s): 1.3707
Stddev Latency(s): 0.472979
Max latency(s): 2.64427
Min latency(s): 0.539447
```

顺序读测试
```js
$ rados bench -p testbench 10 seq
hints = 1
 sec Cur ops started finished avg MB/s cur MB/s last lat(s) avg lat(s)
 0 0 0 0 0 0 - 0
 1 16 42 26 103.976 104 0.588145 0.431675
 2 16 69 53 105.983 108 0.593612 0.500811
 3 16 98 82 109.319 116 0.555486 0.529656
 4 15 124 109 108.986 108 0.408214 0.531251
Total time run: 4.45077
Total reads made: 124
Read size: 4194304
Object size: 4194304
Bandwidth (MB/sec): 111.441
Average IOPS: 27
Stddev IOPS: 1.25831
Max IOPS: 29
Min IOPS: 26
Average Latency(s): 0.567093
Max latency(s): 1.16315
Min latency(s): 0.062019
```

随机读测试
```js
$ rados bench -p testbench 10 rand
hints = 1
 sec Cur ops started finished avg MB/s cur MB/s last lat(s) avg lat(s)
 0 0 0 0 0 0 - 0
 1 16 43 27 107.978 108 0.548233 0.400351
 2 16 70 54 107.985 108 0.507102 0.467039
 3 16 99 83 110.653 116 0.66861 0.518288
 4 16 128 112 111.987 116 0.821184 0.518217
 5 16 155 139 111.187 108 0.71247 0.532804
 6 16 183 167 111.32 112 0.698042 0.541571
 7 16 211 195 111.416 112 0.137 0.545219
 8 16 239 223 111.488 112 0.797219 0.549091
 9 16 267 251 111.543 112 0.249707 0.547871
 10 16 296 280 111.988 116 0.577749 0.555318
Total time run: 10.5902
Total reads made: 297
Read size: 4194304
Object size: 4194304
Bandwidth (MB/sec): 112.179
Average IOPS: 28
Stddev IOPS: 0.816497
Max IOPS: 29
Min IOPS: 27
Average Latency(s): 0.565831
Max latency(s): 1.20987
Min latency(s): 0.0559923
```

清除测试数据
```js
$ rados -p testbench cleanup
Removed 124 objects
```


References:
\[1\][CHAPTER 9. BENCHMARKING PERFORMANCE](https://access.redhat.com/documentation/en-us/red_hat_ceph_storage/1.3/html/administration_guide/benchmarking_performance)