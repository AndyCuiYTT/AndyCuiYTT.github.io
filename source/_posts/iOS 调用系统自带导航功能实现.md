---
title: iOS 调用系统自带导航功能实现
date: 2017-6-18 15:46:22
keywords:
- 导航
- 高德地图
tags:
- 地图
categories:
- iOS
- 地图
description: 项目中需要用到导航功能,接收前人项目引用的高德地图,原本简单的项目因为引入高德导航使得包变大,决定使用系统自带的地图导航功能替代原有的导航.
---
使用系统导航需要用到 MapKit 框架.通过调用 'MKMapItem.openMaps(with: [items], launchOptions: [options])' 方法调起系统地图的导航功能.items 是一个数组,标记要经过的地方坐标 MKMapItem 类型,options 参数设置.
具体使用如下:
```swift
let startItem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 36.7233600000, longitude: 116.9919300000), addressDictionary: nil))
startItem.name = "济南百里黄河风景区" // 地址名

let endItem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 36.6709560000, longitude: 116.9908110000), addressDictionary: nil))
endItem.name = "济南站" // 地址名
endItem.phoneNumber = "0531-82422002" // 电话

/**
*  key: MKLaunchOptionsDirectionsModeKey 导航模式
*       MKLaunchOptionsDirectionsModeDriving 汽车
*       MKLaunchOptionsDirectionsModeWalking 步行
*       MKLaunchOptionsDirectionsModeTransit 公交
*
*  key: MKLaunchOptionsMapTypeKey 地图类型
*       MKMapType 类型
*
*  key: MKLaunchOptionsShowsTrafficKey 是否显示详情按钮
*/

let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsShowsTrafficKey: NSNumber(booleanLiteral: true), MKLaunchOptionsMapTypeKey: MKMapType.hybrid.rawValue] as [String : Any]

MKMapItem.openMaps(with: [startItem, endItem], launchOptions: options) 

```

