//
//  TodayViewController.swift
//  Weather
//
//  Created by Alexsandre kikalia on 1/27/21.
//

import UIKit

class TodayViewController: TodayCollectionController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    @IBAction func addButton(){
        
    }
}

extension TodayViewController: ACViewControllerDelegate{
    func ACViewControllerWeatherForecast(sender: AddCityViewController, weather: WeatherResponse) {
        addCity(entry: weather)
    }
}

