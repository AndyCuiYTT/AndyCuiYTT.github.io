---
title: iOS 总结
date: 2018-06-21 08:34:35
keywords:
- iOS
- swift
- Object-c
- category
tags:
- iOS
- Other
categories:
- iOS
---
iOS是由苹果公司开发的移动操作系统.
<!--more-->
# iOS 简介
## 开发语言
### Object-C
* 通常写作ObjC或OC和较少用的Objective C或Obj-C，是扩充C的面向对象编程语言。OC 完全兼容 C语言.
* 面向对象语言(C 语言面向过程).
* 是MAC OSX和IOS开发的基础语言。

### Swift
* 苹果于2014年WWDC（苹果开发者大会）发布的新开发语言，可与Objective-C*共同运行于Mac OS和iOS平台，用于搭建基于苹果平台的应用程序.
* Swift和Objective-C共用一套运行时环境,项目中可以通过桥接的方式互相调用.


## 开发工具
* Xcode: 运行在操作系统Mac OS X上的集成开发工具（IDE），由苹果公司开发。


# iOS 基础

## APP 生命周期
iOS 应用有5中状态:
* Not running 应用还没启动或正在运行但是中途被系统停止
* Inactive 应用正在前台运行(不接收事件)
* Active 应用正在前台运行(接收事件)
* Background 应用处于后台运行(还在执行代码)
* Suspended 应用处于后台运行(停止执行代码)
对应的函数:
```swift
//应用将要进入非活动调用   (不接受消息或事件)
- (void)applicationWillResignActive:(UIApplication *)application;
//应用进入活动调用        (接收消息或事件)
- (void)applicationDidBecomeActive:(UIApplication *)application;
//应用进入后台调用        (设置后台继续运行)
- (void)applicationDidEnterBackground:(UIApplication *)application;
//应用将要进入前台调用
- (void)applicationWillEnterForeground:(UIApplication *)application;
//应用将要退出调用        (保存数据,退出前清理)
- (void)applicationWillTerminate:(UIApplication *)application;
//应用被终止前调用        (内存清理,方式应用被终止)
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application;
//应用载入后调用
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
//应用打开URL时调用
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url;
```

## 内存管理机制(引用计数)
### 简介
OC 引入引用计数机制来跟踪并管理对象的生命周期.
iOS 5之前采用 MRC(手动内存管理) 管理内存.需用开发人员手动调用reatain,release等方法.  
iOS 5之后采用 ARC(自动内存管理) 管理内存,不用开发人员去关心引用计数的变化.

|操作|对应 OC 方法|引用计数变化|
|:-:|:-:|---|
|创建对象|alloc,new 等|生成对象,引用计数设置为 1|
|持有对象|reatain|引用计数 +1|
|释放对象|release|引用计数 -1|
|废弃对象|dealloc|引用计数为0,释放内存|

alloc 与 dealloc,reatain与 release 成对存在, **谁创建谁释放，谁retain谁释放**  
只有当引用计数为 0 是对象才会销毁回收内存.

### 工作原理

* 当我们创建(alloc)一个新对象A的时候，它的引用计数从零变为 1.
* 当有一个指针指向这个对象A，也就是某对象想通过引用保留(retain)该对象A时，引用计数加 1.
* 当某个指针/对象不再指向这个对象A，也就是释放(release)该引用后，我们将其引用计数减 1.
* 当对象A的引用计数变为 0 时，说明这个对象不再被任何指针指向(引用)了，这个时候我们就可以将对象A销毁，所占内存将被回收，且所有指向该对象的引用也都变得无效了。系统也会将其占用的内存标记为“可重用”(reuse).

## 属性
### 声明
``
@property(nonatomic, strong)UITextField *textField;
``  
OC 采用 '@property' 声明对象, 会默认生成一个 '_textField' 成员变量与与之对应的 'setter/getter' 方法.
### 属性修饰符
|修饰符|描述|引用计数变化|
|:-:|:-:|:-:|
|copy|复制,创建一个新对象,通常修饰 NSString,NSArray,NSDictionary,NSSet|新对象引用计数为 1,旧对象不变|
|retain|释放旧对象,主要用于(MRC)|释放旧对象,计数 -1,新对象 retain, 计数 +1|
|strong|强引用,与 retain相似|释放旧对象,计数 -1,新对象 retain, 计数 +1|
|assign|修饰基本数据类型|不变|
|weak|与assign类似,修饰对象,对消销毁后自动变成 nil,主要用于修饰 delegate|不变|
|readwrite|可读写,生成 setter 与 getter 方法|-|
|readonly|只读,只为属性生成 getter 方法|-|
|nonatomic|非原子属性,不为 setter 方式加锁,非线程安全,通常采用这种,执行效率高|-|
|atomic|原子属性,为 setter 方式加锁,线程安全|-|

