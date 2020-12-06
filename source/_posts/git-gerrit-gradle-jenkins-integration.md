---
title: Git+Gerrit+Gradle+Jenkins持续集成
tags:
  - Git
id: '4893'
categories:
  - - GNU/Linux
date: 2014-01-21 20:29:38
---

Jenkins是开源的CI(Continuous Integration)服务器。
<!-- more -->
Jenkins有丰富的插件,可以完成工程的自动构建,自动测试,自动部署等。CI的好处无需多言。

这里选用Git作为版本控制系统,使用Gerrit审核代码,使用Gradle进行系统构建,然后使用Jenkins将这几者集成在一起。

当向Gerrit推送更新时,会触发Jenkins进行编译测试,也就是为Gerrit做代码的verify工作,Jenkins会调用Gradle来编译代码,verify的结果Jenkins会自动反馈到Gerrit服务器。

当代码通过审核合并到代码库后也可以触发Jenkins来编译通过审核的代码,然后将编译结果自动部署到测试服务器进行人工或自动化测试。

**安装插件**

需要安装的插件有git plugin,gerrit trigger,gradle plugin和Deploy Plugin(Deploy to container Plugin)

Manage Jenkins -> Plugin Manager -> Available,可以通过filter定位到以上插件,点选安装即可。

**在gerrit服务器上为jenkins添加账户并授权**

当有事件触发时,jenkins要访问gerrit服务器,拉取代码,并反馈构建结果,因此需要为jenkins分配帐号。

_生成密钥对_

使用官方源安装的jenkins,用户主目录在/var/lib/jenkins,因此在这个目录下生成jenkins所需的公私密钥对。

```js
# cd /var/lib/jenkins
# mkdir .ssh
# ssh-keygen -b 2048 -t rsa -f .ssh/id_rsa
```

_使用gerrit shell为jenkins 添加账户_

```js
$ ssh cr gerrit create-account jenkins --ssh-key - < id_rsa.pub
```

id_rsa.pub是jenkins的公钥。

_为jenkins用户授权_

将jenkins添加到Non-Interactive Users组中,在工程权限管理的页签:

