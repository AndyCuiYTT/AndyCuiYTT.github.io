---
title: swift JSON 与 Model转换
date: 2018-01-24 10:17:18
keywords:
    - Coder
    - Codable
    - Encodable
    - Decodable
tags:
    - 数据处理
categories:
    - iOS
    - 数据处理
---
最近工作之余对开发中用到的数据解析相关进行了整理,整合了开发中常用到的数据解析,并将其封装成模块.(持续完善中)

<!-- more -->

 [![](https://img.shields.io/badge/blog-AndyCuiの博客-yellowgreen.svg)](http://CuiXg.top)
 ### Codable+CXG 通过对Codable添加扩展实现数据转换
 ‘’‘swift
 // MARK: - 归档, model 转 json
 extension Encodable {
     
     /// 当前对象转 JSON 字符串
     ///
     /// - Returns: JSON 字符串
     func cxg_toJSON() -> String?
     
     
     /// model 转字典
     ///
     /// - Returns: 数据字典
     func cxg_toDictionary() -> Dictionary<String, Any>? 
}
 
 // MARK: - 反归档 json 转 model
 extension Decodable {
 
     /// JSON 字符串转 Model
     ///
     /// - Parameters:
     ///   - json:  JSON 字符串
     /// - Returns: 当前转换后的对象
     static func cxg_deserializeFrom(json: String) -> Self? 
     
     
     /// 字典转 Model
     ///
     /// - Parameter dictionary: 数据字典
     /// - Returns: 生成 model
     static func cxg_deserializeFrom(dictionary: Dictionary<String, Any>) -> Self?
 }

 // Decodable & Encodable
 extension Array where Element: Encodable {

     /// 当前对象转 JSON 字符串
     ///
     /// - Returns: JSON 字符串
     func cxg_toJSON() -> String? 
     
     /// model 数组转字典数组
     ///
     /// - Returns: 字典数组
     func cxg_toArray() -> Array?
 }
 
 extension Array where Element: Decodable {
 
     static func cxg_deserializeFrom(json: String) -> Array?
     
     /// 字典数组转 model 数组
     ///
     /// - Parameter array: item 为字典数据
     /// - Returns: item 为 model 数组
     static func cxg_deserializeFrom(array: Array<Dictionary<String, Any>>) -> Array? 
 }
 
 // 数据过滤
 extension KeyedDecodingContainer {

     public func decodeIfPresent<T>(_ type: T.Type, forKey key: K) throws -> T? where T : Decodable {
         if let value = try? decode(type, forKey: key) {
         return value
     }
         return nil
     }
 
 }

 ···

[项目开发用到的解析文件](Codable+CXG.swift)

#### 反馈
如果您有什么好的修改建议,可以发邮件到[AndyCuiYTT@163.com](mailto://AndyCuiYTT@163.com), 也欢迎到我的博客[AndyCuiの博客](http://CuiXg.top)一起讨论学习~
