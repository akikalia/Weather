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
        if let gradientView = self.view as? GradientView{
            gradientView.setGradientBG(top: .bgStart, bottom: .bgEnd)
        }
        addCityVC = self.storyboard?.instantiateViewController(identifier: "AddCityVC")
        addCityVC?.delegate = self
        errorView.delegate = self
//        let forecastVC: ForecastViewController? = self.storyboard?.instantiateViewController(identifier: "forecastVC")
//        forecastVC?.delegate = self
        // Do any additional setup after loading the view.
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        errorView.roundButton()
    }
    
    

    
    @IBAction func addButton(){
        
        if let addCityVC = addCityVC{
            addCityVC.modalPresentationStyle = .overFullScreen
            self.present(addCityVC, animated: true, completion: nil)
        }
    }
    @IBAction func refreshButton(){
        reload(nil)
    }
}
extension TodayViewController: ACViewControllerDelegate{
//    func ACViewControllerWeatherForecast(sender: AddCityViewController, weather: WeatherResponse) {
//        model.addCity(entry: weather)
//    }
    
    func addCityVCAddCity(sender: AddCityViewController, name: String, completion: @escaping (String?)->()){
        model.addCity(name: name){ error in
            completion(error)
            if (error == nil){
                DispatchQueue.main.async{
                    self.collectionView.reloadData()
                }
            }
        }
    }
}

extension TodayViewController: ErrorViewDelegate{
    func errorViewButtonTap(sender: ErrorView) {
        reload(nil)
    }
}

//extension TodayViewController: ForecastTableControllerDelegate{
//    func forecastTableGetCurrentCity(sender: ForecastTableController, completion: @escaping (ForecastResponse?)->()){
//        model.getForecast(index: pageControl.currentPage){ forecast in
//            completion(forecast)
//        }
//    }
//}

