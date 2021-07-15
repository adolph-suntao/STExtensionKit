//
//  UISegmentedControl+Extension.swift
//  YUANJI
//
//  Created by 孙涛 on 2021/3/1.
//

import Foundation
import UIKit

extension UISegmentedControl: STCompatible {}
extension ST where Base == UISegmentedControl {
    public func ensureiOS12Style() {
        if #available(iOS 13.0, *) {
            
            let color = UIColor.themeBlueColor
            /// 主题色
            let tiniColorImg = color.colorImage(size: CGSize(width: 1, height: 30))
            
            base.setBackgroundImage(base.backgroundColor?.colorImage() ?? UIColor.clear.colorImage(size: CGSize(width: 1, height: 35)), for: .normal, barMetrics: .default)
            
            base.setBackgroundImage(tiniColorImg, for: .selected, barMetrics: .default)
            base.setBackgroundImage(tiniColorImg, for: .highlighted, barMetrics: .default)
          
            /// 设置正常字体颜色
            base.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : color, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)], for: .normal)
            
            /// 设置选中字体颜色
            base.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)], for: .selected)
            
            base.setDividerImage(tiniColorImg, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
            
            base.layer.borderWidth = 1
            base.layer.cornerRadius = 5
            base.layer.borderColor = color.cgColor
            base.selectedSegmentTintColor = color
        }
    }
    
    public func ensureiOS12CustomStyle(themeColor: UIColor, selectTextColor: UIColor, normalextColor: UIColor) {
        if #available(iOS 13.0, *) {
            
            let color = themeColor
            /// 主题色
            let tiniColorImg = color.colorImage(size: CGSize(width: 1, height: 30))
            
            base.setBackgroundImage(base.backgroundColor?.colorImage() ?? UIColor.clear.colorImage(size: CGSize(width: 1, height: 35)), for: .normal, barMetrics: .default)
            
            base.setBackgroundImage(tiniColorImg, for: .selected, barMetrics: .default)
            base.setBackgroundImage(tiniColorImg, for: .highlighted, barMetrics: .default)
          
            /// 设置正常字体颜色
            base.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : normalextColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], for: .normal)
            
            /// 设置选中字体颜色
            base.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : selectTextColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], for: .selected)
            
            base.setDividerImage(tiniColorImg, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
            
            base.layer.borderWidth = 1
            base.layer.cornerRadius = 10
            base.layer.borderColor = color.cgColor
            base.selectedSegmentTintColor = color
        }
    }
}
