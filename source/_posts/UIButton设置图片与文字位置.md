---
title: UIButton 设置图片与文字位置
date: 2018-08-10 09:52:00
keywords:
- UIButton左文字右图片
- UIButton设置图片与文字位置
tags:
- 自定义视图
categories:
- iOS
- 总结
---
UIButton 可谓是 iOS 开发中使用频率最多的控件了,然而很多时候系统为我们提供的 UIButton 样式不能满足我们的需求,需要我们对样式进行调整,主要对文字图片的位置进行总结.
<!-- more -->
## 以 UIButton 为跟视图,添加 UIImageView 与 UILabel
* 优点: 处理简单,可以很便捷的进行布局.
* 缺点: UIButton 本身自带有 UIImageView 与 UILabel 控件,重复.

## 通过设置 titleEdgeInsets 与 imageEdgeInsets 属性

* 优点: 可以直接调整 UIButton 的 UIImageView 与 UILabel,不必再次添加.
* 确定: 便宜量计算比较复杂.  

<font color=red>注意:</font> 设置 titleEdgeInsets 与 imageEdgeInsets 属性并不会调整 UIButton, UIImageView, UILabel 的 frame, 如果偏移后超出父视图范围则不会响应.

## 自定义 UIButton 
新建 YTTCustomButton 类,继承与 UIButton, 通过重写 layoutSubviews 方法进行调整.  
* imageAlignment属性: YTTButtonImageAlignment 类型 ( top, bottom, right, left 图片位置)
* spaceBetweenTitleAndImage: CGFloat 类型, 图片文字间距  

[CustomButton 下载](CustomButton.zip)
