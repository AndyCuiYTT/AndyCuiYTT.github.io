---
title: 简易音乐播放器制作
date: 2016-04-20 22:02:31
keywords:
- 播放器
- AVPlayer
tags:
- 音视频
categories:
-  iOS
- 音视频
description: 为了熟悉 iOS 开发制作的这个建议播放器,实现了音乐播放基本功能.
---
### 介绍
    1.功能:音乐列表,播放,暂停,上一曲,下一曲,进度条(显示进度时间,控制进度),随机播放,单曲循环,顺序播放,歌词显示等
    2.使用框架:AVFoundation
    3.知识点:AVPlayer 使用,pch 文件使用,封装思想,MVC模式,storyBoard的使用,消息发送机制,观察者,block回调,nstimer,nsrunloop,空间约束,第三方使用等  
### 详细过程
#### 一.使用 storyBoard 布局
    1.歌曲列表界面:使用 TableViewController ,创建相应的 viewController , 继承于 UITableViewController ,与 storyBoard 控件相关联,实现相应方法
    2.播放页面:添加相应控件,添加约束条件 , 创建相应的 viewController , 继承于 UIViewController ,与 storyBoard 控件相关联,实现相应方法  
    难点:播放图片与歌词页面 
        a.添加一个 ScrollView ,设置适当高度,宽度等于屏幕宽  
        b. 在ScrollView 添加一个 View ,与 Scroll 等高,宽度是 ScrollView 的两倍,距 ScrollView 上下左为零,  
        c. 在 View 视图添加一个两个 UIView(播放和歌词页面) 子视图,播放页面距 view 上下左都为 0 ,宽度为屏幕宽,歌词页面距 view 页面上下右 都为 0,宽度为屏幕宽.在播放页面添加 imageView 作为播放图片显示,在歌词页面添加 tableView 作为歌词显示.  
#### 二.获取歌曲信息
    服务器端数据信息不规范,是 plist 文件,可以直接获取 array 形式.
#### 三.对获取信息进行解析
    1.建立 Model ,在网络获取到的歌词是 NSString 类型,需要对其进行处理,转化为两个数组,一个存放歌词时间信息,一个存放歌词内容.使用到 NSString 的 componentsSeparatedByString 方法,把字符串根据某个字符切割转化为数据
    2.把获取到的数据数组转化为 Model 数据
#### 四.封装播放控制类
    1.使用单例:由于播放器在一个程序中只能有一个,如果过多会出现声音杂乱的情况.
    2.应用 block :添加 bloak ,使得可以在 ViewController 可以通过回调控制视图.
    3.添加监听:用来监听音乐的播放完成和音乐加载完成,实现其相应的操作. 
    ```OC
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playToEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];//监听音乐播放完成
    [playItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];//监听音乐加载完成
    ```
    4.应用NStimer , NSRunloop ,实现对播放的时时控制:使用回调控制 图片旋转,进度条,歌词滚动.
    ```OC
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(playTimer) userInfo:nil repeats:YES];//将定时器加入 runloop 中 
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];  
    [self.timer fire];　　　　　　　　　　　　        　　        　　        　　 
    ```
    5.AVPlayer 知识点: 
        a. AVPlayer 需要创建 AVPlayerItem ,数据的加载监听是对他的 status 属性德监听  
        b. 计算当前播放了多少秒 CGFloat timer = _avPlayer.currentTime.value / _avPlayer.currentTime.timescale; 
        c. 获取歌曲总时长: _sumTime = self.avPlayer.currentItem.duration.value / self.avPlayer.currentItem.duration.timescale; 
        d. 设置特定得时间播放点 self.avPlayer seekToTime:CMTimeMakeWithSeconds(timer * _sumTime, self.avPlayer.currentTime.timescale) completionHandler:^(BOOL finished) {}]; 
#### 五.对界面处理
```
难点:对歌词的处理 [self.lyricTableView selectRowAtIndexPath:[self lyricTableViewTime:timer] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
计算 IndexPath 方法:
- (NSIndexPath*)lyricTableViewTime:(CGFloat)time{
    for (int i = 0 ; i < model.timerArray.count ; i++){
        CGFloat timeArray = [model.timerArray[i] AG_StringToTime];
　　　　　if (time < timeArray){
　　　　　   return [NSIndexPath indexPathForItem:(i - 1 > 0 ? i - 1 : 0) inSection:0];
　　　　　}
　　}
　　return [NSIndexPath indexPathForItem:model.timerArray.count - 1 inSection:0];
}
　　　　　　　　　　　　　　　　 　　　　  　　　　 　　  　　
使 cell 透明 : cell.backgroundColor = [UIColor clearColor];
改变 cell 选中时的背景 : cell.selectedBackgroundView = view;
```
[参考代码](MusicTestOne.zip)
