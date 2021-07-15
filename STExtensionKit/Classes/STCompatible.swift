//
//  STCompatible.swift
//  YUANJI
//
//  Created by 孙涛 on 2021/5/8.
//  Copyright © 2021 孙涛. All rights reserved.
//

import Foundation

/// 面向协议编程，增加前缀  https://juejin.cn/post/6959726335207931918
public struct ST<Base> {
    var base: Base
    init(_ base: Base) {
        self.base = base
    }
}

public protocol STCompatible { }
extension STCompatible {
    public var st: ST<Self> {
        ST(self)
    }
    public static var st: ST<Self>.Type {
        ST<Self>.self
    }
}
