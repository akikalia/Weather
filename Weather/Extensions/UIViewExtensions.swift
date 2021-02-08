//
//  UIViewExtensions.swift
//  Weather
//
//  Created by Alexsandre kikalia on 2/2/21.
//

import UIKit

extension UIView{
    
    func roundCorner(heightToRadiusRatio: CGFloat){
        self.layer.cornerRadius = self.frame.height / heightToRadiusRatio
        self.layer.masksToBounds = true
    }
    func setGlow(){
        self.setGlow(color: nil)
    }
    func setGlow(color: UIColor?){
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = 13
        if let color = color{
            self.layer.shadowColor = color.cgColor
        }else{
            self.layer.shadowColor = UIColor.white.cgColor
        }
        
    }
}
