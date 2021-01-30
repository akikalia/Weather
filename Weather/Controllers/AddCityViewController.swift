//
//  AddCityViewController.swift
//  Weather
//
//  Created by Alexsandre kikalia on 1/30/21.
//

import UIKit

protocol ACViewControllerDelegate: AnyObject{
    func ACViewControllerWeatherForecast(sender: AddCityViewController, weather: WeatherResponse);
}

class AddCityViewController: UIViewController{
    @IBOutlet var textField: UITextField!
    @IBOutlet var loader: UIActivityIndicatorView!
    @IBOutlet var errorBanner: UIView!
    @IBOutlet var errorBannerLabel: UILabel!
    
    private let service = Service()
    private var delegate: ACViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func displayErrorBanner(text: String){
        errorBanner.isHidden = false
        errorBanner.alpha = 0
        errorBannerLabel.text = text
        UIView.animate(withDuration: 0.2) {
            self.errorBanner.alpha = 1.0
        }
    }
    
    func fetchCity(city: String){
        loader.startAnimating()
        service.loadWeather(for: city, type: APIType.current ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let weatherResponse):
                //success
                DispatchQueue.main.async {
                    self.loader.stopAnimating()
                    self.delegate?.ACViewControllerWeatherForecast(sender: self, weather: weatherResponse)
                    self.dismiss(animated: true, completion: nil)
                }
            case .failure(_):
                // error occured
                DispatchQueue.main.async {
                    self.loader.stopAnimating()
                    self.displayErrorBanner(text: "Problem fetching data.")
                }
            }
        }
        
    }
    
}
extension AddCityViewController: LoadingButtonViewDelegate{
    func loadingButtonViewDidTapButton(_ sender: LoadingButtonView) {
        if let name = textField.text{
            if let cityList = UserDefaults.standard.dictionary(forKey: "cityList"){
                if (cityList[name] != nil){
                    fetchCity(city: name)
                }else{
                    displayErrorBanner(text: "City already added, enter something else.")
                }
            }
        }
    }
}
