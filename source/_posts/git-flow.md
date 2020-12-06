---
title: git私有小团队工作流程
tags:
  - Git
id: '5345'
categories:
  - - GNU/Linux
date: 2014-03-27 10:21:28
---

git的工作流程可以多种多样。
<!-- more -->
由于git分布式的天性,其工作流程可以灵活的随意变化。根据项目性质和团队大小可以有最适合的工作流程。
这里简单记录一下小团队私有项目的多人协作git工作流程,也是最简单的流程。

推荐的分支模型见[git分支策略模型](https://openwares.net/linux/git_brantch_model.html)

git工作流程:

1.  克隆仓库
    ```js
    $ git clone gitsvr:foobar
    ```
    
2.  如果不在devel分支,则切换到devel分支
    开发人员只能向devel分支推送更新,master只有管理员可以推送。
    
3.  创建以自己名字命名的个人私有分支
    ```js
    $ git checkout -b myname
    ```
    
4.  在私有分支上工作,做本地提交,当有成果要提交到devel分支时,先从上游拉取devel最新的成果
    然后将自己个人私有分支上的成果合并到devel,在解决可能存在的冲突后,将devel分支推送到服务器
    ```js
    $ git checkout devel
    $ git pull
    $ git merge --no-ff myname
    $ git push
    ```
    向devel合并自己分支的成果时要使用`--no-ff`选项,防止快速前进合并,使devel分支的提交历史保持干净。
    如果本地的devel分支已经在tracking远程的devel分支,则git pull/push命令都不用指名分支规范,可以使用下面的命令为本地分支设置跟踪的上游分支:
    ```js
    $ git branch --set-upstream devel origin/devel
    ```
    
5.  转到第4步

如果需要代码审核与持续集成,可以参考[Git+Gerrit+Gradle+Jenkins持续集成](https://openwares.net/linux/git_gerrit_gradle_jenkins_integration.html)

References:
\[1\][私有的小型团队](http://git-scm.com/book/zh/%E5%88%86%E5%B8%83%E5%BC%8F-Git-%E4%B8%BA%E9%A1%B9%E7%9B%AE%E4%BD%9C%E8%B4%A1%E7%8C%AE#私有的小型团队)
\[2\][多人协作](http://www.liaoxuefeng.com/wiki/0013739516305929606dd18361248578c67b8067c8c017b000/0013760174128707b935b0be6fc4fc6ace66c4f15618f8d000)

**\===
\[erq\]**