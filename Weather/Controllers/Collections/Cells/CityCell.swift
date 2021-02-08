//
//  CityCell.swift
//  Weather
//
//  Created by Alexsandre kikalia on 1/28/21.
//

import UIKit

protocol CityCellDelegate: AnyObject{
    func cityCellDelegateLongPress(_ sender: CityCell, name: String?, row: Int)
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
    @IBOutlet var primaryConstraint: NSLayoutConstraint!
    @IBOutlet var cornerView: UIView!
    @IBOutlet var gradientView: GradientView!
    
    var top: UIColor?
    var bottom: UIColor?
    var city: String?
    
    var row: Int = 0{
        didSet {
            setColor()
        }
    }
    
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
        cornerView.backgroundColor = .clear
        wrapperView.backgroundColor = .clear
        setColor()
        gradientView.setGradientBG(top: top, bottom: bottom)
        setSecondary()
        self.clipsToBounds = false
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        cornerView.roundCorner(heightToRadiusRatio: 13)
        gradientView.updateGradient(top, bottom)
    }
    
    
    func setColor(){
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
        gradientView.updateGradient(top, bottom)
        wrapperView.setGlow(color: bottom)
    }
    
    func setSecondary(){
        primaryConstraint.isActive = false
    }
    func setPrimary(){
        primaryConstraint.isActive = true
        
    }
    
    @objc
    func handleTouchDown(_ sender: UILongPressGestureRecognizer? = nil) {
       if sender?.state == .began{
        delegate?.cityCellDelegateLongPress(self, name: city, row: row)
       }
    }
    
}
