---
title: UILabel 加载 HTML
date: 2018-08-13 16:04:32
keywords:
- UILabel
- HTML
- 富文本
tags:
- HTML
- 富文本
categories:
- iOS
- 总结
---
iOS 开发中为了开发方便时长会加载一些 HTML 静态页面,目前主要使用 UIWebView 与 WKWebView 进行加载,但仅仅作为页面展示我认为没有必要使用他们,且他们高度自适应比较繁琐,因此比较推荐使用 UILabel 加载富文本形式展现 HTML 页面.
<!-- more -->
## OC 代码
```swift
NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
label.attributedText = attrStr;
```

## swift 代码
```swift
if let data = htmlStr.data(using: String.Encoding.unicode), let attributedStr = try? NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil) {
    label.attributedText = attributedStr
}
```
