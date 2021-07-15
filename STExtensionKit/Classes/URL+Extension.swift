
//
//  UIKit+Extension.swift
//  YUNJI
//
//  Created by 孙涛 on 2020/2/17.
//  Copyright © 2020 孙涛. All rights reserved.
//

import UIKit

extension URL: STCompatible {}
extension ST where Base == URL {
    public var parametersFromQueryString : [String: String]? {
        guard let components = URLComponents(url: base, resolvingAgainstBaseURL: true),
        let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
}
