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
    
    override func setup() {
        loader.isHidden = true
    }
    
    func startLoading(){
        loader.isHidden = false
        loader.startAnimating()
        buttonView.imageView?.isHidden = true
    }
    
    func stopLoading(){
        loader.isHidden = true
        loader.stopAnimating()
        buttonView.imageView?.isHidden = false
    } 
    
    func setColor(color: UIColor){
        buttonView.backgroundColor = color
    }
    
    func roundButton(){
        buttonView.layer.cornerRadius = buttonView.frame.height / 2
        buttonView.layer.masksToBounds = true
    }

    @IBAction func handleButtonTap() {
        if loader.isHidden{
            startLoading()
            delegate?.loadingButtonViewDidTapButton(self)
        }
    }
}


