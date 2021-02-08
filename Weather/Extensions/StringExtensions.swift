//
//  StringExtensions.swift
//  Weather
//
//  Created by Alexsandre kikalia on 2/5/21.
//

import Foundation
extension String{
    func capitalizedFirstLetter() -> String {
        let first = String(self.prefix(1)).capitalized
        let other = String(self.dropFirst())
        return first + other
    }
}
