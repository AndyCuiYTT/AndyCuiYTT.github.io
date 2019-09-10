---
title: swift 获取图像指定点的颜色（UIColor）
date: 2019-09-06 14:08:02
keywords:
- UIColor
- UIImage
tags:
- UIColor
categories:
- iOS
- 绘图
description: 在 iOS 开发中，有时候需要获取图像中某个像素点的颜色，返回 UIColor 值。
---
网上收集资料，[参考各种方案](https://blog.csdn.net/huangfei711/article/details/76189655)，最后总结如下：
```swift
/// 获取图片触摸点颜色
///
/// 参考资料
/// https://blog.csdn.net/huangfei711/article/details/76189655
/// - Parameters:
///   - image: 要获取颜色的图片
///   - point: 触摸点
/// - Returns: 获取到的颜色
func cxg_getPointColor(withImage image: UIImage, point: CGPoint) -> UIColor? {

    guard CGRect(origin: CGPoint(x: 0, y: 0), size: image.size).contains(point) else {
        return nil
    }

    let pointX = trunc(point.x);
    let pointY = trunc(point.y);

    let width = image.size.width;
    let height = image.size.height;
    let colorSpace = CGColorSpaceCreateDeviceRGB();
    var pixelData: [UInt8] = [0, 0, 0, 0]

    pixelData.withUnsafeMutableBytes { pointer in
        if let context = CGContext(data: pointer.baseAddress, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue), let cgImage = image.cgImage {
            context.setBlendMode(.copy)
            context.translateBy(x: -pointX, y: pointY - height)
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        }
    }

    let red = CGFloat(pixelData[0]) / CGFloat(255.0)
    let green = CGFloat(pixelData[1]) / CGFloat(255.0)
    let blue = CGFloat(pixelData[2]) / CGFloat(255.0)
    let alpha = CGFloat(pixelData[3]) / CGFloat(255.0)

    if #available(iOS 10.0, *) {
        return UIColor(displayP3Red: red, green: green, blue: blue, alpha: alpha)
    } else {
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
```
