---
title: 浅谈 tableViewCell高度自适应
date: 2017-08-01 18:10:43
keywords: [tableViewCell,自适应]
tags:
- cell自适应
categories:
- tableView
---
 UITableView 是开发中最常用到的控件,可以说没有哪个 APP 离得开 UITableView 控件,使用时难免会遇到各种各样的问题,其中 cell 高度自适应是最让人头疼的,简单说一下我在开发中总结.
<!-- more -->
开发中面对 cell 的自适应有着各种各样的方法,无外乎以下几种:

## 根据数据源计算
> 通常做法为自定义 cell 添加类方法,传入当前 cell 的数据源,计算除 cell 的高度,返回.然后在 tableView 的代理方法中设置 cell 高度.
> 这种方法计算 cell 高度是需要注意:但计算 label 的高度时,要留意 label 的宽度和字体大小的设置,否则将会得到错误的高度

## 调用 tableView 的代理方法,拿到 cell 获取高度
> 这种做法的缺点使cell 的生成代码重复执行.

## iOS 8.0 以后可以与新引入 cell 自适应方法(在 xib 下使用)
> 需要设置 rowHeight( = UITableViewAutomaticDimension) 与 estimatedRowHeight 两个属性, rowHeight 设置表明使用自适应, estimatedRowHeight 一个参考值.
> 使用自适应如果 cell 中有图片,最好对 ImageView 的宽高进行限定,否则适配将会根据图片大小自适应.
> 当加载图片张数不确定时,可以添加一个 View, 在给 cell 赋值时用代码添加 ImgView, 将 view 的高度约束拖成属性,在图片添加完成后修改 view 的高度.
