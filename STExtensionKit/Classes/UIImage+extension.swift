//
//  UIImage+Extension.swift
//  YUANJI
//
//  Created by 孙涛 on 2021/3/1.
//

import Foundation
import UIKit

extension UIImage: STCompatible {}
extension ST where Base == UIImage {
    public static func imageWithColor(color: UIColor = .white) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? nil
    }
}
