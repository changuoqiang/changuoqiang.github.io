---
title: unzip解压缩中文名乱码问题
tags: []
id: '8136'
categories:
  - - uncategorized
date: 2018-12-07 10:34:03
---

windows平台生成的zip文件名是使用CP936也就是GBK编码的，导致这样的文件在linux平台utf-8环境下解压缩的时候文件名会成为乱码，这个问题由来已久，但并没有从zip那边有个根本性的解决方案。

可以使用python的zipfile模块来解决这个问题。

python3版本：

```
#!/usr/bin/env python3

import os
import sys
import zipfile

print("Processing File " + sys.argv[1])

file=zipfile.ZipFile(sys.argv[1],"r");
for name in file.namelist():
    utf8name=name.encode('cp437').decode('cp936')
    print("Extracting " + utf8name)
    pathname = os.path.dirname(utf8name)
    if not os.path.exists(pathname) and pathname!= "":
        os.makedirs(pathname)
    data = file.read(name)
    if not os.path.exists(utf8name):
        fo = open(utf8name, "wb")
        fo.write(data)
        fo.close
file.close()
```

因为zipfile把所有非utf-8编码格式的文件名都作为cp437进行处理，因此需要先还原回cp437，然后重新编码为cp936。

python版本见Reference\[1\]。

References:

\[1\][Linux 下 zip 文件解压乱码解决方案](https://www.jianshu.com/p/72bb8d2ed4df)