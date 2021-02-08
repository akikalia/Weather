//
//  UITabBarControllerExtensions.swift
//  Weather
//
//  Created by Alexsandre kikalia on 2/2/21.
//

import UIKit

extension UITabBar{
//    open override func viewDidLoad() {
//        super.viewDidLoad()
//        UITabBar.appearance().barTintColor = .clear
//        let appearance = UITabBarAppearance()
//        appearance.backgroundColor = .clear
//        appearance.backgroundImage = UIImage()
//        appearance.backgroundEffect = .none
//        appearance.shadowImage = UIImage()
//        appearance.clipsTo
//        self.tabBar.standardAppearance = appearance
//        self.tabBar.
//        UITabBar.appearance().backgroundImage = UIImage()
//          UITabBar.appearance().shadowImage  = UIImage()
//          UITabBar.appearance().clipsToBounds   = true
//
//        UITabBar.appearance().backgroundColor = .clear
//    }
    static func setCustomTabbar() {
        appearance().unselectedItemTintColor = .white
        setTransparentTabbar()
    }
    static func setTransparentTabbar() {
      appearance().backgroundImage = UIImage()
      appearance().shadowImage     = UIImage()
      appearance().clipsToBounds   = true
     }
}
