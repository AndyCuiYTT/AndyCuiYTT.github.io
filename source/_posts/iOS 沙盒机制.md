---
title: iOS 沙盒机制
date: 2018-05-31 15:02:15
tags:
- iOS
categories:
- iOS
---
iOS 每个 APP 都有自己的存储空间,这个存储空间叫做沙盒. APP可以在自己的沙盒中进行数据存取操作,但不能访问其他 app 的沙盒空间.对 app 做一些数据存储或者文件缓存时,一般都保存在沙盒中.
<!--more-->
# 沙盒机制简介
## 目录结构
沙盒机制根据访问权限和功能区别分为不同的目录: document,library,temp,.app, library又包含 caches 和preferences.
* document: 保存应用运行时生成的需要持久化的数据iTunes会自动备份该目录。苹果建议将在应用程序中浏览到的文件数据保存在该目录下.
* library: 这个目录下有两个目录  
> * caches: 一般存储的是缓存文件，例如图片视频等，此目录下的文件不会再应用程序退出时删除，在手机备份的时候，iTunes不会备份该目录。  
> * preferences: 保存应用程序的所有偏好设置iOS的Settings(设置)，我们不应该直接在这里创建文件，而是需要通过NSUserDefault这个类来访问应用程序的偏好设置。iTunes会自动备份该文件目录下的内容.
 
* temp: 临时文件目录，在程序重新运行的时候，和开机的时候，会清空tmp文件夹。
* .app: 这个就是可运行的应用文件，带有签名的文件包，包含应用程序代码和静态数据.  

## 特点
* 每个应用程序都在自己的沙盒内.
* 不能随意跨越自己的沙盒去访问别的应用程序沙盒的内容.
* 应用程序向外请求或接收数据都需要经过权限认证.

# 沙盒操作
## 获取沙盒路径
## 获取沙盒根路径
```swift
let homePath = NSHomeDirectory()
```
### 获取 document 路径
```swift
let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
```
### 获取 library 路径
```swift
let libraryPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
```
### 获取 cache 路径
```swift
let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
```
### 获取 preferences 路径
由系统维护,不需要我们手动获取文件目录.可借助 UserDefault 维护
### 获取 tmp 路径
```swift
let tmpPath = NSTemporaryDirectory()
```
### 获取程序目录和内容
* 获取程序包路径  
``
let path = Bundle.main.resourcePath
``
* 获取图片资源路径  
``
let imagePath = Bundle.main.path(forResource: "temp", ofType: "png")
``

## 文件管理
iOS 对文件进行管理需要用到文件管理器: FileManager.
### 检测文件是否存在
``
FileManager.default.fileExists(atPath: filePath)
``
### 创建文件路径
``
FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
``
### 创建文件
``
FileManager.default.createFile(atPath: path, contents: data, attributes: nil)
``
### 文件删除
``
FileManager.default.removeItem(atPath: path)
``
### 文件移动
``
FileManager.default.moveItem(atPath: oldPath, toPath: newPath)
``
### 文件复制
``
FileManager.default.copyItem(atPath: oldPath, toPath: newPath)
``
### 获取文件属性
``
FileManager.default.attributesOfItem(atPath: filePath)
``