### 注意问题
* 对 block 修饰 Strong,copy 都可以,建议使用 copy. block 声明默认为栈变量,为了能够在block的声明域外使用，所以要把block拷贝（copy）到堆，所以说为了block属性声明和实际的操作一致，最好声明为copy。
* NSString,NSArray,NSDictionary,NSSet 建议使用 copy. 当将 NSMutableString 赋值给 NSString 时, strong 修饰只会进行浅拷贝(引用计数 +1),NSMutableString与NSString 指向同一内存空间,NSMutableString修改时NSString会随之改变. copy 修饰深拷贝(复制内存单元),NSMutableString与NSString 指向不同内存空间,NSMutableString修改时NSString不会改变.
* \_\_weak \_\_Strong \_\_block 在 block 使用时有时为了避免造成循环引用会用 \_\_weak \_\_Strong 进行修饰下. 有时在 block 中,为了避免对象过早释放用 \_\_Strong 修饰.

## 数据持久化
* 读写文件: 比较复杂,对对象保存需要进行归档反归档处理.
* 云端存储: 需要后台配合.
* 本地数据库(SQLite,[CoreDate](http://andycui.top/2018/06/01/iOS%20%E5%BC%80%E5%8F%91%E4%B9%8B%20CoreData/)): CoreDate 是 iOS5 之后出现的,实质是对 SQLite 的封装.
* NSUserDefaults: 系统自带的持久化类,进行简单数据存储(用户登录信息等).

## 类继承关系(单继承)
iOS 所有的类都继承与 NSObject, 主要分为 UI 和 NS 两大类. UI 主要为视图, NS 为数据操作.
图解:
![UI 系](iOS 总结_1.png)
![UI 系](iOS 总结_2.png)

其他:
UIViewController 生命周期: 初始化 --> loadView --> viewDidLoad --> viewWillAppear --> viewWillLayoutSubviews --> viewDidLayoutSubviews --> viewDidAppear --> viewWillDisappear --> viewDidDisappear --> dealloc 


## 传值
* 属性传值
* block 传值
* 代理传值
* 通知传值
* 单例传值
* 持久化传值

## 协议与代理
在iOS开发中，Protocol是一种经常用到的设计模式，苹果的系统框架中也普遍用到了这种方式,比如UITableView中的<UITableViewDelegate>.
协议声明:
```swift
#import <Foundation/Foundation.h>

@protocol ProtocolDelegate <NSObject>

// 必须实现方法
@required
- (NSString*)getName;

// 可选方法
@optional
- (NSString*)getAge;

@end
```
协议使用
* 协议是一系列标准的方法列表，可以被任何类实现.
* 协议中不能声明成员变量，只要一个类遵守了这个协议，也相当于拥有了该协议中所有方法的声明.
* 父类遵守了该协议，那么它的子类也就都遵守该协议,可以遵守多个协议.

代理: 当前类(委托者)将一些操作委托给另一个类(代理)去完成.
委托者需要做的事：
* 创建协议（也就是代理要实现的方法）
* 声明委托变量
* 设置代理（也可以在代理中设置）
* 利用委托变量来调用协议方法（也就是让代理者开始执行协议）
代理需要做的事：
* 遵循协议
* 实现协议方法



## 数据请求

# iOS 中级
## 响应者链
* 响应对象: 继承自UIResponder的对象称之为响应者对象.
* 响应事件: 触摸事件、点按事件(长按,多次点击,轻点等)、加速事件和远程控制.
* 响应者链: 由多个响应者组合起来的链条

### 事件产生与传递
* 发生触摸事件后，系统会将该事件加入到一个由UIApplication管理的事件队列中.
* UIApplication会从事件队列中取出最前面的事件，并将事件分发下去以便处理，通常，先发送事件给应用程序的主窗口（keyWindow).
* 主窗口会在视图层次结构中找到一个最合适的视图来处理触摸事件，这也是整个事件处理过程的第一步.
* 找到合适的视图控件后，就会调用视图控件的touches方法来作具体的事件处理.
* 如果调用了[super touches….];就会将事件顺着响应者链条往上传递，传递给上一个响应者，调用上一个响应者的touches….方法
**注意:** 如果父控件不能接受触摸事件，那么子控件就不可能接收到触摸事件
![UI 系](iOS 总结_3.png)

### 事件响应
* 如果视图不响应事件，则将其传递给它的父视图
* 在最顶级的视图层次结构中，如果都不能处理收到的事件或消息，则其将事件或消息传递给UIWindow对象进行处理
* 如果UIWindow对象也不处理，则其将事件或消息传递给UIApplication对象处理
* 如果UIApplication也不能处理该事件或消息，则将该事件丢弃
如何判断上一个响应者
    * 如果当前这个view不是控制器的view, 那么它的父控件就是上一个响应者
    * 如果当前这个view是控制器的view, 那么控制器就是上一个响应者

### UIView不能接收触摸事件的情况
* 不允许交互: userInteractionEnabled = NO(eg: UIImageView)
* 隐藏
* 透明度: 透明度<0.01
* 子视图超出了父视图区域
* 当前 View 被遮挡

## 分类(category)与类扩展(extension)
### 分类
* 在不改变原类的基础上为一个类扩展方法.
* 主要用法为系统类扩展方法
* 不可添加成员变量. 如果要添加成员变量需要自己实现 setter 和 getter 方法(runtime).
* 分类文件(.h,.m),以为 Person 添加分类为例,可以通过 Person 实例对象直接调用 playFootBall 方法(分类方法执行优先级高于本类).

Person+sport.h
```swift
#import "Person.h"

@interface Person (sport)

- (void)playFootBall;

@end

```
Person+sport.m
```swift
#import "Person+sport.h"

@implementation Person (sport)

- (void)playFootBall {
    NSLog(@"playFootBall");
}

@end

```
### 类扩展
类扩展是分类的一个特例,为一个类添加一些私有成员变量和方法(常用).
类扩展定义的方法，须在类的implement 中实现
类扩展可以定义属性
声明:
```swift
#import "Person.h"

@interface Person ()
- (void)say;
@end
```
### 分类与继承
iOS 中分类(Categories) 和 继承(Inherit)有相同的功能，但在一些细节上又有差异，如何选择。
使用继承:
* 扩展方法与原方法名相同,还需要使用父类方法.
* 扩展类属性(分类不能扩展类属性)
使用分类:
* 为系统类添加方法(eg: 为 NSString 添加字符串校验).
* 开发人员针对自己的类,将相关方法分组到不同的文件.

## UITableView 重用机制
UITableView 是 iOS 开发中最长用的控件,为了节省内存开销, UITableView 使用重用机制(重用 cell 单元格).
### 使用重用机制创建 cell
* 定义重用标示(static 修饰字符串).
* 在重用池取出 cell.
* 若重用池没有可用 cell, 创建新的 cell.
```swift
static NSString *reuseIndentifier = @"MyCell";  
UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIndentifier];  
if (!cell) {  
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIndentifier];  
}
```
### 原理
UITableView 维护这两个队列,单前可视 cell 队列 visiableCells, 可重用 cell 队列 reusableTableCells(重回池).
在最初visiableCells, reusableTableCells 都为空, "UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];" 获取 cell 为 nil, 执行 cell 初始化方法创建显示并存入到 visiableCells.如果屏幕最多显示 cell 个数为10,当加载完第11个 cell 时创建的第一个 cell 在 visiableCells 移除加入到 reusableTableCells 中,所以在加载第12个 cell 时只需在 reusableTableCells 取出 cell 即可.第十二个 cell 加载完成后创建的第二个 cell 移出 visiableCells 进入 reusableTableCells 中,依次类推(理论讲只需创建11个 cell 就可).

### 遇到问题和优化
* 重取出来的cell是有可能已经捆绑过数据或者加过子视图的，造成视图叠加混乱的现象
    * 删除已有数据或子视图.
    * 放弃了重用机制，每次根据indexPath获取对应的cell返回(内存销耗特大).
* 结合 MJFresh 实现数据分页加载.
* 结合 SDWebImage 实现 cell 中图片异步加载以及缓存.






 



















