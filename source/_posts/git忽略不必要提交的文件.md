---
title: Git 忽略不必要提交的文件
date: 2018-08-09 09:15:29
keywords:
- git
- git 文件忽略
- .gitignore
- xcode 忽略 git 文件
tags:
- git
- 版本控制
categories:
- 版本控制
- Git
---
在开发中版本控制是开发人员必不可少的,现在常用的版本控制主要是 git/svn.在实际开发过程中会产生一些中间文件或者项目中有些文件是不需要进行版本管理的,我们可以通过设置 .gitignore 文件忽略这些文件.
<!-- more -->
## 创建 .gitignore 文件
 > 指定不需要提交的文件需要在版本管理根目录下创建 .gitignore (gitignore是隐藏文件，所以前面有个点), 与 .git 同级  

* 进入版本管理文件夹: cd /Users/\*\*/\*\*/**
* 创建 .gitignore 文件: touch .gitignore
* 编辑 .gitignore 文件: vim .gitignore

## 编辑 .gitignore 文件
### 忽略规则： 
* ’#’是注释，将被git忽略。 
* 可以使用Linux通配符。 
* 如果名称的最前面有一个感叹号(!)，表示例外规则，将不被忽略 
* 如果名称的最前面有一个路径分隔符（/）,表示将忽略的文件在此目录下，而子目录中的文件不忽略 
* 如果名称的最后面有一个路径分隔符（/）,表示要忽略的是此目录下该名称的子目录，而非文件（默认文件或目录都忽略）  
 
**[gitignore 配置例子](https://github.com/github/gitignore)**

```
# Xcode
#
# gitignore contributors: remember to update Global/Xcode.gitignore, Objective-C.gitignore & Swift.gitignore

## Build generated
build/
DerivedData/

## Various settings
*.pbxuser
!default.pbxuser
*.mode1v3
!default.mode1v3
*.mode2v3
!default.mode2v3
*.perspectivev3
!default.perspectivev3
xcuserdata/

## Other
*.moved-aside
*.xccheckout
*.xcscmblueprint


## Obj-C/Swift specific
*.hmap
*.ipa
*.dSYM.zip
*.dSYM

# CocoaPods
#
# We recommend against adding the Pods directory to your .gitignore. However
# you should judge for yourself, the pros and cons are mentioned at:
# https://guides.cocoapods.org/using/using-cocoapods.html#should-i-check-the-pods-directory-into-source-control

Pods/

# Carthage
#
# Add this line if you want to avoid checking in source code from Carthage dependencies.

# Carthage/Checkouts
Carthage/Build

# fastlane
#
# It is recommended to not store the screenshots in the git repo. Instead, use fastlane to re-generate the
# screenshots whenever they are needed.
# For more information about the recommended setup visit:
# https://docs.fastlane.tools/best-practices/source-control/#source-control

fastlane/report.xml
fastlane/Preview.html
fastlane/screenshots
fastlane/test_output

# Code Injection
#
# After new code Injection tools there's a generated folder /iOSInjectionProject
# https://github.com/johnno1962/injectionforxcode

iOSInjectionProject/

# fastlane
fastlane
```
