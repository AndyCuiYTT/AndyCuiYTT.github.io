---
title: 会旋转的 UIImageView
date: 2019-07-09 08:35:14
keywords:
- CABasicAnimation
- 旋转动画
tags:
- CABasicAnimation
categories:
- iOS
- 自定义视图
description: 通过给继承与 UIImageView 的类 CXGImageView 添加 CABasicAnimation 转动动画,实现播放器图片转动效果.
---
主要提供三个方法: startRotating, stopRotating,resumeRotate

* startRotating
```swift
/// 开始动画
func startRotating() {
    let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
    rotateAnimation.isRemovedOnCompletion = false // 避免点击 Home 键返回,动画停止
    rotateAnimation.fromValue = 0.0
    rotateAnimation.toValue = Double.pi * 2
    rotateAnimation.duration = 20
    rotateAnimation.repeatCount = MAXFLOAT
    self.layer.add(rotateAnimation, forKey: nil)
    isRotating = true
}
```
* stopRotating
```swift
/// 停止动画
func stopRotating() {
    if !isRotating {
        return
    }
    let pausedTime = self.layer.convertTime(CACurrentMediaTime(), from: nil)
    // 让CALayer的时间停止走动
    self.layer.speed = 0
    // 让CALayer的时间停留在pausedTime这个时刻
    self.layer.timeOffset = pausedTime
    isRotating = false
}
```
* resumeRotate
```swift
/// 继续动画
func resumeRotate() {

    if isRotating {
        return
    }

    if self.layer.timeOffset == 0 {
        startRotating()
        return
    }

    let pausedTime = self.layer.timeOffset
    // 1. 让CALayer的时间继续行走
    self.layer.speed = 1.0
    // 2. 取消上次记录的停留时刻
    self.layer.timeOffset = 0.01
    // 3. 取消上次设置的时间
    self.layer.beginTime = 0.0
    // 4. 计算暂停的时间(这里也可以用CACurrentMediaTime()-pausedTime)
    let timeWhenpause = self.layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
    // 5. 设置相对于父坐标系的开始时间(往后退timeSincePause)
    self.layer.beginTime = timeWhenpause
    isRotating = true

}
```
***注意:*** 使用中发现,当点下 Home 键再次返回应用时,图片停止转动,需要将动画 isRemovedOnCompletion 置成 false.

[参考代码](CXGRotateImageView.zip)
