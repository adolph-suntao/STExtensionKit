//
//  UIButton+Extension.swift
//  YUANJI
//
//  Created by 孙涛 on 2021/3/1.
//

import Foundation
import UIKit

public enum ButtonLayout {
    case leftImage
    case rightImage
    case topImage
    case bottomImage
}

extension UIButton: STCompatible {}
extension ST where Base == UIButton {
    /// 按钮图片和问题位置调整
    /// - Parameters:
    ///   - type: 图片位置
    ///   - space: 图片和文字的间距
    public func setLayoutType(type: ButtonLayout, space: CGFloat = 0.0){
        var text_W = ST.textWidth(text: self.base.titleLabel?.text, font: (self.base.titleLabel?.font)!, height: self.base.bounds.height)
        text_W = text_W > base.width ? base.width - 10 : text_W
        let text_H = ST.textHeight(text: self.base.titleLabel?.text, font: (self.base.titleLabel?.font)!, width: self.base.bounds.width)
        let img_w = self.base.imageView?.image?.size.width ?? 0.0
        let img_H = self.base.imageView?.image?.size.height ?? 0.0
        
        /// 默认状态下：image中心点距离button中心点的横向距离
        let ix = (text_W+img_w)/2.0 - img_w/2.0
       
        /// 上下排列状态下：image中心点距离button中心点的纵向距离， 如果按钮高度过高，则以按钮高度为准
        var iy = (img_H+text_H)/2.0 - img_H/2.0
        if self.base.frame.size.height > img_H+text_H {
            let vSpace = (self.base.frame.size.height - (img_H+text_H))/2
            iy = self.base.frame.size.height/2 - img_H/2.0 - vSpace
        }
       
        /// 默认状态下：label中心点距离button中心点的横向距离
        let lx = (text_W+img_w)/2.0 - text_W/2.0
        
        /// 上下排列状态下：label中心点距离button中心点的纵向距离
        var ly = (img_H+text_H)/2.0 - text_H/2.0
        if self.base.frame.size.height > img_H+text_H {
            let vSpace = (self.base.frame.size.height - (img_H+text_H))/2
            ly = self.base.frame.size.height/2 - text_H/2.0 - vSpace
        }
        
        switch type {
        case .leftImage:
            /// 图片在左
            self.base.imageEdgeInsets = UIEdgeInsets(top:0, left: -space/2, bottom: 0, right: space/2)
            self.base.titleEdgeInsets = UIEdgeInsets(top: 0, left: space/2, bottom: 0, right: -space/2)

        case .rightImage:
            /// 图片在右
            self.base.imageEdgeInsets = UIEdgeInsets(top:0, left: text_W+space/2.0, bottom: 0, right: -(text_W+space/2.0))
            self.base.titleEdgeInsets = UIEdgeInsets(top: 0, left: -(img_w+space/2.0), bottom: 0, right: img_w+space/2.0)

        case .topImage:
            /// 图片在上
            self.base.imageEdgeInsets = UIEdgeInsets(top: -iy-space/2.0, left: ix, bottom: iy+space/2.0, right: -ix)
            self.base.titleEdgeInsets = UIEdgeInsets(top: ly+space/2.0, left: -lx, bottom: -ly-space/2.0, right: lx)
        
        case .bottomImage:
            /// 图片在下
            self.base.imageEdgeInsets = UIEdgeInsets(top: iy+space/2.0, left: ix, bottom: -iy-space/2.0, right: -ix)
            self.base.titleEdgeInsets = UIEdgeInsets(top: -ly-space/2.0, left:  -lx, bottom: ly+space/2.0, right: lx)
        }
    }
    /// 获取自定义导航栏按钮
    /// - Parameter title: 标题
    /// - Returns: UIBarButtonItem
    public static func getCustomBtnItem(title: String,
                                 TitleColor: UIColor = UIColor.themeBlueColor,
                                 font: UIFont = UIFont.systemFont(ofSize: 15)) -> UIButton {
        
        let btn = UIButton(type: .custom)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(TitleColor, for: .normal)
        btn.titleLabel?.font = font
        
        let titleW = ST.textWidth(text: title, font: font, height: 44)
        btn.frame = CGRect(x: 0, y: 0, width: titleW+20+5, height: 44)
        btn.layer.masksToBounds = false
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        return btn
    }
    
    /// 获取自定义导航栏按钮
    /// - Parameter title: 图片
    /// - Returns: UIBarButtonItem
    public static func getCustomBtnItem(img: UIImage?) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.setImage(img, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.frame = CGRect(x: 0, y: 0, width: 55, height: 44)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 27, bottom: 0, right: 0)
        return btn
    }
    
    /// 计算文本的高度
    fileprivate static func textHeight(text: String?, font: UIFont, width: CGFloat) -> CGFloat {
        guard let newText = text else { return 0.0 }
        return newText.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil).size.height
    }
    
    /// 计算文本的宽度
    fileprivate static func textWidth(text: String?, font: UIFont, height: CGFloat) -> CGFloat {
        guard let newText = text else { return 0.0 }
        return newText.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil).size.width
    }
}
