---
title: wordpress站点更换域名
tags: []
id: '785'
categories:
  - - Misc
date: 2010-04-02 14:26:23
---

主要是修改wp_options表里面的siteurl和home选项以及wp_posts的post_content和guid字段。

update wp_options set option_value=replace(option_value,'http://old_domain_name','http://new_domain_name');

update wp_posts set post_content=replace(post_content,'http://old_domain_name','http://new_domain_name');

update wp_posts set guid=replace(guid,'http://old_domain_name','http://new_domain_name');