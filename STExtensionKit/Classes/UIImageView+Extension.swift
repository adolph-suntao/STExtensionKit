//
//  UIImage+Extension.swift
//  YUANJI
//
//  Created by 孙涛 on 2020/6/13.
//  Copyright © 2020 孙涛. All rights reserved.
//

import Foundation

extension UIImageView: STCompatible {}
extension ST where Base == UIImageView {
    /// 播放gif
    /// - Parameter name: <#name description#>
    public func startGifWithImageName(name:String) {
        guard let path = Bundle.main.path(forResource: name, ofType: "gif") else {
//            dPrint(content: "SwiftGif: Source for the image does not exist")
            return
        }
        self.startGifWithFilePath(filePath: path)
    }
    
    /// 播放gif
    /// - Parameter filePath: gif 路径
    public func startGifWithFilePath(filePath:String) {
        /// 1.加载GIF图片，并转化为data类型
        guard let data = NSData(contentsOfFile: filePath) else {return}
        /// 2.从data中读取数据，转换为CGImageSource
        guard let imageSource = CGImageSourceCreateWithData(data, nil) else {return}
        let imageCount = CGImageSourceGetCount(imageSource)
        /// 3.遍历所有图片
        var images = [UIImage]()
        var totalDuration : TimeInterval = 0
        for i in 0..<imageCount {
            /// 3.1取出图片
            guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, nil) else {continue}
            let image = UIImage(cgImage: cgImage)
            images.append(image)
            
            /// 3.2取出持续时间
            guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil)  else {continue}
            let propertiesDic = NSDictionary(dictionary: properties)
            
            guard let gifDict = propertiesDic[kCGImagePropertyGIFDictionary]  as? NSDictionary else  {continue}
            guard let frameDuration = gifDict[kCGImagePropertyGIFDelayTime] as? NSNumber else {continue}
            totalDuration += frameDuration.doubleValue
        }
        
        /// 4.设置imageview的属性
        self.base.animationImages = images
        self.base.animationDuration = totalDuration
        /// 设置播放一次
        self.base.animationRepeatCount = 0
        
        /// 5.开始播放
        self.base.startAnimating()
    }
    
    public func stopGifAnimating() {
        self.base.stopAnimating()
    }
}
