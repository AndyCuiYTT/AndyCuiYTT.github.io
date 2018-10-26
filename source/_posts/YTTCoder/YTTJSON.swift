//
//  QWJSON.swift
//  AndyCuiYTT
//
//  Created by AndyCui on 2018/7/4.
//  Copyright © 2018年 AndyCuiYTT. All rights reserved.
//

import Foundation


// MARK: - 归档, model 转 json
extension Encodable {

    /// 当前对象转 JSON 字符串
    ///
    /// - Returns: JSON 字符串
    func toJSON() -> String? {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(self)
            if let jsonStr = String(data: jsonData, encoding: .utf8) {
                return jsonStr
            }
        } catch {
            return nil
        }
        return nil
    }
    
    
    /// model 转字典
    ///
    /// - Returns: 数据字典
    func toDictionary() -> Dictionary<String, Any>? {
        
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(self)
            let dic = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
            return dic as? Dictionary<String, Any>
        } catch {
            return nil
        }
    }
    
}


// MARK: - 反归档 json 转 model
extension Decodable {
    
    /// JSON 字符串转 Model
    ///
    /// - Parameters:
    ///   - json:  JSON 字符串
    /// - Returns: 当前转换后的对象
    static func deserializeFrom(json: String) -> Self? {
        if let jsonData = json.data(using: .utf8) {
            do {
                let object = try JSONDecoder().decode(Self.self, from: jsonData)
                return object
            } catch {
                print(error)
                return nil
            }
        }
        return nil
    }
    
    
    /// 字典转 Model
    ///
    /// - Parameter dictionary: 数据字典
    /// - Returns: 生成 model
    static func deserializeFrom(dictionary: Dictionary<String, Any>) -> Self? {
        do {
            let infoData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            let object = try JSONDecoder().decode(Self.self, from: infoData)
            return object
        } catch {
            return nil
        }
    }
    
    
}
// Decodable & Encodable



extension Array where Element: Encodable {
    
   
    
    /// 当前对象转 JSON 字符串
    ///
    /// - Returns: JSON 字符串
    func toJSON() -> String? {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(self)
            if let jsonStr = String(data: jsonData, encoding: .utf8) {
                return jsonStr
            }
        } catch {
            return nil
        }
        return nil
    }
    
    
    /// model 数组转字典数组
    ///
    /// - Returns: 字典数组
    func toArray() -> Array? {
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(self)
            let dic = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
            return dic as? Array
        } catch {
            return nil
        }
    }
    
}

extension Array where Element: Decodable {
    
    static func deserializeFrom(json: String) -> Array? {
        if let jsonData = json.data(using: .utf8) {
            do {
                let obj = try JSONDecoder().decode(self, from: jsonData)
                return obj
            } catch {
                return nil
            }
        }
        return nil
    }
    
    /// 字典数组转 model 数组
    ///
    /// - Parameter array: item 为字典数据
    /// - Returns: item 为 model 数组
    static func deserializeFrom(array: Array<Dictionary<String, Any>>) -> Array? {
        do {
            let infoData = try JSONSerialization.data(withJSONObject: array, options: .prettyPrinted)
            let obj = try JSONDecoder().decode(self, from: infoData)
            return obj
        } catch {
            return nil
        }
    }
}

extension KeyedDecodingContainer {
    
    public func decodeIfPresent<T>(_ type: T.Type, forKey key: K) throws -> T? where T : Decodable {
        if let value = try? decode(type, forKey: key) {
            return value
        }
        return nil
    }
    
}
