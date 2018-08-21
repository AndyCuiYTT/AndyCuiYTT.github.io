//
//  YTTSystemInfo.swift
//  YTT
//
//  Created by AndyCui on 2018/7/21.
//  Copyright © 2018年 AndyCuiYTT. All rights reserved.
//

import UIKit

class YTTSystemInfo {
    
    /// 获取设备名称
    class var deviceName: String {
        return UIDevice.current.name
    }
    
    /// 获取系统名称
    class var systemName: String {
        return UIDevice.current.systemName
    }
    
    /// 系统版本号
    class var systemVersion: String {
        return UIDevice.current.systemVersion
    }
    
    /// 获取设备唯一标示
    class var deviceUUID: String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }
    
    /// 获取设备型号
    class var deviceModel: String {
        return UIDevice.current.model
    }
    
    /// 获取 app 名称
    class var appName: String? {
        return Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
    }
    
    /// 获取 app 版本号
    class var appVersion: String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    /// 获取 app 构建版本号
    class var appBuildVersion: String? {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    }
    
    /// 获取设备具体型号
    class var deviceModelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "i386": return "Simulator"
        case "x86_64": return "Simulator"
        // iphone 系列
        case "iPhone1,1": return "iPhone 1G"
        case "iPhone1,2": return "iPhone 3G"
        case "iPhone2,1": return "iPhone 3GS"
        case "iPhone3,1": return "iPhone 4 (GSM)"
        case "iPhone3,2": return "Verizon iPhone 4"
        case "iPhone3,3": return "iPhone 4 (CDMA/Verizon/Sprint)"
        case "iPhone4,1": return "iPhone 4S"
        case "iPhone5,1": return "iPhone 5"
        case "iPhone5,2": return "iPhone 5"
        case "iPhone5,3": return "iPhone 5C"
        case "iPhone5,4": return "iPhone 5C"
        case "iPhone6,1": return "iPhone 5S"
        case "iPhone6,2": return "iPhone 5S"
        case "iPhone7,1": return "iPhone 6 Plus"
        case "iPhone7,2": return "iPhone 6"
        case "iPhone8,1": return "iPhone 6s"
        case "iPhone8,2": return "iPhone 6s Plus"
        case "iPhone8,4": return "iPhone SE"
        case "iPhone9,1": return "iPhone 7 (CDMA)"
        case "iPhone9,2": return "iPhone 7 Plus (CDMA)"
        case "iPhone9,3": return "iPhone 7 (GSM)"
        case "iPhone9,4": return "iPhone 7 Plus (GSM)"
        case "iPhone10,1": return "iPhone 8 (CDMA)"
        case "iPhone10,2": return "iPhone 8 Plus (CDMA)"
        case "iPhone10,3": return "iPhone X (CDMA)"
        case "iPhone10,4": return "iPhone 8 (GSM)"
        case "iPhone10,5": return "iPhone 8 Plus (GSM)"
        case "iPhone10,6": return "iPhone X (GSM)"
        // iPod 系列
        case "iPod1,1": return "iPod Touch 1G"
        case "iPod2,1": return "iPod Touch 2G"
        case "iPod3,1": return "iPod Touch 3G"
        case "iPod4,1": return "iPod Touch 4G"
        case "iPod5,1": return "iPod Touch 5G"
        case "iPod7,1": return "iPod Touch 6G"
        // iPad
        case "iPad1,1": return "iPad"
        case "iPad1,2": return "iPad 3G"
        case "iPad2,1": return "iPad 2 (WiFi)"
        case "iPad2,2": return "iPad 2 (GSM)"
        case "iPad2,3": return "iPad 2 (CDMA)"
        case "iPad2,4": return "iPad 2 (32nm)"
        case "iPad2,5": return "iPad Mini (WiFi)"
        case "iPad2,6": return "iPad Mini (GSM)"
        case "iPad2,7": return "iPad Mini (CDMA)"
        case "iPad3,1": return "iPad 3(WiFi)"
        case "iPad3,2": return "iPad 3(CDMA)"
        case "iPad3,3": return "iPad 3(4G)"
        case "iPad3,4": return "iPad 4 (WiFi)"
        case "iPad3,5": return "iPad 4 (4G)"
        case "iPad3,6": return "iPad 4 (CDMA)"
        case "iPad4,1": return "iPad Air"
        case "iPad4,2": return "iPad Air"
        case "iPad4,3": return "iPad Air"
        case "iPad4,4": return "iPad Mini 2"
        case "iPad4,5": return "iPad Mini 2"
        case "iPad4,6": return "iPad Mini 2"
        case "iPad4,7": return "iPad Mini 3"
        case "iPad4,8": return "iPad Mini 3"
        case "iPad4,9": return "iPad Mini 3"
        case "iPad5,1": return "iPad Mini 4"
        case "iPad5,2": return "iPad Mini 4"
        case "iPad5,3": return "iPad Air 2"
        case "iPad5,4": return "iPad Air 2"
        case "iPad6,3": return "iPad PRO (12.9)"
        case "iPad6,4": return "iPad PRO (12.9)"
        case "iPad6,7": return "iPad PRO (9.7)"
        case "iPad6,8": return "iPad PRO (9.7)"
        case "iPad6,11": return "iPad 5"
        case "iPad6,12": return "iPad 5"
        case "iPad7,1": return "iPad PRO 2 (12.9)"
        case "iPad7,2": return "iPad PRO 2 (12.9)"
        case "iPad7,3": return "iPad PRO (10.5)"
        case "iPad7,4": return "iPad PRO (10.5)"
        default: return ""
        }        
    }
}
