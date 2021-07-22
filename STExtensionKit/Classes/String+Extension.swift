//
//  String+Extension.swift
//  YUNJI
//
//  Created by 孙涛 on 2020/3/14.
//  Copyright © 2020 孙涛. All rights reserved.
//

import Foundation

protocol StringType {
    var getStr:String { get }
}

/// 可选字符串空判断
extension Optional where Wrapped: StringType {
    /// true 空
    var strIsEmpty: Bool {
        if let str = self?.getStr {
            return str.isEmpty
        }
        return true
    }
}

extension String: StringType {
    var getStr: String {
        return self
    }
}
extension String: STCompatible {}
extension ST where Base == String {

    /// 转换为二进制数组
    func toData() -> Data {
        return base.decomposedStringWithCompatibilityMapping.data(using: .utf8)!
    }
    
    static func getHexStrWithUInt8(arr: [UInt8]) -> String {
        var result = ""
        for value in arr {
            let str = toHex(Int(value))
            result += (str ?? "")
        }
        return result
    }

    // 十进制转换成十六进制
    static func toHex(_ num: Int) -> String? {
        let result = String(format: "%llx", num)
        if num == 0 {
            return "00"
        }
        if num < 0 {
            return (String(result.uppercased().dropFirst(14)))
        } else {
            if num < 16 {
                return "0" + result.uppercased()
            } else {
                return result.uppercased()
            }
        }
    }

    // MARK: 随机字符串
    static func getRandomStr(len : Int, random_str_characters: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ") -> String{
        var ranStr = ""
        for _ in 0..<len {
            let index = Int(arc4random_uniform(UInt32(random_str_characters.count)))
            ranStr.append(random_str_characters[random_str_characters.index(random_str_characters.startIndex, offsetBy: index)])
        }
        return ranStr
    }
    
