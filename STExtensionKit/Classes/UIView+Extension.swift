//
//  UIView+Extension.swift
//  YUANJI
//
//  Created by 孙涛 on 2020/5/25.
//  Copyright © 2020 孙涛. All rights reserved.
//

import Foundation

extension UIView {
    
    /// 部分圆角 注意⚠️ xib需要在 layoutSubviews 中设置
    ///
    /// - Parameters:
    ///   - corners: 需要实现为圆角的角，可传入多个
    ///   - radii: 圆角半径
    public func corner(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    public func corner(byRoundingCorners corners: UIRectCorner, viewBounds bounds: CGRect, radii: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }

    /// 设置阴影
    /// - Parameters:
    ///   - color: 阴影颜色
    ///   - offset: 阴影偏移量
    ///   - opacity: 阴影透明度
    ///   - radius: 阴影半径
    public func addShadow(color: UIColor, offset:CGSize, opacity:Float, radius:CGFloat) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
}

extension UIView {

    // x
    public var x : CGFloat {
        
        get {
            return frame.origin.x
        }
        set(newVal) {
            var tmpFrame : CGRect = frame
            tmpFrame.origin.x     = newVal
            frame                 = tmpFrame
        }
    }
    
    // y
    public var y : CGFloat {
        get {
            return frame.origin.y
        }
        set(newVal) {
            var tmpFrame : CGRect = frame
            tmpFrame.origin.y     = newVal
            frame                 = tmpFrame
        }
    }
    
    // height
    public var height : CGFloat {
        get {
            return frame.size.height
        }
        
        set(newVal) {
            var tmpFrame : CGRect = frame
            tmpFrame.size.height  = newVal
            frame                 = tmpFrame
        }
    }
    
    // width
    public var width : CGFloat {
        get {
            return frame.size.width
        }
        
        set(newVal) {
            var tmpFrame : CGRect = frame
            tmpFrame.size.width   = newVal
            frame                 = tmpFrame
        }
    }
    
    // left
    public var left : CGFloat {
        get {
            return x
        }
        
        set(newVal) {
            x = newVal
        }
    }
    
    // right
    public var right : CGFloat {
        get {
            return x + width
        }
        
        set(newVal) {
            x = newVal - width
        }
    }
    
    // top
    public var top : CGFloat {
        get {
            return y
        }
        
        set(newVal) {
            y = newVal
        }
    }
    
    // bottom
    public var bottom : CGFloat {
        get {
            return y + height
        }
        
        set(newVal) {
            y = newVal - height
        }
    }
    
    public var centerX : CGFloat {
        get {
            return center.x
        }
        
        set(newVal) {
            center = CGPoint(x: newVal, y: center.y)
        }
    }
    
    public var centerY : CGFloat {
        get {
            return center.y
        }
        
        set(newVal) {
            center = CGPoint(x: center.x, y: newVal)
        }
    }
    
    public var middleX : CGFloat {
        return width / 2

    }
    
    public var middleY : CGFloat {
        return height / 2
    }
    
    public var middlePoint : CGPoint {
        return CGPoint(x: middleX, y: middleY)
    }
}
