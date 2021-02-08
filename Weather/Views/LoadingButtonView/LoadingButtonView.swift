//
//  CallButtonView.swift
//  Dial Pad
//
//  Created by Alexsandre kikalia on 11/19/20.
//

import UIKit

protocol LoadingButtonViewDelegate: AnyObject {
    func loadingButtonViewDidTapButton(_ sender: LoadingButtonView)
}

class LoadingButtonView : BaseReusableView{
    
    weak var delegate: LoadingButtonViewDelegate? {
        didSet {
            setup()
        }
    }
    
    @IBOutlet var buttonView: UIButton!
    @IBOutlet var loader: UIActivityIndicatorView!
    var plusImage :UIImage?
    override func setup() {
        plusImage = buttonView.currentImage
        self.bringSubviewToFront(loader)
    }
    
    func startLoading(){
        buttonView.isEnabled = false
        buttonView.setImage(UIImage(), for: .normal)
        loader.startAnimating()
    }
    
    func stopLoading(){
        sleep(5)
        buttonView.isEnabled = true
        if let plusImage = plusImage{
            buttonView.setImage(plusImage, for: .normal)
            
        }
        loader.stopAnimating()
    } 
    
    func setColor(color: UIColor){
        buttonView.backgroundColor = color
    }
    
    func roundButton(){
        buttonView.layer.cornerRadius = buttonView.frame.height / 2
        buttonView.layer.masksToBounds = true
    }

    @IBAction func handleButtonTap() {
        startLoading()
        delegate?.loadingButtonViewDidTapButton(self)
    
    }
}


