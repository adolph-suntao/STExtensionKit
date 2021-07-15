//
//  UITableView+extension.swift
//  News
//
//  Created by 孙涛 on 2019/12/26.
//  Copyright © 2019 孙涛. All rights reserved.
//

import UIKit

extension UITableView: STCompatible {}
extension ST where Base: UITableView {
    /// 注册cell，
    /// - Parameter cell: T.Type：获取泛型类型的元类型
    public func registerCell<T: UITableViewCell>(cell: T.Type) where T: RegisterCellOrNib {
        if T.nibPath != nil {
            base.register(T.nib, forCellReuseIdentifier: T.identifier)
       
        } else {
            base.register(cell, forCellReuseIdentifier: T.identifier)
        }
    }
    
    /// 从缓存池取出cell，
    /// - Parameter indexPath: cell位置
    /// - Returns: 取出的cell
    public func dequeueReusableCell<T: UITableViewCell>(indexPath: IndexPath) -> T where T: RegisterCellOrNib {
        return base.dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as! T
    }
}
