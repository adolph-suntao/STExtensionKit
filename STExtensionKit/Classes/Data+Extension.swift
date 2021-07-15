//
//  Data+Extension.swift
//  YUANJI
//
//  Created by 孙涛 on 2020/6/8.
//  Copyright © 2020 孙涛. All rights reserved.
//

import Foundation

public enum ImageFormat {
    case Unknow
    case JPEG
    case JPG
    case PNG
    case GIF
    case TIFF
    case WebP
    case HEIC
    case HEIF
}

extension Data: STCompatible {}
extension ST where Base == Data {
    /// data类型数据转十进制数组
    public static func convertBytesToBase(_ bytes: Data) -> [UInt8] {
        let base: Int = 256
        var length = 0
        let size = sizeFromByte(size: bytes.count)
        var encodedBytes: [UInt8] = Array(repeating: 0, count: size)
        
        for b in bytes {
            var carry = Int(b)
            var i = 0
            for j in (0...encodedBytes.count - 1).reversed() where carry != 0 || i < length {
                carry += 256 * Int(encodedBytes[j])
                encodedBytes[j] = UInt8(carry % base)
                carry /= base
                i += 1
            }
            
            assert(carry == 0)
            
            length = i
        }
        
        var zerosToRemove = 0
        for b in encodedBytes {
            if b != 0 { break }
            zerosToRemove += 1
        }
        
        encodedBytes.removeFirst(zerosToRemove)
        return encodedBytes
    }
    
    fileprivate static func sizeFromByte(size: Int) -> Int {
        return size * 138 / 100 + 1
    }

    public func getImageFormat() -> ImageFormat  {
        var buffer = [UInt8](repeating: 0, count: 1)
        base.copyBytes(to: &buffer, count: 1)
        
        switch buffer {
        case [0xFF]: return .JPEG
        case [0x89]: return .PNG
        case [0x47]: return .GIF
        case [0x49],[0x4D]: return .TIFF
        case [0x52] where base.count >= 12:
            if let str = String(data: base[0...11], encoding: .ascii), str.hasPrefix("RIFF"), str.hasSuffix("WEBP") {
                return .WebP
            }
        case [0x00] where base.count >= 12:
            if let str = String(data: base[8...11], encoding: .ascii) {
                let HEICBitMaps = Set(["heic", "heis", "heix", "hevc", "hevx"])
                if HEICBitMaps.contains(str) {
                    return .HEIC
                }
                let HEIFBitMaps = Set(["mif1", "msf1"])
                if HEIFBitMaps.contains(str) {
                    return .HEIF
                }
            }
        default: break;
        }
        return .Unknow
    }
    
    public var fitSampleCount:Int{
        guard let imageSource = CGImageSourceCreateWithData(base as CFData, [kCGImageSourceShouldCache: false] as CFDictionary) else {
            return 1
        }
        
        let frameCount = CGImageSourceGetCount(imageSource)
        var sampleCount = 1
        switch frameCount {
        case 2..<8:
            sampleCount = 2
        case 8..<20:
            sampleCount = 3
        case 20..<30:
            sampleCount = 4
        case 30..<40:
            sampleCount = 5
        case 40..<Int.max:
            sampleCount = 6
        default:break
        }
        
        return sampleCount
    }
    
    public var imageSize:CGSize{
        guard let imageSource = CGImageSourceCreateWithData(base as CFData, [kCGImageSourceShouldCache: false] as CFDictionary),
            let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [AnyHashable: Any],
            let imageHeight = properties[kCGImagePropertyPixelHeight] as? CGFloat,
            let imageWidth = properties[kCGImagePropertyPixelWidth] as? CGFloat else {
                return .zero
        }
        return CGSize(width: imageWidth, height: imageHeight)
    }
    
    public var imageFormat:ImageFormat {
        var headerData = [UInt8](repeating: 0, count: 3)
        base.copyBytes(to: &headerData, from:(0..<3))
        let hexString = headerData.reduce("") { $0 + String(($1&0xFF), radix:16) }.uppercased()
        var imageFormat = ImageFormat.Unknow
        switch hexString {
        case "FFD8FF":
            imageFormat = .JPG
        case "89504E":
            imageFormat = .PNG
        case "474946":
            imageFormat = .GIF
        default:break
        }
        return imageFormat
    }
}
