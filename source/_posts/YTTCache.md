---
title: YTTCache
date: 2018-08-27 11:00:26
keywords:
- cache
- sqlite
- SQLite.swift
tags:
- 持久化
- 三方库
categories:
- iOS
- 组件库
---
![GitHub release](https://img.shields.io/github/release/AndyCuiYTT/YTTCache.svg?style=plastic)
iOS 开发中经常会用到本地存储,加之最近在了解组件化,所以对本地存储这块做了组件化处理,且在完善中...
<!-- more -->
## [YTTCache](https://github.com/AndyCuiYTT/YTTCache)
使用 SQLite3 对数据进行存储,采用键值对形式存储数据.
使用 [SQLite.swift](https://github.com/AndyCuiYTT/SQLite.swift) 进行数据库操作.

## Installation
YTTCache  可以通过 [CocoaPods](https://cocoapods.org) 安装. 只需要在你的 Podfile 添加:
```ruby
pod 'YTTCache'
```

## Usage
### Cache for String
```swift 
import YTTCache

// 缓存数据
YTTCache.storeString("value", key: "key")
// 刷新缓存数据
YTTCache.updateStoreString("new value", key: "key")
// 获取缓存数据
YTTCache.stringForKey("key")
// 删除缓存数据
YTTCache.removeCacheForKey("key")
// 清空缓存
YTTCache.cleanCache()

```
### Cache For Request
```swift
import YTTCache

/// 缓存请求结果 JSON 数据
///
/// - Parameters:
///   - jsonStr: JSON 字符串
///   - url: 请求 URL 地址
///   - param: 请求参数
/// - Returns: 是否缓存成功
YTTRequestCache.storeJSONString("{/"name/":/"AndyCui/",/"email/":/"AndyCuiYTT@163.com/"}", url: "https:****", param: ["username":"AndyCui"])

/// 获取缓存 JSON 数据
///
/// - Parameters:
///   - url: 请求 URL 地址
///   - param: 请求参数
///   - timeoutIntervalForCache: 缓存时间(以秒为单位),默认永久
/// - Returns: 缓存 JSON 字符串,没有返回 nil
YTTRequestCache.JSONStringForKey(url: "https:****", param: ["username":"AndyCui"], timeoutIntervalForCache: 24 * 60 * 60)

/// 删除某条 JSON 数据
///
/// - Parameters:
///   - url: 请求 URL 地址
///   - param: 请求参数
/// - Returns: 是否删除成功
YTTRequestCache.removeJSONStringForKey(url: "https:****", param: ["username":"AndyCui"])

```

