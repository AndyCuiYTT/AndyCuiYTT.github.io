---
title: iOS 开发之 CoreData
date: 2018-06-01 13:52:05
keywords:
    - CoreData
tags:
    - CoreData
categories:
    - iOS
    - 数据处理
---
## 简介
CoreData 是苹果公司封装的进行数据持久化的框架,首次在 iOS3.0版本的系统中出现,它允许按照实体-属性-值模型组织数据,并以 XML, 二进制文件或者 SQLite 数据文件格式持久化数据.
<!--more-->
## 优点
* CoreData 是苹果公司原生态的产品是在 iOS3.0版本系统出现,是苹果大力推广的技术之一,可以实现对 XML, 二进制文件和 SQLite 数据文件的访问.
* 可以节省代码量,一般要节省30%到70%的代码量.
* 支持可视化建模.
* CoreData 支持模型版本升级等.

## 创建工程
* 创建 CoreData 项目,记住选中 "Use Core Data".项目会自动创建出数据模型文件.
![](iOS 开发之 CoreData_1.png)  
* 创建出项目会发现多了 CoreDataDemo.xcdatamodeld 模型文件(可视化建模文件)
![](iOS 开发之 CoreData_2.png)

## 主要类
* NSManagedObjectContext: 被管理对象上下文(数据管理器).
* NSManagedObjectModel: 被管理对象(数据模型器).
* NSPersistentStoreCoordinator: 持久化存储助理(数据链接器).

## 创建模型
* 点击 "CoreDataDemo.xcdatamodeld" 文件,添加实体.
![](iOS 开发之 CoreData_3.png)  
* 这里我们需要创建Person和Card的实体以及实体属性:
![](iOS 开发之 CoreData_4.png)  
* 选中Person实体，在Person中添加card属性:
![](iOS 开发之 CoreData_5.png)  
* 选中Card实体，在Card中添加person属性:
![](iOS 开发之 CoreData_6.png)   
* 添加后模型对应关系:
![](iOS 开发之 CoreData_7.png) 

## 数据操作
* 获取上下文对象,在创建项目时, AppDelegate 提供了相应方法获取上下文.
```swift
var context: NSManagedObjectContext = {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    return appDelegate.persistentContainer.viewContext
}()
```
* 查询
```swift
@IBAction func selected(_ sender: UIButton) {
    
    let request = NSFetchRequest<NSFetchRequestResult>()
    request.entity = NSEntityDescription.entity(forEntityName: "Person", in: context)
    request.predicate = NSPredicate(format: "age=%@", "26")
    request.sortDescriptors = [NSSortDescriptor(key: "age", ascending: true)]
    do {
        let result = try context.fetch(request)
        if let person = result as? [Person] {
            for per in person {
                print("\(per.name) : \(per.age) ---- \(per.card?.no) : \(per.card?.name)")
            }
        }
        
    } catch  {
        print(error)
    }
}
```
* 添加
```swift
// 添加
@IBAction func insert(_ sender: UIButton) {
    
    let person = NSEntityDescription.insertNewObject(forEntityName: "Person", into: context)
    person.setValue(nameText.text, forKey: "name")
    person.setValue(Int(ageText.text!), forKey: "age")
    let card = NSEntityDescription.insertNewObject(forEntityName: "Card", into: context)
    card.setValue("123456", forKey: "no")
    card.setValue("学生卡", forKey: "name")
    person.setValue(card, forKey: "card")
    
    do {
       try context.save()
    }catch {
        print(error)
    }
}

```
* 修改
```swift
/// 修改数据
///
/// - 修改数据要查询出需要修改的数据,依次修改
@IBAction func update(_ sender: UIButton) {
    let request = NSFetchRequest<NSFetchRequestResult>()
    request.entity = NSEntityDescription.entity(forEntityName: "Person", in: context)
    request.predicate = NSPredicate(format: "age=%@", "26")
    do {
        let result = try context.fetch(request)
        if let person = result as? [Person] {
            for per in person {
                per.name = "Angelo"
                try context.save()
            }
        }
    } catch  {
        print(error)
    }
}
```
* 删除
```swift
/// 删除数据
///
/// - 删除数据需要先查询出要删除的数据,依次删除
@IBAction func deleter(_ sender: UIButton) {
    let request = NSFetchRequest<NSFetchRequestResult>()
    request.entity = NSEntityDescription.entity(forEntityName: "Person", in: context)
    request.predicate = NSPredicate(format: "age=%@", "26")
    do {
        let result = try context.fetch(request)
        if let person = result as? [Person] {
            for per in person {
                context.delete(per)
            }
        }
        
    } catch  {
        print(error)
    }
}
```

GitHub 地址:[https://github.com/AndyCuiYTT/CoreDataDemo](https://github.com/AndyCuiYTT/CoreDataDemo)
