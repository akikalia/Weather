//
//  UINavigationControllerExtensions.swift
//  Weather
//
//  Created by Alexsandre kikalia on 2/2/21.
//

import UIKit

extension UINavigationController{
    open override func viewDidLoad() {
        super.viewDidLoad()
        setTransparentNavbar()
    }
    
    func setTransparentNavbar(){
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true

    }
}
