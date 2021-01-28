//
//  CarouselPageView.swift
//  Weather
//
//  Created by Alexsandre kikalia on 1/27/21.
//

import UIKit
//
//protocol CarouselPageViewDelegate: AnyObject {
//    func callButtonViewDidTapButton(_ sender: CallButtonView)
//}

class CarouselPageView : BaseReusableView{
    
//    weak var delegate: CarouselPageViewDelegate? {
//        didSet {
//            setup()
//        }
//    }
    
    @IBOutlet weak var buttonView: UIButton!

    
    override func setup() {
        buttonView.layer.cornerRadius = buttonView.frame.height / 2
        buttonView.layer.masksToBounds = true
    }
    
    func roundButton(){
        buttonView.layer.cornerRadius = buttonView.frame.height / 2
        buttonView.layer.masksToBounds = true
    }

    @IBAction func handleButtonTap() {
    
    }

    
    
}