    /// 生成随机密码
    static func getPwdRandomStr(minLen: Int, maxLen: Int) -> String {
        var len = Int(arc4random_uniform(UInt32(maxLen-minLen))) + minLen
        if len < 6 { len = 6 }
        let first = getRandomStr(len: 1, random_str_characters: "0123456789")
        let second = getRandomStr(len: 1, random_str_characters: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
        var text = getRandomStr(len: len - 2)
        
        text.insert(contentsOf: first, at: text.startIndex)
        text.insert(contentsOf: second, at: text.startIndex)
        return text
    }
    
    /// URL 编码
    func URLEncode() -> String? {
        let allowedCharacters = base.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: ":&=\"#%/<>?@\\^`{|}").inverted) ?? ""
        return allowedCharacters
    }
    
    /// JSONString转换为字典
    /// - Parameter jsonString: json
    /// - Returns: dic
    func getDictionaryAboutJSONString() -> [String: Any]? {
        let jsonData:Data = base.data(using: .utf8)!
        do {
            let dict = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
            return dict as? [String: Any]

        } catch let error {
            print(error)
            return nil
        }
    }
    
    /// 获取用于Label显示的富文本字符串
    func getHtmlAttributedText(font: UIFont = UIFont.systemFont(ofSize: 13), textColor: UIColor?, lineSpacing: CGFloat = 4) -> NSAttributedString? {
        do {
            let attrText = try NSMutableAttributedString(data: base.data(using: .unicode) ?? Data(), options: [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil)
            
            /// 行间距
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpacing
            paragraphStyle.lineBreakMode = .byTruncatingTail
    
            let range = NSRange(location: 0, length: attrText.string.count)
            attrText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
//            attrText.addAttribute(NSAttributedString.Key.font, value: font, range: range)
            
            if let color = textColor {
                attrText.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
            }
            
            return attrText
        } catch  {
            return nil
        }
    }

    /// 从某个位置开始截取：
    /// - Parameter index: 起始位置
    func substring(from index: Int) -> String {
        if(base.count > index){
            let startIndex = base.index(base.startIndex,offsetBy: index)
            let subString = base[startIndex..<base.endIndex];
            return String(subString);
        }else{
            return ""
        }
    }
    
    /// 从零开始截取到某个位置：
    /// - Parameter index: 达到某个位置
    func substring(to index: Int) -> String {
        if(base.count > index){
            let endindex = base.index(base.startIndex, offsetBy: index)
            let subString = base[base.startIndex..<endindex]
            return String(subString)
        }else{
            return base
        }
    }
    
    /// 某个范围内截取
    /// - Parameter rangs: 范围
    func subString(rang rangs: NSRange) -> String{
        var string = String()
        if(rangs.location >= 0) && (base.count > (rangs.location + rangs.length)){
            let startIndex = base.index(base.startIndex,offsetBy: rangs.location)
            let endIndex = base.index(base.startIndex,offsetBy: (rangs.location + rangs.length))
            let subString = base[startIndex..<endIndex]
            string = String(subString)
        }
        return string
    }
        
    /// 获取小数点后两位。没有的自动拼接
    /// - Returns: 返回结果
    func geTwoDecimalString() -> String {
        guard !base.isEmpty else { return "" }
        
        let arr = base.components(separatedBy: ".")
        if arr.count <= 1 {
            return base + ".00"
        }
        if arr.count > 2 {
            return base
        }
        
        let lastStr = arr.last
        if lastStr?.count == 1 {
            return base + "0"
        }
        
        if lastStr?.count == 2 {
            return base
        }
        
        let roundingBehavior = NSDecimalNumberHandler(roundingMode: .plain, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        let aDN = NSDecimalNumber(string: base)
        let resultDN = aDN.rounding(accordingToBehavior: roundingBehavior)
        return "\(resultDN)".st.geTwoDecimalString()
    }
    
    // MARK: - 字符串高度计算 计算文字高度或者宽度与weight参数无关
    func widthForComment(fontSize: CGFloat, height: CGFloat = 15) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: base).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.width)
    }
    
    func heightForComment(fontSize: CGFloat, width: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: base).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.height)
    }
    
    func heightForComment(fontSize: CGFloat, width: CGFloat, maxHeight: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: base).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.height)>maxHeight ? maxHeight : ceil(rect.height)
    }
    
    // MARK: - 阅读文章详情页 Html
    /// 阅读文章详情页 Html
    /// - Parameters:
    ///   - htmlUrl: html地址
    ///   - logoUrl: logo url
    ///   - time: 发布时间
    ///   - nick_name: 昵称
    ///   - title: 标题
    ///   - content: 内容
    ///   - isnotice: 是否关注
    ///   - isPerson: 是否是个人认证
    ///   - isCompany: 是否是企业认证
    /// - Returns: 展示的Html
    static func getArticalDetailHtml(htmlUrl: URL, logoUrl: String?, time: String?, nick_name: String?, title: String?, content: String?, isShowNotice: Bool, isnotice: Bool, isPerson: Bool, isCompany: Bool) -> String? {
        do {
            let urlString = try String(contentsOf: htmlUrl, encoding: String.Encoding.utf8)
            /// logo 路径
            let logouUrl = logoUrl ?? "-1"
            var html = urlString.replacingOccurrences(of: "%1$s", with: logouUrl)
            /// 昵称
            html = html.replacingOccurrences(of: "%3$s", with: nick_name ?? "无昵称")
            /// 昵称 字体颜色
            html = html.replacingOccurrences(of: "%5$s", with: "000000")
            /// 创建时间
            let time = "\(time ?? "\(Date.st.getTimeInterval()))")"
            html = html.replacingOccurrences(of: "%6$s", with: time)
            /// 创建时间颜色
            html = html.replacingOccurrences(of: "%8$s", with: "999999")
            /// 标题
            html = html.replacingOccurrences(of: "%9$s", with: title ?? "")
            /// 标题颜色
            html = html.replacingOccurrences(of: "%11$s", with: "000000")
            /// 内容
            html = html.replacingOccurrences(of: "%12$s", with: content ?? "")
            /// 字体大小
            html = html.replacingOccurrences(of: "%13$d", with: "17")
            /// 内容颜色
            html = html.replacingOccurrences(of: "%14$s", with: "000000")
            /// 连接颜色 （点击跳转）
            html = html.replacingOccurrences(of: "%15$s", with: "0000ff")
            /// 间距
            html = html.replacingOccurrences(of: "%16$d", with: "10")
            /// 是否关注 (-1 隐藏关注按钮)
            var isnoticeStr = isnotice ? "true" : "false"
            if !isShowNotice {
                isnoticeStr = "-1"
            }
            html = html.replacingOccurrences(of: "%17$s", with: isnoticeStr)
            
            /// 是否企业账号
            var isCompanyStr = "0"
            if isPerson {
                isCompanyStr = "1"
            }
            if isCompany {
                isCompanyStr = "2"
            }
            html = html.replacingOccurrences(of: "%18$s", with: isCompanyStr)
            
            /// 百分号
            html = html.replacingOccurrences(of: "%%", with: "%")
            /// 图片加载过程中
            var logovPath = Bundle.main.path(forResource: "logov", ofType: "png", inDirectory: "YJReadDetailHtml")
            logovPath = logovPath?.replacingOccurrences(of: "/", with: "//")
            logovPath = logovPath?.replacingOccurrences(of: " ", with: "%20")
            if ((logovPath?.contains("logov.png")) != nil) {
                logovPath = logovPath?.st.substring(to: logovPath!.count - 10)
            }
            html = html.replacingOccurrences(of: "%19$s", with: logovPath ?? "")
            return html
        } catch let error {
            debugPrint("发布富文本编辑获取本地路径失败 \(error)")
            return nil
        }
    }
    
    /// 阅读页H5头
    static func getReadDetailHtml(html: String) -> String {
       let str = """
                <!DOCTYPE html>
                <html>
                <head>
                <meta charset=\"utf-8\">
                <meta name=\"viewport\" content=\"width=device-width, initial-scale=1,maximum-scale=1,minimum-scale=1,user-scalable=no\">
                <meta name=\"apple-mobile-web-app-capable\" content=\"yes\">
                <meta name=\"apple-mobile-web-app-status-bar-style\" content=\"black\">
                <title>标题</title>
                <style type=\"text/css\">
                body {
                font-size: 14pt;
                margin: 0px 14px 0px 14px;
                line-height:1.6;
                color: #000000;
                table-layout:fixed;
                word-wrap:break-word;
                word-break:break-word;
                }
                span{
                display:inline !important
                }
                a {color: #000000;text-decoration:none}
                img {display: inline-block; height: auto !important; max-width: 100% !important; margin: 5px 0px 5px 0px !important;}
                pre {white-space: pre-wrap;}
                iframe {width: 90vw; height: 50.625vw;} /* 16:9 */
                </style>
                </head>
                <body>\(html)</body>
                </html>
                """
        return str
    }
    
    /// 消息页面
    static func getCustomelHtml(html: String, font: Int = 14) -> String {
       let str = """
                <!DOCTYPE html>
                <html>
                <head>
                <meta charset="utf-8">
                <meta name="viewport" content="width=device-width, initial-scale=1,maximum-scale=1,minimum-scale=1,user-scalable=no">
                <meta name="apple-mobile-web-app-capable" content="yes">
                <meta name="apple-mobile-web-app-status-bar-style" content="black">
                <title>标题</title>
                    <style type="text/css">
                        .div {
                            font-size: \(font)pt;
                            line-height: 1.6;
                            margin: 0px 14px 0px 14px;
                            line-height: 1.5;
                            color: #151518;
                        }

                        a {
                            color: #000000;
                            text-decoration: none
                        }

                        img {
                            display: inline;
                            height: auto;
                            max-width: 100%;
                            margin: 1px 0px 1px 0px !important;
                        }

                        pre {
                            white-space: pre-wrap;
                        }

                        iframe {
                            width: 90vw;
                            height: 50.625vw;
                        }

                        /* 16:9 */
                    </style>
                </head>
                <body><div class="div">\(html)</div></body>
                </html>
                """
        return str
    }
}


