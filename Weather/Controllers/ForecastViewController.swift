//
//  ForecastViewController.swift
//  Weather
//
//  Created by Alexsandre kikalia on 1/27/21.
//

import UIKit

class ForecastViewController: ForecastTableController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let gradientView = self.view as? GradientView{
            gradientView.setGradientBG(top: .bgStart, bottom: .bgEnd)
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func refreshButton(){
        fetchForecast()
    }
    
}


extension ForecastViewController: ErrorViewDelegate{
    func errorViewButtonTap(sender: ErrorView) {
        fetchForecast()
    }
}

