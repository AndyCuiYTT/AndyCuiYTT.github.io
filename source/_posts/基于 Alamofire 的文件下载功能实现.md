---
title: 基于 Alamofire 的文件下载功能实现
date: 2019-07-16 09:08:57
keywords:
- 文件下载
- Alamofire
- 断点下载
tags:
- Alamofire
- 下载
categories:
- iOS
- 网络
description: 项目需求需要添加文件下载功能,项目网络请求基于 Alamofire ,对 Alamofire 下载功能进行了整理.
---
### 实现下载的流程
```flow
st=>start: 开始
e=>end: 结束
input=>inputoutput: 输入下载地址,参数
rePath=>operation: 返回文件保存路径
checkPath=>condition: 是否存在文件
checkResumeData=>condition: 是否存在下载记录文件
resumDownload=>operation: 继续下载
newDownload=>operation: 开始下载
checkDownload=>condition: 是否下载成功
saveResumData=>operation: 保存下载信息

st->input->checkPath
checkPath(yes,right)->rePath->e
checkPath(no)->checkResumeData
checkResumeData(yes,right)->resumDownload->checkDownload
checkResumeData(no)->newDownload->checkDownload
checkDownload(yes)->rePath->e
checkDownload(no,right)->saveResumData->e
```
### 实现方法
查看 [CXGDownloadTools.swift](CXGDownloadTools.zip)
