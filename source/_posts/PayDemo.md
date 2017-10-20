---
title: 支付宝微信简单封装
date: 2017-07-14 18:57:25
keywords: 支付
categories:
- swift
tags:
- pay
- alipay
- wechatpay
---
> 封装支付宝与微信支付,采用代理的方式接收支付结果.
<!-- more -->

# 支付宝支付
> ## 调起支付
```swift
    /// 调起支付宝支付
    ///
    /// - Parameters:
    ///   - orderinfo: 商品信息字符串
    ///   - signedString: 商户信息签名
    ///   - fromScheme: 应用注册scheme
    ///   - resultDic: 支付结果回调
    func pay(_ orderinfo: String, signedString: String, fromScheme: String) -> Void
```
> ## 支付结果回调,遵守 AlipayDelegate 协议
```swift
    /// 支付成功
    func alipaySuccess(_ result: Any) -> Void;
    /// 支付失败
    func alipayFail(_ result: Any) -> Void;
    /// 支付取消
    func alipayCancel(_ result: Any) -> Void;
    /// 其他未知错误
    func alipayUnknownError(_ result: Any) -> Void;
```

# 微信支付
> ## 调起支付
```swift
    /// 微信支付
    ///
    /// - Parameter orderInfo: 支付信息(包含:partnerId,prepayId,package,nonceStr,timeStamp,sign等信息)
    func pay(_ orderInfo: [String : String]) -> Void
```
> ## 微信支付 item
> > * appid: 应用ID(微信开放平台审核通过的应用APPID)
* partnerid: 商户号(微信支付分配的商户号)
* prepayid: 预支付交易会话ID(微信返回的支付交易会话ID)
* package: 扩展字段(只读)
* noncestr： 随机字符串（只读）
* timestamp： 时间撮（只读）
* getSignDic()： 获取签名后的字典

> ## 数据签名(获取签名字符串)
```swift
    /// 获取签名字符串(MD5 签名)
    ///
    /// - Parameters:
    ///   - orderInfo: 支付信息
    ///   - keyStr: API密钥
    /// - Returns: 签名字符串
    func getSignStr(_ orderInfo: [String : String] ,keyStr: String) -> String
```
> ## 支付结果回调,遵守 WeChatPayDelegate 协议
```swift
    /// 微信未安装
    func WeChatPayWXAppUninstall() -> Void;
    /// 支付成功
    func WeChatPaySuccess() -> Void;
    /// 支付失败
    func WeChatPayFail(errStr: String) -> Void;
    /// 支付取消
    func WeChatPayCancel() -> Void;
```

[具体实现参考 Demo](https://github.com/AndyCuiYTT/PayDemo)
