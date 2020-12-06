---
title: jenkins集成gitolite提交自动构建发布
tags:
  - Git
id: '5668'
categories:
  - - GNU/Linux
date: 2014-07-18 20:14:12
---


<!-- more -->
jenkins可以集成gitolite,这样代码推到仓库后,jenkins可以立即构建工程，并可以自动发布。

**1、配置gitolite用户**

jenkins要执行构建任务,必须可以从gitolite仓库获取代码，因此需要为jenkins配置访问gitolite的用户。可以参考"[gitolite v3安装配置](https://openwares.net/linux/gitolite_v3_install_setup.html)"。只要记住jenkins的用户主目录在/var/lib/jenkins就可以了，与普通用户的配置并无二致。同样可以在用户主目录下的.ssh目录下添加config来访问gitolite,注意known_hosts中要添加gitolite主机的fingerprint。
```js
Host gitsvr
 Hostname *.*.*.*
 User git 
 Port 2022
 IdentityFile /var/lib/jenkins/.ssh/id_rsa
```
这里配置的gitolie访问别名为gitsvr,然后jenkins使用如gitsvr:project就可以访问到gitolite管理的仓库project了。

**2、配置gitolite hook** 

jenkins的git插件目前只支持定时poll，虽然设置一个较短时间的轮询间隔也能满足要求，但总觉不太爽利。幸好git和
gitolite都支持hook，而且jenkins的git插件提供了一个url接收通知来进行构建。所以使用gitolite的post-receive
钩子通知jenkins构建就可以了。


gitolite用户的~/.gitolite/hooks/common/post-receive添加如下脚本:
```js
#!/bin/bash

JENKINS_URL=http://*.*.*.*:8082
GIT_URL=gitsvr
echo -n "Notifying Jenkins..."
wget -q $JENKINS_URL/git/notifyCommit\\?url=$GIT_URL:$GL_REPO -O /dev/null
echo "done."
```

gitolite自动设置了一个环境变量GL_REPO,这个变量的值是当前操作的仓库的名字。为post-receive脚本添加执行权限，然后执行gitolite setup就可以了。
```js
$ chmod +x post-receive
$ gitolite setup
```

**3、配置jenkins job**

现在就可以添加jenkins job了

几个关键的地方:

源代码管理选择git后,设置Repository URL为配置好的别名加仓库名就可以，比如gitsvr:project

构建触发器(build trigger)要选择poll SCM，但不要输入任何值，保持空白即可。

这里采用gradle进行构建，选择Invoke Gradle,如果构建文件名字采用默认的build.gradle，则除了tasks那里填写build,其他字段空着使用默认值即可。

构建后在自动发布到tomcat7,因此这里选择"Deploy war/ear to a container",然后选择tomcat7。WAR/EAR files填写相对于当前job的workspace目录的需要部署的文件的名字，比如build/libs/project.war。Context path输入自己想使用的访问路径，比如输入foo,则需要这样访问应用程序http://domain.tld/foo。其他字段为tomcat7的管理用户账号和访问tomcat7的URL。

如果想将应用程序部署到root context,只需在Context path里输入"/"即可,这样访问应用程序时就更简单了，http://domain.tld/就是访问的root context。

这样jenkins就算配置完了，可以通过手动构建进行测试。

**4、其他问题**

*   由于项目使用了myBatis,因此有一些xml资源文件分散在dao接口目录中,所以需要在build.gradle脚本中添加资源目录，否则这些xml文件不会被打包，从而出现错误:
    
    ```js
    sourceSets {
     main {
     resources.srcDirs = \['src/main/java'\]
     }
    }
    ```
    如果不指定资源目录，则需要将资源放入src/main/resources目录。

*   gradle war插件默认生成的war包名字格式为:
    ${baseName}-${appendix}-${version}-${classifier}.${extension}
    也就是war.archiveName变量的默认值。
    
    gradle自动构建时生成的war包名字可能不是你想要的，因此可以明确的指定war包名字，比如在build.gradle文件中添加如下行：
    war.archiveName = 'project.war'

*   用于tomcat7自动部署的管理用户必须具有manager-script角色,manager-gui角色是不够的，不然会有错误出现：
    The username you provided is not allowed to use the text-based Tomcat Manager (error 403)
    
    在/etc/tomcat7/tomcat-users.xml文件中为管理用户添加manager-script角色即可。
    

References:
\[1\][Gitolite to Jenkins Post Commit Kick](http://meschbach.com/kb/gitolite-jenkins-hook.html)

**\===
\[erq\]**