//
//  UIKit+Protocol.swift
//  YUNJI
//
//  Created by 孙涛 on 2020/2/17.
//  Copyright © 2020 孙涛. All rights reserved.
//

import UIKit

public protocol NibLoadable {}

extension NibLoadable {
    public static func loadViewFromNib() -> Self {
        return Bundle.main.loadNibNamed("\(self)", owner: nil, options: nil)?.first as! Self
    }
    
    public static func loadViewFromStoryboard(storyboardName: String = "Main", identifier: String?) -> Self {
        var identifier = identifier
        if identifier == nil {
            identifier = "\(self)"
        }
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: identifier!)
        return vc as! Self
    }

}

/// 注册
public protocol RegisterCellOrNib {}

extension RegisterCellOrNib {
    public static var identifier: String {
        return "\(self)"
    }
    
    public static var nibPath: String? {
        return Bundle.main.path(forResource: "\(self)", ofType: "nib")
    }
    
    public static var nib: UINib? {
        return UINib(nibName: "\(self)", bundle: nil)
    }
}

public protocol Copyable {
    associatedtype T
    func copyable() -> T
}
