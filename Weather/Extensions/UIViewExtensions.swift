//
//  UIViewExtensions.swift
//  Weather
//
//  Created by Alexsandre kikalia on 2/2/21.
//

import UIKit

extension UIView{

    func setGradientBG(top: UIColor?, bottom: UIColor?) {
        if let top = top?.cgColor{
            if let bottom = bottom?.cgColor{
                let gradientLayer = CAGradientLayer()
                gradientLayer.colors = [top, bottom]
                gradientLayer.locations = [0.0, 1.0]
                gradientLayer.frame = self.bounds
                self.backgroundColor = .clear
                self.layer.insertSublayer(gradientLayer, at:0)
            }
        }
    }
    
    func roundCorner(heightToRadiusRatio: CGFloat){
        self.layer.cornerRadius = self.frame.height / heightToRadiusRatio
        self.layer.masksToBounds = true
    }
    func setGlow(){
        self.setGlow(color: nil)
    }
    func setGlow(color: UIColor?){
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = 8.0
        if let color = color{
            self.layer.shadowColor = color.cgColor
        }else{
            self.layer.shadowColor = UIColor.white.cgColor
        }
        
    }
}
