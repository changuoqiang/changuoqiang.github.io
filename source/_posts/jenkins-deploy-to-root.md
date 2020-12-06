---
title: Jenkins自动部署war到tomcat根context
tags:
  - Debian
id: '6471'
categories:
  - - GNU/Linux
date: 2015-06-05 13:27:27
---


<!-- more -->
自动部署war包到ROOT路径，也就是网站的根目录时，deploy插件的"Context path"要填写："/",而不是"ROOT"或者"/ROOT",不然自动部署会失败，有类似以下错误：

```js
Build step 'Invoke Gradle script' changed build result to SUCCESS
Deploying /var/lib/jenkins/jobs/devel_auto_build_deploy/workspace/build/libs/reis.war to container Tomcat 7.x Remote
 \[/var/lib/jenkins/jobs/devel_auto_build_deploy/workspace/build/libs/reis.war\] is not deployed. Doing a fresh deployment.
 Deploying \[/var/lib/jenkins/jobs/devel_auto_build_deploy/workspace/build/libs/reis.war\]
ERROR: Build step failed with exception
org.codehaus.cargo.container.ContainerException: Failed to deploy \[/var/lib/jenkins/jobs/devel_auto_build_deploy/workspace/build/libs/reis.war\]
at org.codehaus.cargo.container.tomcat.internal.AbstractTomcatManagerDeployer.deploy(AbstractTomcatManagerDeployer.java:111)
at org.codehaus.cargo.container.tomcat.internal.AbstractTomcatManagerDeployer.redeploy(AbstractTomcatManagerDeployer.java:185)
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
at hudson.model.Run.execute(Run.java:1769)
at hudson.model.FreeStyleBuild.run(FreeStyleBuild.java:43)
at hudson.model.ResourceController.execute(ResourceController.java:98)
at hudson.model.Executor.run(Executor.java:374)
Caused by: java.io.IOException: Error writing request body to server
at sun.net.www.protocol.http.HttpURLConnection$StreamingOutputStream.checkError(HttpURLConnection.java:3478)
at sun.net.www.protocol.http.HttpURLConnection$StreamingOutputStream.write(HttpURLConnection.java:3461)
at java.io.BufferedOutputStream.flushBuffer(BufferedOutputStream.java:82)
at java.io.BufferedOutputStream.write(BufferedOutputStream.java:126)
at org.codehaus.cargo.container.tomcat.internal.TomcatManager.pipe(TomcatManager.java:647)
at org.codehaus.cargo.container.tomcat.internal.TomcatManager.invoke(TomcatManager.java:538)
at org.codehaus.cargo.container.tomcat.internal.TomcatManager.deployImpl(TomcatManager.java:611)
at org.codehaus.cargo.container.tomcat.internal.TomcatManager.deploy(TomcatManager.java:291)
at org.codehaus.cargo.container.tomcat.internal.AbstractTomcatManagerDeployer.deploy(AbstractTomcatManagerDeployer.java:102)
... 17 more
java.io.IOException: Error writing request body to server
at sun.net.www.protocol.http.HttpURLConnection$StreamingOutputStream.checkError(HttpURLConnection.java:3478)
at sun.net.www.protocol.http.HttpURLConnection$StreamingOutputStream.write(HttpURLConnection.java:3461)
at java.io.BufferedOutputStream.flushBuffer(BufferedOutputStream.java:82)
at java.io.BufferedOutputStream.write(BufferedOutputStream.java:126)
at org.codehaus.cargo.container.tomcat.internal.TomcatManager.pipe(TomcatManager.java:647)
at org.codehaus.cargo.container.tomcat.internal.TomcatManager.invoke(TomcatManager.java:538)
at org.codehaus.cargo.container.tomcat.internal.TomcatManager.deployImpl(TomcatManager.java:611)
at org.codehaus.cargo.container.tomcat.internal.TomcatManager.deploy(TomcatManager.java:291)
at org.codehaus.cargo.container.tomcat.internal.AbstractTomcatManagerDeployer.deploy(AbstractTomcatManagerDeployer.java:102)
at org.codehaus.cargo.container.tomcat.internal.AbstractTomcatManagerDeployer.redeploy(AbstractTomcatManagerDeployer.java:185)
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
at hudson.model.Run.execute(Run.java:1769)
at hudson.model.FreeStyleBuild.run(FreeStyleBuild.java:43)
at hudson.model.ResourceController.execute(ResourceController.java:98)
at hudson.model.Executor.run(Executor.java:374)
Build step 'Deploy war/ear to a container' marked build as failure
Finished: FAILURE
```