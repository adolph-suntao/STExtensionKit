//
//  Double+Extension.swift
//  YUANJI
//
//  Created by 孙涛 on 2021/3/1.
//

import Foundation

extension Double: STCompatible {}
extension ST where Base == Double {
    
    /// 四舍五入
    /// - Parameter places: 保留的位数
    /// - Returns: 返回结果
    public func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (base * divisor).rounded() / divisor
    }
        
    /// 小数点截断到指定位数
    /// - Parameter places: 保留的位数
    /// - Returns: 返回结果
    public func truncate(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return Double(Int(base * divisor)) / divisor
    }
}
