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
        setTitleColor(color: UIColor.white)
    }
    
    func setTransparentNavbar(){
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true

    }
    func setTitleColor(color: UIColor){
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: color]
    }
}
