---
title: '[swift] 星级评分'
date: 2017-07-13 11:39:29
keywords:
    - 星级评分
categories:
    - iOS
    - 自定义视图
tags:
    - 自定义视图
---
许多App都会有评价功能，这个时候或许会需要实现星级评分，下面我们来简单的实现一个星级评分功能。
<!-- more -->

## 思路
> 通过添加图片形式实现星级打分功能.创建两个视图,其中一个添加灰色星星图片,另一个添加橘色星星图片.橘色星星视图覆盖灰色星星视图,通过修改橘色星星视图的宽度实现评分的展现.
> 1. 创建一个继承于 UIView 的类,作为星级打分的显示视图
> 2. 创建灰色星星视图,并添加到父视图.
> 3. 创建橘色星星视图,添加到父视图,保证橘色视图覆盖灰色星星视图.
> 4. 通过修改橘色星星视图宽度实现评分.
> 5. 可通过手势等方式实现打分功能.

## 主要代码
### 创建子视图代码:
```swift
private func ay_creatStartView(_ imageName: String) -> UIView {
        let starView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        starView.clipsToBounds = true
        starView.backgroundColor = UIColor.clear
        starView.isUserInteractionEnabled = false
        let imgViewWidth = (self.frame.width - CGFloat(totalStarNumber - 1) * 3) / CGFloat(totalStarNumber)
        for i in 0 ..< totalStarNumber {
            let imageView = UIImageView(image: UIImage(named: imageName))
            imageView.frame = CGRect(x: CGFloat(i) * (imgViewWidth + 3), y: 0, width: imgViewWidth, height: self.frame.height)
            imageView.contentMode = .scaleAspectFit
            starView.addSubview(imageView)
        }
        return starView
    }

```
### 手指滑动打分代码
```swift
 override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let point = touch?.location(in: self)
        if (point?.x)! >= CGFloat(0) && (point?.x)! <= self.frame.width {
            rate = (point?.x)! / self.frame.width
            delegate?.ay_starRateChange(rate: rate)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let point = touch?.location(in: self)
        rate = (point?.x)! / self.frame.width
        delegate?.ay_starRateChange(rate: rate)
    }
```
[具体实现参考Demo](https://github.com/AndyCuiYTT/StarRating)
## 附加
星级评分通过图片实现是最简单的办法,当然也可以通过其他方式实现.例如通过 UIBezierPath 绘制,具体可参考[CPSliderView](https://git.oschina.net/soyeon/CPSliderView)
