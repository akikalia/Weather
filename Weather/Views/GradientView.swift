//
//  GradientView.swift
//  Weather
//
//  Created by Alexsandre kikalia on 2/6/21.
//

import UIKit

class GradientView: UIView{

    var gradientLayer: CAGradientLayer?
    var top = UIColor.white
    var bottom = UIColor.white
    
    func setGradientBG(top: UIColor?, bottom: UIColor?) {
        if let top = top{
            if let bottom = bottom{
                self.top = top
                self.bottom = bottom
                gradientLayer = CAGradientLayer()
                gradientLayer!.colors = [top.cgColor, bottom.cgColor]
                gradientLayer!.locations = [0.0, 1.0]
                gradientLayer!.frame = self.bounds
    //                self.backgroundColor = .clear
                self.layer.insertSublayer(gradientLayer!, at:0)
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateGradient(nil, nil)
    }
    func updateGradient(_ top: UIColor?,_ bottom: UIColor?){
        if let gradient = gradientLayer{
            if let top = top?.cgColor{
                if let bottom = bottom?.cgColor{
                    gradient.colors = [top, bottom]
                }
            }
            gradient.frame = self.bounds
        }
    }
}
