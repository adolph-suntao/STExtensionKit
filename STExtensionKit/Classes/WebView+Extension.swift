//
//  WebView+Extension.swift
//  YUANJI
//
//  Created by 孙涛 on 2020/8/5.
//  Copyright © 2020 孙涛. All rights reserved.
//

import Foundation
import WebKit

extension WKWebView: STCompatible {}
extension ST where Base == WKWebView {
    /// 动态修改字体大小
    public func changeFontSize(scal: Int)  {
        let fontSize = "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '\(scal)%'"
        base.evaluateJavaScript(fontSize, completionHandler: nil)
    }
}
