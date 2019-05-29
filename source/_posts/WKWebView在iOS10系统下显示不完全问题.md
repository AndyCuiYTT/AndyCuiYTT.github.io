---
title: WKWebView 在 iOS10 系统下显示不完全问题
date: 2019-03-27 13:29:14
keywords:
- WKWebView
- 系统适配
tags:
- WKWebView
categories:
- iOS
- 总结
description: WKWebView 在 iOS10系统下空白修复.
---
### WKWebView与 UIWebView 比较
> UIWebView自iOS2就有，WKWebView从iOS8才有，毫无疑问WKWebView将逐步取代笨重的UIWebView。通过简单的测试即可发现UIWebView占用过多内存，且内存峰值更是夸张。WKWebView网页加载速度也有提升，但是并不像内存那样提升那么多。

WKWebView 优势:
* 更多的支持HTML5的特性
* 官方宣称的高达60fps的滚动刷新率以及内置手势
* Safari相同的JavaScript引擎
* 将UIWebViewDelegate与UIWebView拆分成了14类与3个协议([官方文档说明](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/WebKit/ObjC_classic/index.html))
* 另外用的比较多的，增加加载进度属性：estimatedProgress

[WKWebView 使用](https://www.jianshu.com/p/5cf0d241ae12)

### WKWebView 使用遇到问题
> 在开发中为了提高加载速度,使用 WKWebView 替换了 UIWebView, 在 iOS8,iOS9,iOS11系统下均未发现问题,在 iOS10系统系下出现显示不完全问题.具体应用是在 UITableViewCell 中添加了 WKWebView,发现 WKWebView 无法完全显示,有大片空白存在,通过查询资料得知是由于 render 渲染问题,根据网上说明进行了修改:
```swift
// in the UITableViewDelegate
func scrollViewDidScroll(scrollView: UIScrollView) {
    if let tableView = scrollView as? UITableView {
        for cell in tableView.visibleCells {
            guard let cell = cell as? MyCustomCellClass else { continue }
            cell.webView?.setNeedsLayout()
        }
    }
}
```

### WKWebView 高度自适应
>  为了用户体验,我们需要 WKWebView 根据网页数据进行高度自适应,通过 WKWebView 的 WKNavigationDelegate 代理实现:
```swift
// in the WKNavigationDelegate
func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    // 处理网页图片过大问题
    let js = """
        function imgAutoFit() {
            var imgs = document.getElementsByTagName('img');
            for (var i = 0; i < imgs.length; ++i) {
                var img = imgs[i];
                img.style.maxWidth = \(kScreenWidth - 20);
            }
        }
    """
    webView.evaluateJavaScript(js, completionHandler: nil)
    webView.evaluateJavaScript("imgAutoFit()", completionHandler: nil)
    
    // 获取网页高度
    webView.evaluateJavaScript("document.body.scrollHeight") { (obj, error) in

        if let height = obj as? CGFloat {
            // height 网页数据高度
        }
    }
}
```
