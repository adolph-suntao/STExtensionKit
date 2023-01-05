//
//  UIColor+Extension.swift
//  YUANJI
//
//  Created by 孙涛 on 2021/3/1.
//

import Foundation
import UIKit

extension UIColor {

    /// 主题蓝色
    public static let themeBlueColor = UIColor(hexRGB: 0x4694ff)
    /// 边框颜色
    public static let themeBorderColor = UIColor(RGB: 236)
    /// 横线颜色
    public static let lineColor = UIColor(hexRGB: 0xF5F5F5)
    public static let lineAdv = UIColor(hexRGB: 0xF5F5F5)
    public static let lineCard = UIColor(hexRGB: 0xF5F5F5)

    /// 背景颜色 tableview
    public static let contentGrayColor = UIColor(hexRGB: 0xF5F5F5)
    public static let contentGrayF5 = UIColor(hexRGB: 0xF5F5F5)
    public static let contentGrayEC = UIColor(hexRGB: 0xECECEC)

    /// 主题黑色
    public static let themeTitleColor = UIColor(hexRGB: 0x151518)
    
    public convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) {
        if #available(iOS 10.0, *) {
            self.init(displayP3Red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
        } else {
            self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
        }
    }
    
    /// 十六进制颜色
    public convenience init(hexRGB:UInt, alpha: CGFloat = 1.0) {
        self.init(r: ((CGFloat)((hexRGB & 0xFF0000) >> 16)), g: ((CGFloat)((hexRGB & 0xFF00) >> 8)), b: ((CGFloat)(hexRGB & 0xFF)), alpha: alpha)
    }

    /// 三基色相等
    public convenience init(RGB: CGFloat, alpha: CGFloat = 1.0) {
        self.init(r: RGB, g: RGB, b: RGB, alpha: alpha)
    }

    /// 随机色
    public class func randomColor() -> UIColor {
        let red = CGFloat(arc4random_uniform(255))
        let green = CGFloat( arc4random_uniform(255))
        let blue = CGFloat(arc4random_uniform(255))
        return UIColor(r: red, g: green, b: blue)
    }
        
    /// 通过颜色生成图片
    public func colorImage(size:CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        var resultImage: UIImage?
        let rect = CGRect(x:0, y:0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return resultImage
        }
        context.setFillColor(self.cgColor)
        context.fill(rect)
        resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage
    }
}
