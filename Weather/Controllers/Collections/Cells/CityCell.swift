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
    @IBOutlet var icon: UIImage!
    
    @IBOutlet var location: UILabel!
    @IBOutlet var descr: UILabel!
    @IBOutlet var cloudiness: UILabel!
    @IBOutlet var cloudinessIcon: UIImage!
    @IBOutlet var humidity: UILabel!
    @IBOutlet var humidityIcon: UIImage!
    @IBOutlet var windSpeed: UILabel!
    @IBOutlet var windSpeedIcon: UIImage!
    @IBOutlet var windDirection: UILabel!
    @IBOutlet var windDirectionIcon: UIImage!
    
    var city: String?
    
    
    
    weak var delegate: CityCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let touchDown = UILongPressGestureRecognizer(target: self, action: #selector(self.handleTouchDown(_:)))
        wrapperView.addGestureRecognizer(touchDown)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
//        initialsBGView.layer.cornerRadius = initialsBGView.frame.height / 2
//        wrapperView.layer.cornerRadius = 10
//        wrapperView.layer.borderWidth = 1
//        wrapperView.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    @objc
    func handleTouchDown(_ sender: UILongPressGestureRecognizer? = nil) {
       if sender?.state == .began{
        delegate?.cityCellDelegateLongPress(self, name: city)
       }
    }
}
