---
title: SDWebImage 源码一览
date: 2018-11-20 15:46:22
keywords:
- SDWebImage
tags:
- 三方库
categories:
- iOS
- 源码解读
description: 
---
[![](https://github.com/SDWebImage/SDWebImage/raw/master/SDWebImage_logo.png)](https://github.com/SDWebImage/SDWebImage)
<!--more-->

## SDImageCache
### SDMemoryCache (只针对 iOS, 其他系统与 NSCache 一样)
SDMemoryCache: 继承于NSCache. 声明三个私有属性:  config, weakCache, weakCacheLock
* config: SDImageCacheConfig 缓存配置信息
* weakCache: NSMapTable<KeyType, ObjectType> 缓存信息
* weakCacheLock: dispatch_semaphore_t 锁,保证数据安全

```swift 
 /// 初始化 config, weakCache, weakCacheLock 变量, 添加一个内存警告监听, 内存警告时释放内存.
 - (instancetype)initWithConfig:(SDImageCacheConfig *)config
 
 // shouldUseWeakMemoryCache: 为 true 是将数保存到 weakCache, 反之不保存到 weakCache;获取是为 flase 是直接返回父类查出数据. 反之判断内存中是否有对应数据,没有再在 weakCache 获取,并保存到内存.
 
 
 /// 保存数据 重写父类方法,首先将数据保存内存,然后再将数据存储在 weakCache.(weakCacheLock保证数据安全)
 /// 如果 shouldUseWeakMemoryCache 为 false 则不存储到 weakCache.
 - (void)setObject:(id)obj forKey:(id)key cost:(NSUInteger)g
 
 /// 获取数据 重写父类方法. 判断是否是弱内存缓存,否: 直接返回父类查询对象.是: 在 weakCache 取出相应对象并保存内存中返回.
 - (id)objectForKey:(id)key
 
 /// 根据 key 移除数据 重写父类方法. 如果 shouldUseWeakMemoryCache 为 false 只移除内存数据,为 true 移除 weakCache.
 - (void)removeObjectForKey:(id)key
 
 /// 移除数据 重写父类方法. 如果 shouldUseWeakMemoryCache 为 false 只移除内存数据,为 true 移除 weakCache.
 - (void)removeAllObjects 
 
 ```
 ### SDImageCache
 SDImageCache: 图片缓存类
 * memCache: SDMemoryCache 内存控制器
 * diskCachePath: NSString 根路径
 * customPaths: NSMutableArray<NSString *> 自定义路径 只读路径
 * ioQueue: dispatch_queue_t 数据读取队列
 * fileManager: NSFileManager 文件管理器

```swift

/// 提供单例方式创建
+ (nonnull instancetype)sharedImageCache


/// 给属性复制初始化. 默认为 NSCachesDirectory 下路径. 添加两个通知 删除旧数据
- (nonnull instancetype)initWithNamespace:(nonnull NSString *)ns
diskCacheDirectory:(nonnull NSString *)directory

/// 省略一系列文件路径处理方法...

/// 对 key MD5加密处理产生文件名
- (nullable NSString *)cachedFileNameForKey:(nullable NSString *)key

/**
 缓存数据
 self.config.shouldCacheImagesInMemory 为true 则保存内存,否则只保存磁盘

 @param image 图片
 @param imageData 图片 Data
 @param key 键值
 @param toDisk 是否存磁盘
 @param completionBlock 存储回调
 */
- (void)storeImage:(nullable UIImage *)image imageData:(nullable NSData *)imageData forKey:(nullable NSString *)key toDisk:(BOOL)toDisk completion:(nullable SDWebImageNoParamsBlock)completionBlock

// 保存文件.通过写文件形式保存. self.config.shouldDisableiCloud 为 true 保存 iCloud
- (void)_storeImageDataToDisk:(nullable NSData *)imageData forKey:(nullable NSString *)key 

// 判断是否有缓存文件存在
- (void)diskImageExistsWithKey:(nullable NSString *)key completion:(nullable SDWebImageCheckCacheCompletionBlock)completionBlock

// 获取存储的数据
- (nullable NSData *)diskImageDataForKey:(nullable NSString *)key

// 仅在内存查找缓存 
- (nullable UIImage *)imageFromMemoryCacheForKey:(nullable NSString *)key

// 在磁盘查找缓存 diskImage && self.config.shouldCacheImagesInMemory 为 true 写入内存
- (nullable UIImage *)imageFromDiskCacheForKey:(nullable NSString *)key

// 缓存查找 先查找内存,然后磁盘
- (nullable NSOperation *)queryCacheOperationForKey:(nullable NSString *)key options:(SDImageCacheOptions)options done:(nullable SDCacheQueryCompletedBlock)doneBlock

// 移除缓存 (内存与磁盘)
- (void)removeImageForKey:(nullable NSString *)key fromDisk:(BOOL)fromDisk withCompletion:(nullable SDWebImageNoParamsBlock)completion
```
## UIImageView 加载图片
### UIImageView+WebCache
UIImageView 类扩展, 添加方法
```swift
/**
 UIImageView+WebCache 添加的方法最终都调用该方法.

 @param url 图片 URL 地址
 @param placeholder 占位图片
 @param options 加载模式
 @param progressBlock 进度
 @param completedBlock 加载完成回调
*/
- (void)sd_setImageWithURL:(nullable NSURL *)url laceholderImage:(nullable UIImage *)placeholder options:(SDWebImageOptions)options progress:(nullable SDWebImageDownloaderProgressBlock)progressBlock completed:(nullable SDExternalCompletionBlock)completedBlock
```

### UIView+WebCache
UIImageView,UIButton 等添加的类目方法将调用该扩展方法.
```swift
/**
 * 该方法采用了大量的回调函数.
 * 1. 判断当前图片是否在加载,如果在加载取消加载.
 * 2. 设置占位图现在.
 * 3. 判断 URL 是否有效,无效调用 completedBlock 返回
 * 4. 初始化 SDWebImageManager 对象
 * 5. 调用 SDWebImageManager 图片加载方法.
 * 6. SDWebImageManager 回调中处理.
 * 6.1. 当前对象已销毁或者回调图片 URL 与需要加载不一致,返回
 * 6.2. 判断是否需要更新显示图片.调用 callCompletedBlockClojure 代码.
 * 6.3. 需要更新图片 调用图片更换方法
 * 6.4. 将 SDWebImageOperation 添加到 SDOperationsDictionary
 */
 
- (void)sd_internalSetImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder options:(SDWebImageOptions)options operationKey:(nullable NSString *)operationKey setImageBlock:(nullable SDSetImageBlock)setImageBlock progress:(nullable SDWebImageDownloaderProgressBlock)progressBlock completed:(nullable SDExternalCompletionBlock)completedBlock context:(nullable NSDictionary<NSString *, id> *)context

```

### SDWebImageManager
图片缓存查找以及下载处理
```swift
/**
 * 1. 创建 SDWebImageCombinedOperation
 * 2. 判断 URL 是否有效.无效直接返回
 * 3. 将 operation 加入到 runningOperations
 * 4. 调用 SDImageCache 中方法查找是否有缓存数据,如果找到回调 移除 Operation
 * 5. 找不到用 SDWebImageDownloader 下载图片.并保存缓存中.
- (id <SDWebImageOperation>)loadImageWithURL:(nullable NSURL *)url options:(SDWebImageOptions)options progress:(nullable SDWebImageDownloaderProgressBlock)progressBlock completed:(nullable SDInternalCompletionBlock)completedBlock
```
