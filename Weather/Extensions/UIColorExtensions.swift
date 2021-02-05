//
//  ColorExtensions.swift
//  Weather
//
//  Created by Alexsandre kikalia on 2/2/21.
//

import UIKit

extension UIColor{
    class var bgStart :UIColor {
        return UIColor.init(named: "bg-gradient-start") ?? .white
        
    }
    class var bgEnd :UIColor {
        return UIColor.init(named: "bg-gradient-end") ?? .white
    }
    class var blueStart :UIColor {
        return UIColor.init(named: "blue-gradient-start") ?? .blue
        
    }
    class var blueEnd :UIColor {
        return UIColor.init(named: "blue-gradient-end") ?? .blue
    }
    class var greenStart :UIColor {
        return UIColor.init(named: "green-gradient-start") ?? .green
        
    }
    class var greenEnd :UIColor {
        return UIColor.init(named: "green-gradient-end") ?? .green
    }
    class var ochreStart :UIColor {
        return UIColor.init(named: "ochre-gradient-start") ?? .red
        
    }
    class var ochreEnd :UIColor {
        return UIColor.init(named: "ochre-gradient-end") ?? .red
    }
    class var accent :UIColor {
        return UIColor.init(named: "accent") ?? .accent
    }
}
