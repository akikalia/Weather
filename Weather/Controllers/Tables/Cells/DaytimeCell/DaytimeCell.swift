//
//  DaytimeCell.swift
//  Weather
//
//  Created by Alexsandre kikalia on 1/27/21.
//

import UIKit

class DaytimeCell: UITableViewCell {

    @IBOutlet var temp: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var descr: UILabel!
    @IBOutlet var icon: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
