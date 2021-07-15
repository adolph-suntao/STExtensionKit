//
//  Data+Extension.swift
//  YUNJI
//
//  Created by 孙涛 on 2020/3/7.
//  Copyright © 2020 孙涛. All rights reserved.
//

import Foundation

extension Date: STCompatible {}
extension ST where Base == Date {
    /**
     *  是否为今天
     */
    public func isToday() -> Bool{
        let calendar = Calendar.current
        let unit: Set<Calendar.Component> = [.day,.month,.year]
        let nowComps = calendar.dateComponents(unit, from: Date())
        let selfCmps = calendar.dateComponents(unit, from: base)
        
        return (selfCmps.year == nowComps.year) &&
        (selfCmps.month == nowComps.month) &&
        (selfCmps.day == nowComps.day)
    }
    
    /**
     *  是否为本月
     */
    public func isThisMonth() -> Bool {
        let calendar = Calendar.current
        let nowCmps = calendar.dateComponents([.month], from: Date())
        let selfCmps = calendar.dateComponents([.month], from: base)
        let result = (nowCmps.month == selfCmps.month) && (selfCmps.year == nowCmps.year)
        return result
    }

    /**
     *  是否为昨天
     */
    public func isYesterday() -> Bool {
        let calendar = Calendar.current
        let unit: Set<Calendar.Component> = [.day,.month,.year]
        let nowComps = calendar.dateComponents(unit, from: Date())
        let selfCmps = calendar.dateComponents(unit, from: base)
        if selfCmps.day == nil || nowComps.day == nil {
            return false
        }
        let count = nowComps.day! - selfCmps.day!
        return (selfCmps.year == nowComps.year) &&
            (selfCmps.month == nowComps.month) &&
            (count == 1)
    }
    /**
     *  是否为今年
     */
    public func isThisYear() -> Bool {
        let calendar = Calendar.current
        let nowCmps = calendar.dateComponents([.year], from: Date())
        let selfCmps = calendar.dateComponents([.year], from: base)
        let result = nowCmps.year == selfCmps.year
        return result
    }
    
    /// 只有年月日的字符串 yyyy-MM-dd
    public func dataWithYMD() -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        let selfStr = fmt.string(from: base)
        return selfStr
    }
    
    /// 只有年月日时分秒的字符串
    public func dataWithYMDHMS() -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let selfStr = fmt.string(from: base)
        return selfStr
    }
    
    /// 时间转换自定义格式
    public func dataWithCustom(dateFormatStr: String) -> String {
        guard !dateFormatStr.isEmpty else { return "" }
        let fmt = DateFormatter()
        fmt.dateFormat = dateFormatStr
        let selfStr = fmt.string(from: base)
        return selfStr
    }
    
    /**
     *  获得与当前时间的差距
     */
    public func deltaWithNow() -> DateComponents{
        let calendar = Calendar.current
        let cmps = calendar.dateComponents([.hour,.minute,.second], from: base, to: Date())
        return cmps
    }
    
    // MARK: - 静态方法
    
    /**
     *  获得当前时间戳
     */
    public static func getTimeInterval() -> Int {
        let recordTime = NSDate().timeIntervalSince1970 * 1000
        let result = lround(recordTime)
        return result
    }
    
    /// 分别获取当前年月日值
    public static func getCurrentYMD() -> ((year: Int, month: Int, day: Int)) {
        let date = Date()
        let calendar = NSCalendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        return (year, month, day)
    }
    
    /// 通过字符串获取日期 yyyy-MM-dd
    public static func getDateWithDateFormatStr(formateDate: String) -> Date? {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        let date = fmt.date(from: formateDate)
        return date
    }
    
    /// 通过字符串获取日期 yyyy-MM-dd
    public static func getDateWithTimeInterval(timeInterval: Int) -> Date? {
        var newTime = timeInterval
        if "\(timeInterval)".count == 13 {
            newTime = timeInterval/1000
        }
        return Date(timeIntervalSince1970: TimeInterval(newTime))
    }

    /// 通过日期获取字符串  yyyy-MM-dd
    public static func getDateStrWithDate(date: Date) -> String? {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        let dateStr = fmt.string(from: date)
        return dateStr
    }
    
    /// 获取时间间隔 天数 endTime-startTime 返回时间戳 单位 秒
    public static func getSpaceDayTime(startTime: Date, endTime: Date) -> Int? {
        let spaceInterval = endTime.timeIntervalSince(startTime)
        let space = Int(spaceInterval)
        return space
    }
    /// 时间间隔
    public static func getSpaceTime(startTime: Date, endTime: Date) -> DateComponents {
        let calendar = Calendar.current
        let unit: Set<Calendar.Component> = [.day,.month,.year, .hour, .minute, .second]
        let dateCom = calendar.dateComponents(unit, from: startTime, to: endTime)
        return dateCom
    }
    
    /// 获取当前年月日的时间戳 10位
    public static func timeInterval(time: String, dateFormater: String) -> TimeInterval {
        guard !time.isEmpty , !dateFormater.isEmpty else {
            return 0
        }
        let fmt = DateFormatter()
        fmt.dateFormat = dateFormater
        let result = fmt.date(from: time)
        guard result != nil else {
            return 0
        }
        return result!.timeIntervalSince1970
    }
    
    /// 通过时间戳获取指定格式时间字符串
    public static func getDateWithTimeinterval(time: Int, dateFormat: String = "yyyy-MM-dd") -> String {
        var newTime = time
        if "\(time)".count == 13 {
            newTime = time/1000
        }
        let date = Date(timeIntervalSince1970: TimeInterval(newTime))
        let fmt = DateFormatter()
        fmt.dateFormat = dateFormat
        let timeStr = fmt.string(from: date)
        return timeStr
    }
    
    /// 获取指定年份和月份的天数
    public static func getDayRange(year: Int?, month: Int?) -> Int {
        guard let year = year else {
            return 30
        }
        guard let month = month else {
            return 30
        }
        
        var day = 0
        switch month {
        case 1, 3, 5, 7, 8, 10, 12:
            day = 31
            
        case 4, 6, 9, 11:
            day = 30
            
        case 2:
            if ((year%4 == 0)&&(year%100 != 0)) || (year%400==0) {
                day = 29
            } else {
                day = 28
            }
        default: day = 31
        }
        return day
    }
}
