---
title: Keychain的介绍和使用
date: 2019-06-03 09:50:26
keywords:
-  keychain
- 密码保存
- UUID
tags:
-  keychain
categories:
- iOS
- 数据处理
description: Keychain 里保存的信息不会因App被删除而丢失，在用户重新安装App后依然有效。
---
### 什么是 Keychain?
> iOS 的 keychain 服务提供了一种安全的保存私密信息（密码，序列号，证书等）的方式，每个ios程序都有一个独立的keychain存储。  
> 用于储存一些私密信息，比如密码、证书等等，Keychain里保存的信息不会因App被删除而丢失，在用户重新安装App后依然有效。  
> 同样也适用于应用之间数据共享。我们可以把KeyChain理解为一个Dictionary，所有数据都以key-value的形式存储，可以对这个Dictionary进行add、update、get、delete这四个操作。

### keychain 的四个方法介绍?
#### 存储方法
```
OSStatus SecItemAdd(CFDictionaryRef attributes, CFTypeRef * __nullable CF_RETURNS_RETAINED result)
```
attributes: 要添加的数据  
result: 存储数据后,返回一个指向该数据的引用,不使用该数据传入 nil

#### 条件查询方法
```
OSStatus SecItemCopyMatching(CFDictionaryRef query, CFTypeRef * __nullable CF_RETURNS_RETAINED result)
```
query: 要查询数据的条件  
result: 查询到数据的引用

#### 数据更新方法
```
OSStatus SecItemUpdate(CFDictionaryRef query, CFDictionaryRef attributesToUpdate)
```
query: 要更新数据的查询条件  
attributesToUpdate: 要更新的数据

#### 删除数据方法
```
OSStatus SecItemDelete(CFDictionaryRef query)
```
query: 要删除数据的查询条件

### 使用 Keychain
> 使用 Keychain 首先需要导入安全框架 secutity.framework

#### 创建查询条件
```swift
class func createQuaryMutableDictionary(identifier: String)->NSMutableDictionary{
    // 创建一个条件字典
    let keychainQuaryMutableDictionary = NSMutableDictionary.init(capacity: 0)
    // 设置条件存储的类型
    keychainQuaryMutableDictionary.setValue(kSecClassGenericPassword, forKey: kSecClass as String)
    // 设置存储数据的标记
    keychainQuaryMutableDictionary.setValue(identifier, forKey: kSecAttrService as String)
    keychainQuaryMutableDictionary.setValue(identifier, forKey: kSecAttrAccount as String)
    // 设置数据访问属性
    keychainQuaryMutableDictionary.setValue(kSecAttrAccessibleAfterFirstUnlock, forKey: kSecAttrAccessible as String)
    // 返回创建条件字典
    return keychainQuaryMutableDictionary
}
```

#### 存储数据
```swift
class func keyChainSaveData(data: Any ,withIdentifier identifier:String)-> Bool {
    // 获取存储数据的条件
    let keyChainSaveMutableDictionary = self.createQuaryMutableDictionary(identifier: identifier)
    // 删除旧的存储数据
    SecItemDelete(keyChainSaveMutableDictionary)
    // 设置数据
    keyChainSaveMutableDictionary.setValue(NSKeyedArchiver.archivedData(withRootObject: data), forKey: kSecValueData as String)
    // 进行存储数据
    let saveState = SecItemAdd(keyChainSaveMutableDictionary, nil)
    if saveState == noErr  {
        return true
    }
    return false
}
```
#### 更新数据
```swift
class func keyChainUpdata(data: Any ,withIdentifier identifier:String)->Bool {
    // 获取更新的条件
    let keyChainUpdataMutableDictionary = self.createQuaryMutableDictionary(identifier: identifier)
    // 创建数据存储字典
    let updataMutableDictionary = NSMutableDictionary.init(capacity: 0)
    // 设置数据
    updataMutableDictionary.setValue(NSKeyedArchiver.archivedData(withRootObject: data), forKey: kSecValueData as String)
    // 更新数据
    let updataStatus = SecItemUpdate(keyChainUpdataMutableDictionary, updataMutableDictionary)
    if updataStatus == noErr {
        return true
    }
    return false
}
```
#### 查询数据
```swift
class func keyChainReadData(identifier: String)-> Any {
    var idObject:Any?
    // 获取查询条件
    let keyChainReadmutableDictionary = self.createQuaryMutableDictionary(identifier: identifier)
    // 提供查询数据的两个必要参数
    keyChainReadmutableDictionary.setValue(kCFBooleanTrue, forKey: kSecReturnData as String)
    keyChainReadmutableDictionary.setValue(kSecMatchLimitOne, forKey: kSecMatchLimit as String)
    // 创建获取数据的引用
    var queryResult: AnyObject?
    // 通过查询是否存储在数据
    let readStatus = withUnsafeMutablePointer(to: &queryResult) { SecItemCopyMatching(keyChainReadmutableDictionary, UnsafeMutablePointer($0))}
    if readStatus == errSecSuccess {
    if let data = queryResult as! NSData? {
        idObject = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as Any
    }
    }
    return idObject as Any
}
```
#### 删除数据
```swift
class func keyChianDelete(identifier: String)->Void{
    // 获取删除的条件
    let keyChainDeleteMutableDictionary = self.createQuaryMutableDictionary(identifier: identifier)
    // 删除数据
    SecItemDelete(keyChainDeleteMutableDictionary)
}
```

### 简单应用
#### 获取 UUID
> 直接获取 UUID 每次卸载重新安装 app 后可能会导致 UUID 变化,为了获取唯一的 UUID,我们使用 keyChian 对 UUID 进行保存
```swift
class func getUUID() -> String {
    if let uuid = QWUUIDTools.keyChainReadData(identifier: "key") as? String {
        return uuid
    }else {
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            if QWUUIDTools.keyChainSaveData(data: uuid, withIdentifier: "key") {
                return uuid
            }
        }
    }
    return "simulator"
}
```

