//
//  UICollectionView+extension.swift
//  News
//
//  Created by 孙涛 on 2019/12/26.
//  Copyright © 2019 孙涛. All rights reserved.
//

import UIKit

extension UICollectionView: STCompatible {}
extension ST where Base == UICollectionView {
    public func registerCell<T: UICollectionViewCell>(cell: T.Type) where T: RegisterCellOrNib {
        if T.nibPath != nil {
            base.register(T.nib, forCellWithReuseIdentifier: T.identifier)
       
        } else {
            base.register(cell, forCellWithReuseIdentifier: T.identifier)
        }
    }
    
    public func dequeueReusableCell<T: UICollectionViewCell>(indexPath: IndexPath) -> T where T: RegisterCellOrNib {
        return base.dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as! T
    }
}
