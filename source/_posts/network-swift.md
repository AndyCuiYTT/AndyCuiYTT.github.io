---
title: swift 网络请求
keywords: network
date: 2017-07-18 10:13:11
categories:
    - iOS
tags:
- network
---
对 Alamofire与系统的网络请求进行简易封装
<!-- more -->

# Alamofire
> ## post 请求
```swift
    /// post 请求
    ///
    /// 服务器端返回数据为 JSON 数据格式
    /// - Parameters:
    ///   - urlStr: 请求网络地址
    ///   - params: 请求参数
    ///   - result: 成功返回数据
    ///   - fail: 失败返回数据
    static func ay_post(_ urlStr: String, _ params: ayParams? = nil, result: @escaping (Any)->Void, fail: @escaping (Any)->Void){
        Alamofire.request(urlStr, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if response.result.isSuccess{
                result(response.result.value!)
            }else{
                fail(response.error?.localizedDescription ?? "Error");
            }
        }
    }
```
> ## get 请求
```swift
    /// get 请求
    ///
    /// 服务器端返回数据为 JSON 数据格式
    /// - Parameters:
    ///   - urlStr: 请求网络地址
    ///   - params: 请求参数
    ///   - result: 请求成功返回数据
    ///   - fail: 请求失败返回数据
    static func ay_get(_ urlStr: String, _ params: ayParams? = nil, result: @escaping (Any)->Void, fail: @escaping (Any)->Void){
        Alamofire.request(urlStr, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if response.result.isSuccess{
                result(response.result.value!)
            }else{
                fail(response.error?.localizedDescription ?? "Error");
            }
        }
    }
```
> ## 下载文件
``` swift
    /// 下载文件
    ///
    /// - Parameters:
    ///   - urlStr: 文件地址
    ///   - method: 请求方式
    ///   - param: 请求参数
    ///   - fileURL: 保存文件路径
    ///   - progress: 下载进度
    ///   - result: 成功返回数据
    ///   - fail: 失败返回数据
    static func ay_downloadFile(_ urlStr: String, _ method: HTTPMethod? = .get, _ param: ayParams? = nil, fileURL: URL, progress: @escaping (Progress)->Void, result: @escaping (Any)->Void, fail: @escaping (Any)->Void) {
        //拼接文件保存地址
        let destination: DownloadRequest.DownloadFileDestination = { _, response in
            return (fileURL.appendingPathComponent(response.suggestedFilename!), [.removePreviousFile, .createIntermediateDirectories])
        }
        Alamofire.download(urlStr, method: method!, parameters: param, encoding: URLEncoding.default, headers: nil, to: destination).downloadProgress(queue: DispatchQueue.main, closure: { (progres) in
            progress(progres)
        }).responseData{(response) in
            if response.result.isSuccess {
                result(response.destinationURL!)
            }else{
                fail(response.error?.localizedDescription ?? "Error")
            }
        }
    }
```
> ## 文件上传
```swift
    /// 文件上传
    ///
    /// 上传文件时注意文件名与 mimeType
    /// - Parameters:
    ///   - urlStr: 上传地址
    ///   - param: 上传参数
    ///   - filesData: 上传数据数组 data 类型
    ///   - progress: 上传进度
    ///   - result: 成功返回数据
    ///   - fail: 失败返回数据
    static func ay_uploadFile(_ urlStr: String, _ param:ayParams? = nil,filesData: [Data], progress:@escaping (Progress)->Void, result: @escaping (Any)->Void, fail: @escaping (Any)->Void) {
        Alamofire.upload(multipartFormData: { (formData) in
            for data:Data in filesData {
                formData.append(data, withName: "file", fileName: "fileName.png", mimeType: "image/png")
            }
            if param != nil {
                for (key , value) in param! {
                    formData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            }
        }, to: urlStr) { (encodingResult) in
            switch encodingResult{
            case .success(request: let upload,_,_):
                upload.uploadProgress(closure: { (progres) in
                    progress(progres)
                })
                upload.responseJSON(completionHandler: { (response) in
                    if let value = response.result.value as? [String : AnyObject]{
                        result(value)
                    }
                })
            case .failure(let error):
                fail(error.localizedDescription)
            }
        }
    }
```

