---
title: UITableView性能优化
date: 2019-02-21 13:54:45
keywords:
- 性能优化
- tableView 优化
tags:
- 性能优化
categories:
- iOS
- TableView
description: TableView是App里最常用的一个UI控件了，优化TableView性能，使我们提高用户体验必须要考虑的问题。
---

1. 提前计算并缓存好高度，因为heightForRow最频繁的调用。

```- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath;```

2. 异步绘制，遇到复杂界面，性能瓶颈时，可能是突破口。

3. 滑动时按需加载，这个在大量图片展示，网络加载时，很管用。（SDWebImage已经实现异步加载）。

4. 重用cells。

5. 如果cell内显示得内容来自web，使用异步加载，缓存结果请求。当cell中的部分View是非常独立的，并且不便于重用的，而且“体积”非常小，在内存可控的前提下，我们完全可以将这些view缓存起来。当然也是缓存在模型中。

6. 少用或不用透明图层，使用不透明视图。对于不透明的View，设置opaque为YES，这样在绘制该View时，就不需要考虑被View覆盖的其他内容（尽量设置Cell的view为opaque，避免GPU对Cell下面的内容也进行绘制）

7. 减少subViews。分析Cell结构，尽可能的将 相同内容的抽取到一种样式Cell中，前面已经提到了Cell的重用机制，这样就能保证UITbaleView要显示多少内容，真正创建出的Cell可能只比屏幕显示的Cell多一点。虽然Cell的’体积’可能会大点，但是因为Cell的数量不会很多，完全可以接受的

8. 少用addView给cell动态添加view，可以初始化的时候就添加，然后通过hide控制是否显示。只定义一种Cell，那该如何显示不同类型的内容呢？答案就是，把所有不同类型的view都定义好，放在cell里面，通过hidden显示、隐藏，来显示不同类型的内容。毕竟，在用户快速滑动中，只是单纯的显示、隐藏subview比实时创建要快得多

