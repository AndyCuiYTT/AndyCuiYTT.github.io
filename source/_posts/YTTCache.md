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
- 数据处理
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
采用 SQLite3 进行存储,表格有5个字段: id, cache_data, cache_key, cache_time, cache_data_MD5.
* id: 数据唯一标识.
* cache_data: 需要缓存数据,采用 Data 数据类型,对应数据库 Blob 类型.
* cache_key: 数据对应的 key, 对字符串 MD5 的值.
* cache_time: 添加/修改数据的时间(时间戳).
* cache_data_MD5: 缓存数据的 MD5 值,查询时校验使用.


### YTTDataBase
> 基础类,通过 SQLite.swift 对数据库进行操作,实现了添加,修改,查询,删除操作.

### YTTCache
> 缓存操作的主要操作类,实现了添加,修改,查询,删除操作(主要针对 String 与 Data).

```swift 
public class YTTCache

/// 缓存数据
///
/// - Parameters:
///   - value: 字符串
///   - key: 键值
/// - Returns: 是否缓存成功
public class func storeString(_ value: String, key: String) -> Bool 


/// 缓存数据
///
/// - Parameters:
///   - value: Data
///   - key: 键值
/// - Returns: 是否缓存成功
public class func storeData(_ value: Data, key: String) -> Bool 


/// 更新缓存数据
///
/// - Parameters:
///   - value: 字符串
///   - key: 键值
/// - Returns: 是否更新成功
public class func updateStoreString(_ value: String, key: String) -> Bool 


/// 更新缓存数据
///
/// - Parameters:
///   - value: data
///   - key: 键值
/// - Returns: 是否更新成功
public class func updateStoreData(_ value: Data, key: String) -> Bool 


/// 获取缓存信息
///
/// - Parameter key: 键值
/// - Returns: 获取到的 Data
public class func dataForKey(_ key: String, timeoutIntervalForCache interval: TimeInterval = .greatestFiniteMagnitude) -> Data? 


/// 获取缓存信息
///
/// - Parameter key: 键值
/// - Returns: 获取到的字符串
public class func stringForKey(_ key: String, timeoutIntervalForCache interval: TimeInterval = .greatestFiniteMagnitude) -> String? 


/// 清除某条数据
///
/// - Parameter key: 键值
/// - Returns: 是否清除成功
public class func removeCacheByKey(_ key: String) -> Bool 


/// 清除缓存
///
/// - Returns: 是否清除成功
public class func cleanCache() -> Bool 

```
### YTTRequestCache
> 基于 YTTCache 实现,缓存数据为 JSON 字符串, key 值通过 url 与参数生成.

```swift
public class YTTRequestCache

/// 缓存请求结果 JSON 数据
///
/// - Parameters:
///   - jsonStr: JSON 字符串
///   - url: 请求 URL 地址
///   - param: 请求参数
/// - Returns: 是否缓存成功
public class func storeJSONString(_ jsonStr: String, url: String, param: [String: Any]) -> Bool 


/// 获取缓存 JSON 数据
///
/// - Parameters:
///   - url: 请求 URL 地址
///   - param: 请求参数
///   - timeoutIntervalForCache: 缓存时间(以秒为单位),默认永久
/// - Returns: 缓存 JSON 字符串,没有返回 nil
public class func JSONStringForKey(url: String, param: [String: Any], timeoutIntervalForCache interval: TimeInterval = .greatestFiniteMagnitude) -> String? 


/// 删除某条 JSON 数据
///
/// - Parameters:
///   - url: 请求 URL 地址
///   - param: 请求参数
/// - Returns: 是否删除成功
public class func removeJSONStringForKey(url: String, param: [String: Any]) -> Bool 

```

### Extension
> 对常用一些类进行扩展,方便数据缓存操作.(eg: 取: String.initWithCache("students") 保存: "students".cache.storeWithKey("students"))  

#### StringExtension
#### UIImageExtension
#### DictionaryExtension
#### ArrayExtension

