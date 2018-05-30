---
title: 实现 cell 加载网络图片自适应方案
date: 2018-05-23 14:57:56
keywords: 
    - TableViewCell
    - 自适应
tags: 
    - cell 自适应
categories: 
    - iOS
    - TableView
---
UITableView 是 iOS 开发中最常用的控件之一,使用 UITaleView 时最头疼的莫过于 cell 高度的计算,虽说在 iOS8.0 以后引入了自适应方法,但在适配过程中任然会遇到各种难题,尤其是为了满足产品需求进行复杂 cell 自定义时,高度计算可谓是难上加难.这里主要对开发中遇到的自定义 cell 是加载网络图片适配问题进行总结.
<!--more-->

在开发中为了用户能有更好体验,对网络请求多采用异步请求的方式,更有甚者对请求数据做了本地缓存.图片作为 app 中最常见的展现形式无疑是最耗流量的,对图片的处理直接影响到用户的体验,好在有大神为我们提供了好的框架([Kingfisher](https://github.com/onevcat/Kingfisher),[SDWebImage](https://github.com/rs/SDWebImage)),大大提高了我们的开发效率.

图片的异步加载提高了用户体验,却在开发中遇到了新的难题,因为图片异步加载你无法提前预知图片的尺寸,在布局时难以控制 UIImageView 的大小,如果将 UIImageView 固定大小势必会造成图片的压缩或拉伸,现在主要针对于自定义 cell 时对图片自适应布局提一些建议.

### 固定 UIImageView 大小
在开发中我们时常会将 UIImageView 固定大小或者固定宽高比例,通过设置 ImageView 的 contentMode 属性设置图片的显示风格.  
该方法简单容易造成图片压缩拉伸或显示不全问题.  
contentMode 取值:  

```swift
public enum UIViewContentMode : Int {

    case scaleToFill //缩放内容到合适比例大小

    case scaleAspectFit //缩放内容到合适的大小，边界多余部分透明

    case scaleAspectFill  //缩放内容填充到指定大小，边界多余的部分省略

    case redraw //重绘视图边界

    case center //视图保持等比缩放,居中

    case top //视图顶部对齐

    case bottom //视图底部对齐

    case left //视图左侧对齐

    case right //视图右侧对齐

    case topLeft //视图左上角对齐

    case topRight //视图右上角对齐

    case bottomLeft //视图左下角对齐

    case bottomRight //视图右下角对齐
}
```

### 通过获取服务器存储的图片尺寸布局
在上传图片时可以将图片的大小一起上传服务器保存,在用户加载图片时将图片信息和图片 URL 地址一起返回,根据返回的图片信息计算 UIImageView 的 size 进行布局.  
该方法比较简单,但需要后台配合使用.

### 通过监听图片加载刷新 cell 实现(配合 cell 自适应)
无论 SDWebiamge 还是 Kingfisher,作者都给我们提供了图片加载完回调方法,我们可以在图片加载完后重新计算 cell 高度.  
该方法大大加大了 cell 的刷新频率.  
具体步骤:  
* 在自定义 cell 中定义闭包变量.  
``var refreshCell: ((IndexPath) -> Void)?``
* 在图片加载完成的回调中调用闭包,为了减少 cell 的刷新,判断是拉取网络数据还是加载的缓存数据,如果是网络数据调整图片大小并将调整后图片覆盖网络加载图片,如果是缓存图片不处理.  
```swift
iconImageView.kf.setImage(with: URL(string: iconImageURL), placeholder: UIImage(named: "tmp")) { [weak self](image, error, type, url) in
    if type == .none {
        self?.iconImageView.image =  self?.iconImageView.image?.ytt.resetImageSizeWithWidth(UIScreen.main.bounds.width)
        ImageCache.default.store((image?.ytt.resetImageSizeWithWidth(UIScreen.main.bounds.width))!, forKey: (url?.absoluteString)!)
        self?.refreshCell?(indexPath)
    }
}
```
* 在 TableView 回调方法中实现闭包,仅当 cell 展现在屏幕时刷新
```swift
cell.refreshCell = {(index) in
    if (tableView.indexPathsForVisibleRows?.contains(index))! {
        tableView.reloadRows(at: [index], with: .automatic)
    }
}
```

### 通过 ImageIO 框架获取图片信息
在给 UIImageView 赋值时通过 ImageIO 获取 image 的尺寸,修改 UIImageView 的大小.  
该方法需要在网络请求数据,加大了数据请求量.  
实现代码:
```swift
let imageSource = CGImageSourceCreateWithURL(URL(string: iconImageURL)! as CFURL, nil)
if let result = CGImageSourceCopyPropertiesAtIndex(imageSource!, 0, nil) as? Dictionary<String, Any> {
    if let width = result["PixelWidth"] as? CGFloat, let height = result["PixelHeight"] as? CGFloat {
        let h =  (UIScreen.main.bounds.width - 20) / (width / height)
        iconImageView.snp.remakeConstraints { (make) in
            make.height.equalTo(h)
        }
    }
}
```
