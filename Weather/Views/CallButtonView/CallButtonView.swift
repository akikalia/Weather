//
//  CallButtonView.swift
//  Dial Pad
//
//  Created by Alexsandre kikalia on 11/19/20.
//

import UIKit

protocol CallButtonViewDelegate: AnyObject {
    func callButtonViewDidTapButton(_ sender: CallButtonView)
}

class CallButtonView : BaseReusableView{
    
    weak var delegate: CallButtonViewDelegate? {
        didSet {
            setup()
        }
    }
    
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
        delegate?.callButtonViewDidTapButton(self)
    }

    
    
}


