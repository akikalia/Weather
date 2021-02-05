//
//  TodayViewController.swift
//  Weather
//
//  Created by Alexsandre kikalia on 1/27/21.
//

import UIKit

class TodayViewController: TodayCollectionController {

    var addCityVC: AddCityViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addCityVC = self.storyboard?.instantiateViewController(identifier: "AddCityVC")
        addCityVC?.delegate = self
        errorView.delegate = self
        // Do any additional setup after loading the view.
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.setGradientBG(top: UIColor.bgStart, bottom: UIColor.bgEnd)
        
        errorView.roundButton()
    }
    
    

    
    @IBAction func addButton(){
        self.modalPresentationStyle = .fullScreen
        if let addCityVC = addCityVC{
            self.present(addCityVC, animated: true, completion: nil)
        }
    }
    @IBAction func refreshButton(){
        reload()
    }
}
extension TodayViewController: ACViewControllerDelegate{
    func ACViewControllerWeatherForecast(sender: AddCityViewController, weather: WeatherResponse) {
        addCity(entry: weather)
    }
}

extension TodayViewController: ErrorViewDelegate{
    func errorViewButtonTap(sender: ErrorView) {
        reload()
    }
}