*   新增refs/*引用,将其read权限授予Non-Interactive Users
*   新增refs/heads/*应用,将其Label Verified权限授予Non-Interactive Users
*   确保Global Capabilities->Stream Events访问权限授予Non-Interactive Users,gerrit2.8.1默认已经授权,如果没有需要手动添加。

**在jenkins上添加需要访问的gerrit服务器**

Manage Jenkins -> Gerrit Trigger -> Add New Server,填写相关字段,以下字段必填:

*   name
 给gerrit服务器起个名字
*   Hostname
gerrit服务器的主机名,比如review.domain.tld
*   Frontend URL
通过什么URL可以直接访问到gerrit,比如http://review.domain.tld/
*   SSH Port
Gerrit服务器的SSH服务端口,比如29418
*   Username
Jenkins访问Gerrit服务器使用的账户名,填入在gerrit服务器为jenkins分配的账户名,比如jenkins
*   SSH Keyfile
访问Gerrit SSH的私钥,默认使用/var/lib/jenkins/.ssh/id_rsa

之后点击保存就可以了。

**添加为gerrit服务的verify工作**

点击jenkins左侧导航栏的New Job,输入job name,然后选择Build a free-style software project。配置如下:

*   Source Code Management
选择git
Repositories -> Repository URL 输入访问git仓库的ssh路径,比如ssh://jenkins@review.domain.tld:29418/project.git
Repositories -> Refspec 点击advance可以看到,这里输入$GERRIT_REFSPEC,这个值来自gerrit trigger的设置。
Branches to build -> Branch Specifier (blank for 'any') 输入$GERRIT_BRANCH,同样来自gerrit trigger的设置。

*   Build Triggers
选择Gerrit event
*   Gerrit Trigger
Choose a server 选择前面步骤配置好的gerrit服务器
Trigger on 选择Patchset Created,当提交新的patchset后,jenkins自动为gerrit做verify工作。
*   Gerrit Project
type选择plain,pattern输入工程名字,后面的branches一栏,type选plain,pattern输入devel(需要拉取的分支)
*   Build
下拉选择invoke gradle script,然后选择invoke gradle就可以了。

这样一个工作就配置完成了,每次gerrit服务接收到开发人员提交的changes,都会通知jenkins,自动verify就行了,不要开发人员去手工编译工程。

这是个自动触发的任务,手动触发会出现错误,因为手动触发时$GERRIT_REFSPEC变量没有定义:

```js
Started by user anonymous
Building in workspace /var/lib/jenkins/jobs/xxx_devel/workspace
Fetching changes from the remote Git repository
Fetching upstream changes from ssh://jenkins@review.domain.tld:29418/xxx.git
FATAL: Failed to fetch from ssh://jenkins@review.domain.tld:29418/xxx.git
hudson.plugins.git.GitException: Failed to fetch from ssh://jenkins@review.domain.tld:29418/xxx.git
at hudson.plugins.git.GitSCM.fetchFrom(GitSCM.java:625)
 ...
Caused by: hudson.plugins.git.GitException: Command "git fetch --tags --progress 
ssh://jenkins@review.domain.tld:29418/xxx.git $GERRIT_REFSPEC" returned status code 128:
stdout: 
stderr: fatal: Couldn't find remote ref $GERRIT_REFSPEC
```

**自动部署**

上面的工程只是测试新的提交能不能通过编译测试,编译结果没必要发布到测试服务器。但是当新的代码被合并到仓库后,可以自动触发jenkins编译,执行单元测试,然后将构建结果自动部署到tomcat应用服务器。

_设置tomcat管理_

安装tomcat管理组件
```js
# apt-get install tomcat7-admin
```

/etc/tomcat7/tomcat-users.xml添加:
\[xml\]
 <role rolename="manager-gui" />
 <user username="tomcat7" password="tomcat7" roles="manager-gui" />
\[/xml\]
重启tomcat7后才能登录管理界面http://domain.tld/manager/html

如果不安装tomcat管理组件，自动部署时会出现类似的错误：
```js
Deploying /var/lib/jenkins/jobs/dc/workspace/build/libs/reis.war to container Tomcat 7.x Remote
ERROR: Build step failed with exception
org.codehaus.cargo.container.ContainerException: Failed to redeploy \[/var/lib/jenkins/jobs/dc/workspace/build/libs/reis.war\]
at org.codehaus.cargo.container.tomcat.internal.AbstractTomcatManagerDeployer.redeploy(AbstractTomcatManagerDeployer.java:193)
at hudson.plugins.deploy.CargoContainerAdapter.deploy(CargoContainerAdapter.java:73)
at hudson.plugins.deploy.CargoContainerAdapter$1.invoke(CargoContainerAdapter.java:116)
at hudson.plugins.deploy.CargoContainerAdapter$1.invoke(CargoContainerAdapter.java:103)
at hudson.FilePath.act(FilePath.java:991)
at hudson.FilePath.act(FilePath.java:969)
at hudson.plugins.deploy.CargoContainerAdapter.redeploy(CargoContainerAdapter.java:103)
at hudson.plugins.deploy.DeployPublisher.perform(DeployPublisher.java:61)
at hudson.tasks.BuildStepMonitor$3.perform(BuildStepMonitor.java:45)
at hudson.model.AbstractBuild$AbstractBuildExecution.perform(AbstractBuild.java:779)
at hudson.model.AbstractBuild$AbstractBuildExecution.performAllBuildSteps(AbstractBuild.java:726)
at hudson.model.Build$BuildExecution.post2(Build.java:185)
at hudson.model.AbstractBuild$AbstractBuildExecution.post(AbstractBuild.java:671)
at hudson.model.Run.execute(Run.java:1766)
at hudson.model.FreeStyleBuild.run(FreeStyleBuild.java:43)
at hudson.model.ResourceController.execute(ResourceController.java:98)
at hudson.model.Executor.run(Executor.java:408)
Caused by: java.io.FileNotFoundException: http://192.168.0.8:8080/manager/text/list
at sun.net.www.protocol.http.HttpURLConnection.getInputStream0(HttpURLConnection.java:1835)
at sun.net.www.protocol.http.HttpURLConnection.getInputStream(HttpURLConnection.java:1440)
at org.codehaus.cargo.container.tomcat.internal.TomcatManager.invoke(TomcatManager.java:544)
at org.codehaus.cargo.container.tomcat.internal.TomcatManager.list(TomcatManager.java:686)
at org.codehaus.cargo.container.tomcat.internal.TomcatManager.getStatus(TomcatManager.java:699)
at org.codehaus.cargo.container.tomcat.internal.AbstractTomcatManagerDeployer.redeploy(AbstractTomcatManagerDeployer.java:174)
... 16 more
java.io.FileNotFoundException: http://192.168.0.8:8080/manager/text/list
at sun.net.www.protocol.http.HttpURLConnection.getInputStream0(HttpURLConnection.java:1835)
at sun.net.www.protocol.http.HttpURLConnection.getInputStream(HttpURLConnection.java:1440)
at org.codehaus.cargo.container.tomcat.internal.TomcatManager.invoke(TomcatManager.java:544)
at org.codehaus.cargo.container.tomcat.internal.TomcatManager.list(TomcatManager.java:686)
at org.codehaus.cargo.container.tomcat.internal.TomcatManager.getStatus(TomcatManager.java:699)
at org.codehaus.cargo.container.tomcat.internal.AbstractTomcatManagerDeployer.redeploy(AbstractTomcatManagerDeployer.java:174)
at hudson.plugins.deploy.CargoContainerAdapter.deploy(CargoContainerAdapter.java:73)
at hudson.plugins.deploy.CargoContainerAdapter$1.invoke(CargoContainerAdapter.java:116)
at hudson.plugins.deploy.CargoContainerAdapter$1.invoke(CargoContainerAdapter.java:103)
at hudson.FilePath.act(FilePath.java:991)
at hudson.FilePath.act(FilePath.java:969)
at hudson.plugins.deploy.CargoContainerAdapter.redeploy(CargoContainerAdapter.java:103)
at hudson.plugins.deploy.DeployPublisher.perform(DeployPublisher.java:61)
at hudson.tasks.BuildStepMonitor$3.perform(BuildStepMonitor.java:45)
at hudson.model.AbstractBuild$AbstractBuildExecution.perform(AbstractBuild.java:779)
at hudson.model.AbstractBuild$AbstractBuildExecution.performAllBuildSteps(AbstractBuild.java:726)
at hudson.model.Build$BuildExecution.post2(Build.java:185)
at hudson.model.AbstractBuild$AbstractBuildExecution.post(AbstractBuild.java:671)
at hudson.model.Run.execute(Run.java:1766)
at hudson.model.FreeStyleBuild.run(FreeStyleBuild.java:43)
at hudson.model.ResourceController.execute(ResourceController.java:98)
at hudson.model.Executor.run(Executor.java:408)
Build step 'Deploy war/ear to a container' marked build as failure
Finished: FAILURE
```

_新建job_

Trigger on选择change merged,Post-build Actions选择Deploy war/ear to a container,具体配置:

*   WAR/EAR files
指定构建后的包路径,相对于工程根路径,对于gradle构建war来说,这个值是build/libs/xxx.war
*   Context path
应用程序的context路径,以后访问应用程序时需要在主机之后加上context路径,除非部署到ROOT context
*   Container
选择tomcat 7.x
Manager user name 可以管理tomcat的账户名,比如上面设置的tomcat7
Manager password 管理账户密码,比如上面设置的tomcat7
Tomcat URL 访问tomcat的URL,比如http://domain.tld/

其实也可以通过脚本来直接部署war文件到tomcat的主机目录,让jenkins调用部署脚本就可以了。

**其他**
每个job还可以添加e-mail notification。

jenkins有几百个插件,可以做的事情很多很多,比如集成findbugs,checkstyle等,还需要以后慢慢探索。

**\===
\[erq\]**