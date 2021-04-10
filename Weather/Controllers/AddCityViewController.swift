//
//  AddCityViewController.swift
//  Weather
//
//  Created by Alexsandre kikalia on 1/30/21.
//

import UIKit

protocol ACViewControllerDelegate: AnyObject{
//    func ACViewControllerWeatherForecast(sender: AddCityViewController, weather: WeatherResponse)
    func addCityVCAddCity(sender: AddCityViewController, name: String, completion: @escaping (String?)->())
}

class AddCityViewController: UIViewController{
    @IBOutlet var textField: UITextField!
    @IBOutlet var loader: LoadingButtonView!
    @IBOutlet var errorBanner: UIView!
    @IBOutlet var errorBannerLabel: UILabel!
    @IBOutlet var mainView: GradientView!
    var blur: UIVisualEffectView!
    
    private let service = Service()
    weak var delegate: ACViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loader.delegate = self
        errorBanner.isHidden = true
        errorBanner.backgroundColor = .systemRed
        textField.delegate = self
        mainView.setGradientBG(top: .greenStart, bottom: .greenEnd)
        view.isOpaque = false
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        mainView.roundCorner(heightToRadiusRatio: 10)
        mainView.setGlow(color: .greenStart)
        errorBanner.roundCorner(heightToRadiusRatio: 5)
        errorBanner.setGlow(color: .systemRed)
        loader.roundCorner(heightToRadiusRatio: 2)
        loader.tintColor = .greenEnd
        
        let blurEffect = UIBlurEffect(style: .dark)
        blur = UIVisualEffectView(effect: blurEffect)
        blur.frame = view.bounds
        blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blur.alpha = 0.7
        view.addSubview(blur)
        

        view.backgroundColor = .clear
        view.bringSubviewToFront(mainView)
        view.bringSubviewToFront(errorBanner)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTouchDown(_:)))
        self.view.addGestureRecognizer(tap)
        tap.delegate = self
    }
    
    
    
    @objc
    func handleTouchDown(_ sender: UITapGestureRecognizer? = nil) {
        if sender?.state == .ended{
            self.dismiss(animated: true, completion: nil)
       }
    }
    
    func displayErrorBanner(text: String){
        errorBanner.isHidden = false
        errorBanner.alpha = 0
        errorBannerLabel.text = text
        UIView.animate(withDuration: 0.3) {
            self.errorBanner.alpha = 1.0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 10){
            self.errorBanner.isHidden = true
        }
    }
    
//    func fetchCity(city: String){
//        service.loadWeather(for: city, type: APIType.current ) { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let weatherResponse):
//                //success
//                if let weatherResponse = weatherResponse as? WeatherResponse{
//                    DispatchQueue.main.async {
//                        self.loader.stopLoading()
//                        print("successfully fetched data")
//                        self.dismiss(animated: true, completion: nil)
//                        self.delegate?.ACViewControllerWeatherForecast(sender: self, weather: weatherResponse)
//                    }
//                }
//            case .failure(_):
//                // error occured
//                DispatchQueue.main.async {
//                    self.loader.stopLoading()
//                    print("failed to fetch data")
//                    self.displayErrorBanner(text: "Problem fetching data.")
//                }
//            }
//        }
//        
//    }
    
}
extension AddCityViewController: LoadingButtonViewDelegate{
//    func loadingButtonViewDidTapButton(_ sender: LoadingButtonView) {
//        if let name = textField.text{
//
////            if let cityList = UserDefaults.standard.stringArray(forKey: "cityList"){
////                if (!cityList.contains(name)){
////                    fetchCity(city: name)
////                    print("fetching city " + name)
////                    return
////                }else{
////                    displayErrorBanner(text: "City already added, enter something else.")
////                }
////            }
//        }
//        loader.stopLoading()
//    }
    func loadingButtonViewDidTapButton(_ sender: LoadingButtonView) {
        if let name = textField.text{
//            delegate?.ACViewControllerWeatherForecast(sender: self, weather: nil)
            delegate?.addCityVCAddCity(sender: self, name: name){ error in
                DispatchQueue.main.async {
                    if let error = error{
                        self.loader.stopLoading()
                        print("failed to fetch data")
                        self.displayErrorBanner(text: error)
                    }
                    if error == nil{
                        self.loader.stopLoading()
                        print("successfully fetched data")
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
            
//            if let cityList = UserDefaults.standard.stringArray(forKey: "cityList"){
//                if (!cityList.contains(name)){
//                    fetchCity(city: name)
//                    print("fetching city " + name)
//                    return
//                }else{
//                    displayErrorBanner(text: "City already added, enter something else.")
//                }
//            }
//        }
//        loader.stopLoading()
    }
}

extension AddCityViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension AddCityViewController: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view == self.blur{
            return true
        }
        return false
    }
}
