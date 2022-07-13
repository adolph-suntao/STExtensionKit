//
//  UIImage+Extension.swift
//  YUANJI
//
//  Created by 孙涛 on 2021/3/1.
//

import Foundation
import UIKit

extension UIImage: STCompatible {}

public extension ST where Base == UIImage {

    
    /// 向Image添加圆角
    /// - Parameters:
    ///   - corners: 圆角位置
    ///   - radius: 半径
    ///   - sizetoFit: Image 的 Size
    /// - Returns: 添加圆角之后的结果
    func drawRectWithRoundedCorner(corners: UIRectCorner, radius: CGFloat, sizetoFit: CGSize) -> UIImage? {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: sizetoFit)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return base
        }
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        context.addPath(UIBezierPath(roundedRect: rect, byRoundingCorners: corners,
                                     cornerRadii: CGSize(width: radius, height: radius)).cgPath)
        UIGraphicsGetCurrentContext()?.clip()
        
        base.draw(in: rect)
        context.drawPath(using: .fillStroke)
        let output = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return output
    }
    
    // MARK: - 颜色转图片
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
    
    // MARK: - 仿微信压缩图片
    
    public enum WechatCompressType {
        case session
        case timeline
    }
    
    /**
     wechat image compress
     - parameter type: session image boundary is 800, timeline is 1280
     
     - returns: thumb image
     */
    func wxCompress(type: WechatCompressType = .timeline) -> UIImage {
        let size = self.wxImageSize(type: type)
        let reImage = resizedImage(size: size)
        let data = reImage.jpegData(compressionQuality: 0.5)!
        return UIImage.init(data: data)!
    }
    func wxCompress(type: WechatCompressType = .timeline) -> Data? {
        let size = self.wxImageSize(type: type)
        let reImage = resizedImage(size: size)
        let data = reImage.jpegData(compressionQuality: 0.5)
        return data
    }

    /**
     get wechat compress image size
     
     - parameter type: session  / timeline
     
     - returns: size
     */
    private func wxImageSize(type: WechatCompressType) -> CGSize {
        var width = base.size.width
        var height = base.size.height
        
        var boundary: CGFloat = 1280
        
        // width, height <= 1280, Size remains the same
        guard width > boundary || height > boundary else {
            return CGSize(width: width, height: height)
        }
        
        // aspect ratio
        let s = max(width, height) / min(width, height)
        if s <= 2 {
            // Set the larger value to the boundary, the smaller the value of the compression
            let x = max(width, height) / boundary
            if width > height {
                width = boundary
                height /= x
            } else {
                height = boundary
                width /= x
            }
        } else {
            // width, height > 1280
            if min(width, height) >= boundary {
                boundary = type == .session ? 800 : 1280
                // Set the smaller value to the boundary, and the larger value is compressed
                let x = min(width, height) / boundary
                if width < height {
                    width = boundary
                    height /= x
                } else {
                    height = boundary
                    width /= x
                }
            }
        }
        return CGSize(width: width, height: height)
    }
    
    /**
     Zoom the picture to the specified size
     - parameter newSize: image size
     
     - returns: new image
     */
    private func resizedImage(size: CGSize) -> UIImage {
        let newRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        var newImage: UIImage!
        UIGraphicsBeginImageContext(newRect.size)
        newImage = UIImage(cgImage: base.cgImage!, scale: 1, orientation: base.imageOrientation)
        newImage.draw(in: newRect)
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
