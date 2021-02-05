//
//  ErrorView.swift
//  Weather
//
//  Created by Alexsandre kikalia on 1/30/21.
//

import UIKit

protocol ErrorViewDelegate: AnyObject{
    func errorViewButtonTap(sender: ErrorView)
}

class ErrorView: BaseReusableView{
    
    @IBOutlet var button: UIButton!
    
    weak var delegate: ErrorViewDelegate?
    
    override func setup(){
        
    }
    
    func roundButton(){
        button.roundCorner(heightToRadiusRatio: 5)
    }
    
    @IBAction func handleButtonTap() {
        delegate?.errorViewButtonTap(sender: self)
    }
}
