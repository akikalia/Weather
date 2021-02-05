//
//  CityCell.swift
//  Weather
//
//  Created by Alexsandre kikalia on 1/28/21.
//

import UIKit

protocol CityCellDelegate: AnyObject{
    func cityCellDelegateLongPress(_ sender: CityCell, name: String?)
}

class CityCell: UICollectionViewCell {

    @IBOutlet var wrapperView: UIView!
    @IBOutlet var icon: UIImageView!
    
    @IBOutlet var location: UILabel!
    @IBOutlet var descr: UILabel!
    @IBOutlet var cloudiness: StackViewCell!
    @IBOutlet var humidity: StackViewCell!
    @IBOutlet var windSpeed: StackViewCell!
    @IBOutlet var windDirection: StackViewCell!
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    var top: UIColor?
    var bottom: UIColor?
    var city: String?
    
    var row  = -1
    
    weak var delegate: CityCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let touchDown = UILongPressGestureRecognizer(target: self, action: #selector(self.handleTouchDown(_:)))
        wrapperView.addGestureRecognizer(touchDown)
        cloudiness.icon.image = UIImage.init(named: "raining") 
        windSpeed.icon.image = UIImage.init(named: "wind")
        windDirection.icon.image = UIImage.init(named: "compass")
        humidity.icon.image = UIImage.init(named: "drop")
        cloudiness.title.text = "Cloudiness"
        windSpeed.title.text = "Wind Speed"
        windDirection.title.text = "Wind Direction"
        humidity.title.text = "Humidity"
        cloudiness.backgroundColor = .clear
        windSpeed.backgroundColor = .clear
        windDirection.backgroundColor = .clear
        humidity.backgroundColor = .clear
        self.setSecondary()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
//        initialsBGView.layer.cornerRadius = initialsBGView.frame.height / 10
        switch row % 3 {
        case 0:
            top = .greenStart
            bottom = .greenEnd
        case 1:
            top = .blueStart
            bottom = .blueEnd
        case 2:
            top = .ochreStart
            bottom = .ochreEnd
        default:
            break
        }
        wrapperView.layer.cornerRadius = wrapperView.frame.height / 18
        wrapperView.layer.masksToBounds = true
        wrapperView.backgroundColor = .clear
        wrapperView.setGradientBG(top: top, bottom: bottom)
        wrapperView.setGlow(color: top)
        
        
//        wrapperView.layer.borderWidth = 1
//        wrapperView.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    func setSecondary(){
        heightConstraint.isActive = false
    }
    func setPrimary(){
        heightConstraint.isActive = true
    }
    @objc
    func handleTouchDown(_ sender: UILongPressGestureRecognizer? = nil) {
       if sender?.state == .began{
        delegate?.cityCellDelegateLongPress(self, name: city)
       }
    }
    
}
