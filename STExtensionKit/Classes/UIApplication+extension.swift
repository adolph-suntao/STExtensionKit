//
//  UIApplication+extension.swift
//  YUANJI
//
//  Created by 孙涛 on 2021/3/1.
//

import Foundation

public extension UIApplication {
    func clearLaunchScreenCache() {
        let path = NSHomeDirectory()+"/Library/SplashBoard"
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: path) {
            do {
                try FileManager.default.removeItem(atPath: path)
            } catch {
                print("Failed to delete launch screen cache: \(error)")
            }
        }
    }
}
