---
title: Carthage 安装以及初步实用
date: 2018-05-22 10:49:52
keywords:
 -Carthage
tags:
 -swift
 -cocoPods
categories:
 -开发工具
---
![Carthage](https://github.com/Carthage/Carthage/raw/master/Logo/PNG/header.png)

本人从事 iOS 开发已有2年多,用 swift 开发也有一年多的时间了,此前一直利用 cocopods 管理三方框架和依赖,最近了解到 Carthage 这个工具,本着学习的态度对这工具进行了了解.  

官方地址: [https://github.com/Carthage/Carthage](https://github.com/Carthage/Carthage)

<!--more-->
## Carthage 简介
* Carthage 类似于 CocoaPods，为用户管理第三方框架和依赖，但不会自动修改项目文件和生成配置
* Carthage 是去中心化的依赖管理工具，安装依赖时不需要去中心仓库获取 CocoaPods 所有依赖的索引，节省时间
* 对项目无侵入性，Carthage 设计上也比较简单，利用的都是 Xcode 自身的功能，开发者在创建依赖时，相比 CocoaPods 也简单许多
* Carthage 管理的依赖只需编译一次，项目干净编译时，不会再去重新编译依赖，节省时间
* 自动将第三方框架编程为 Dynamic framework( 动态库 )
与 CocoaPods 无缝集成，一个项目能同时拥有 CocoaPods 和 Carthage
* 缺点： 
 * 仅支持 iOS8 +
 * 它只支持框架，所以不能用来针对 iOS 8 以前的系统版本进行开发
支持的 Carthage 安装的第三方框架和依赖不如 CocoaPods 丰富
 * 无法在 Xcode 里定位到源码
 * 安装包的大小比用CocoaPods安装的包大

## 安装
> 使用 [Homebrew](https://brew.sh/) 安装 Carthage.

### 安装 Homebrew
* Install Homebrew:  
![Install Homebrew](Carthage_1.png)

* 获取 Homebrew 最新版本  
``$ brew update``

* Homebrew 常用命令
  * 搜索  
  ``$ brew search <packageName>``
  * 安装  
  ``$ brew install <packageName>``
  * 卸载  
  ``$ brew uninstall <packageName>``
  * 查看已安装包列表  
  ``$ brew list``
  * 查看包信息  
  ``$ brew info <packageName>``
  * 查看Homebrew版本  
  ``$ brew -v``
  
### 安装 Cartgage
* 安装  
``$ brew install carthage``
* 查看 Cartgage 版本  
``$ carthage version``
* 更新 carthage 版本  
``brew upgrade carthage``
* 删除carthage旧版本  
``brew cleanup carthage``

## 使用 Cartgage 安装依赖
* 进入项目所在路径  
``$ cd ~/路径/项目文件夹``  
* 创建空的 Carthage 文件 Cartfile 
``$ touch Cartfile``
* 使用 Xcode 打开 Cartfile 文件  
``$ open -a Xcode Cartfile``
* 编辑 Carfile 文件(以Alamofire为例)  
``github "Alamofire/Alamofire" == 4.4.0``
* 执行更新命令,获取类库  
``$ carthage update --platform iOS``
* 更新完成,检查目录结构  
``更新完成后项目根路径会多出两个文件(Cartfile.resolved,Cartfile)和一个文件夹(Carthage), Carthage下又有两个文件夹(Checkouts 和 Build), Checkouts 从github获取的源代码, Build 编译出来的Framework二进制代码库.``
![](Carthage_2.png)

## 添加 Frameworks 到项目中
* 点击'项目名' --> 'TARGETS' --> 'General', 在最下边找到'Linked Framework and Libraries'.  
![](Carthage_3.png)

* 点击'+' --> 'Add Other ..', 选择'Carthage/Build/iOS/Alamofire.framework',点击 'Open' 导入.  
![](Carthage_4.png)

* 选择菜单选项 'Build Phases' --> 点击 '+' --> 'New Run Script Phase', 添加以下命令:  
``/usr/local/bin/carthage copy-frameworks`` 
![](Carthage_5.png)

* 点击 'Input Files' 下的 '+',为每个 Framework 添加访问路径:  
``$(SRCROOT)/Carthage/Build/iOS/Alamofire.framework`` 
![](Carthage_6.png)

* 在项目中 import 所需包就可以使用了.  
``import Alamofire``