# 系统网络请求
> ## post 请求
```swift
    /// post 请求
    ///
    /// - Parameters:
    ///   - urlStr: 请求地址
    ///   - params: 请求参数
    ///   - result: 返回结果
    ///   - fail: 失败
    class func post(_ urlStr: String, params: [String : String], result: @escaping (Any) -> Void, fail: @escaping (Any) -> Void) {
        var request = URLRequest.init(url: URL(string: urlStr)!)
        request.timeoutInterval = NetworkConfig.timeoutInterval
        request.httpMethod = "POST"
        var paramStr = String()
        for (key , value) in params {
            paramStr.append("\(key)=\(value)&")
        }
        paramStr.remove(at: paramStr.index(before: paramStr.endIndex))
        request.httpBody = paramStr.data(using: .utf8)
        let session = URLSession(configuration: NetworkConfig.configuration)
        let task = session.dataTask(with: request) { (data, response, error) in
            if error == nil {
                if let value = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) {
                    result(value)
                }else {
                    result (String.init(data: data!, encoding: .utf8)!)
                }
            }else {
                fail(error.debugDescription)
            }
        }
        task.resume()
    }
```
> ## get 请求
```swift
    /// get 请求
    ///
    /// - Parameters:
    ///   - urlStr: 请求地址
    ///   - params: 请求参数
    ///   - result: 返回结果
    ///   - fail: 失败
    class func get(_ urlStr: String, params: [String : String], result: @escaping (Any) -> Void, fail: @escaping (Any) -> Void) {
        var paramStr = String()
        for (key , value) in params {
            paramStr.append("\(key)=\(value)&")
        }
        paramStr.remove(at: paramStr.index(before: paramStr.endIndex))
        var request = URLRequest.init(url: URL(string: urlStr + "?" + paramStr)!)
        request.timeoutInterval = NetworkConfig.timeoutInterval
        request.httpMethod = "GET"
        let session = URLSession(configuration: NetworkConfig.configuration)
        let task = session.dataTask(with: request) { (data, response, error) in
            if error == nil {
                if let value = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) {
                    result(value)
                }else {
                    result (String.init(data: data!, encoding: .utf8)!)
                }
            }else {
                fail(error.debugDescription)
            }
        }
        task.resume()
    }
```
> ## 文件下载
``` swift
    /// 文件下载
    ///
    /// - Parameters:
    ///   - urlStr: 下载地址
    ///   - fileName: 文件名
    ///   - result: 文件缓存路径
    ///   - fail: 失败
    class func download(_ urlStr: String, fileName: String, result: @escaping (String) -> Void, fail: @escaping (Any) -> Void) {
        let request = URLRequest.init(url: URL(string: urlStr)!)
        let session = URLSession(configuration: NetworkConfig.configuration)
        let task = session.downloadTask(with: request) { (pathUrl, response, error) in
            if error == nil {
                if let filePath: String = pathUrl?.path {
                    let fileManager = FileManager()
                    try! fileManager.moveItem(atPath: filePath, toPath: NetworkConfig.downloadPath.appending(fileName))
                    try! fileManager.removeItem(atPath: filePath)
                    result(NetworkConfig.downloadPath.appending(fileName))
                }
            }else {
                fail(error.debugDescription)
            }
        }
        task.resume()
    }
```
> ## 仿 form 表单多文件上传
```swift
    /// 仿 form 表单多文件上传
    ///
    /// - Parameters:
    ///   - urlStr: 上传文件路径
    ///   - params: 请求参数
    ///   - filesData: 文件数据
    ///   - fileName: 文件名
    ///   - fileExtensions: 文件扩展名
    ///   - contentType: 文件类型
    ///   - result: 返回数据
    ///   - fail: 失败
    class func upload(_ urlStr: String, params: [String : String], filesData: [Data], fileName: String, fileExtensions:String, contentType: String,result: @escaping (Any) -> Void, fail: @escaping (Any) -> Void) {
        let boundary = "*****" // 分界标识
        var bodyData = Data()
        // 添加普通参数
        for (key , value) in params {
            bodyData.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            bodyData.append("Content-Disposition:form-data;name=\"\(key)\"\r\n".data(using: .utf8)!)
            bodyData.append("Content-Type:text/plain;charset=utf-8\r\n\r\n".data(using: .utf8)!)
            bodyData.append("\(value)".data(using: .utf8)!)
        }
        // 添加文件数据
        for i in 0 ..< filesData.count {
            bodyData.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            bodyData.append("Content-Disposition:form-data; name=\"file\";filename=\(fileName)-\(i).\(fileExtensions)\r\n".data(using: .utf8)!)
            bodyData.append("Content-Type: \(contentType)\r\n\r\n".data(using: .utf8)!)
            bodyData.append(filesData[i])
        }
        bodyData.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        // 设置 request
        var request = URLRequest(url: URL(string: urlStr)!)
        request.addValue("multipart/form-data;boundary=\"\(boundary)\";charset=\"UTF-8\"", forHTTPHeaderField: "Content-Type")
        request.addValue("\(bodyData.count)", forHTTPHeaderField: "Content-Length")
        request.httpMethod = "POST"
        request.httpBody = bodyData
        request.timeoutInterval = NetworkConfig.timeoutInterval
        // 发起请求
        let session = URLSession(configuration: NetworkConfig.configuration)
        let task = session.dataTask(with: request) { (data, response, error) in
            if error == nil {
                if let value = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) {
                    result(value)
                }else {
                    result (String.init(data: data!, encoding: .utf8)!)
                }
            }else {
                fail(error.debugDescription)
            }
        }
        task.resume()
    }
```

# 添加网络数据缓存类
> ## 简述
> *  网络请求缓存处理
> *  将网络请求结果保存在本地，发起网路请求时先检测缓存区是否有缓存数据并判断是否超出缓存有效时间，如果数据有效则加载缓存区数据，否则加载网络数据.
> *  数据缓存采用 SQLite 存储，采用 FMDB 库.
> *  缓存数据表表数据有 key,value,date 三个字段. key: 网络请求参数 MD5加密数据. value:网络请求数据. date: 数据有效时间
> *  添加计时器,定时清除无效数据.

> ## 主要方法
```swift
    /// 获取数据
    ///
    /// - Parameter key: 键值
    /// - Returns: 数据
    func getResult(_ key: String) -> String?

    /// 添加数据
    ///
    /// - Parameters:
    ///   - key: 键值
    ///   - result: 请求数据
    ///   - date: 有效时间
    func addResult(_ key: String, result: String, date: TimeInterval) -> Void

    /// 移除失效数据
    ///
    /// - Parameter date: 时间点
    func removeResult(withOldDate date: TimeInterval) -> Void

    /// 根据 key 移除数据
    ///
    /// - Parameter key: 键值
    func removeResult(_ key: String) -> Void
```


[具体实现参考 Demo](https://github.com/AndyCuiYTT/AYNetwork_Swift)

