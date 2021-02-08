//
//  Model.swift
//  Weather
//
//  Created by Alexsandre kikalia on 2/5/21.
//

import Foundation
import CoreLocation

protocol ModelDelegate: AnyObject{
    func modelDidUpdate(sender: Model)

}

class Model : NSObject{
    private let service = Service()
    private var group = DispatchGroup()
    private var locationManager:CLLocationManager = CLLocationManager()
    private var cities : [String:WeatherResponse] = [:]
    private var errorMsg: String? = nil
    private var error = false
    private var currentCity: String?
    weak var delegate: ModelDelegate?
//    private var curr: MKReverseGeoCoder
    override init() {
        super.init()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.startMonitoringSignificantLocationChanges()
            locationManager.requestWhenInUseAuthorization()
        }
//        fetchCities()
    }
    
    func fetchCity(city: String, completion: ((String?) -> ())? = nil){
        print("fetching \(city)")
        group.enter()
        service.loadWeather(for: city, type: APIType.current ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let weatherResponse):
                //success
//                sleep(10)
                if let weatherResp = weatherResponse as? WeatherResponse{
                    if let name = weatherResp.name {
                        self.cities[name] = weatherResp
                        if let completion = completion{
                            completion(name)
                            return
                        }
                    }else{
                        self.errorMsg = "Could not find city with specified name"
                        self.error = true
                    }
                }
            case .failure(_):
                // error occured
                self.errorMsg = "Network problem"
                self.error = true
            }
            if let completion = completion{
                completion(nil)
            }
            self.group.leave()
        }
    }
    
    func fetchCities(completion: @escaping (Bool) -> ()){
        print("fetching cities")
        
        self.error = false
        self.errorMsg = nil
        if let currentCity = currentCity{
            fetchCity(city: currentCity)
        }
        if let  cityList = UserDefaults.standard.stringArray(forKey: "cityList"){
            for (city) in cityList{
                fetchCity(city: city)
            }
        }
        group.notify(queue: .main){
            print("fetched cities")
            completion(self.error)
        }
    }
    
//    func addCity(entry: WeatherResponse){
//        if let name = entry.name{
////        let name = entry.name
//            if var cityList = UserDefaults.standard.stringArray(forKey: "cityList"){
//                cityList.append(name)
//                UserDefaults.standard.setValue(cityList, forKey: "cityList")
//            }
//            cities[name] = entry
//        }
//    }
    
    func getForecast(index:Int, completion: @escaping (ForecastResponse?)->()){
        if let cityList = UserDefaults.standard.stringArray(forKey: "cityList"){
            service.loadWeather(for: cityList[index], type: APIType.forecast){ result in
                switch result{
                case .success(let response):
                    if let forecast = response as? ForecastResponse{
                        completion(forecast)
                    }else{
                        completion(nil)
                    }
                case .failure(_):
                    completion(nil)
                }
            }
        }
    }
    
    func addCity(name: String, completion: @escaping (String?) -> ()){
        self.errorMsg = nil
        self.error = false
        fetchCity(city: name){city in
            if !self.error{
    //            if let currentCity = self.currentCity{
                if let city = city{
                    
                
                    if var cityList = UserDefaults.standard.stringArray(forKey: "cityList"){
                    
                        if !cityList.contains(city) { //&& currentCity != name{ //note: add to list even if current location city is the same (maybe user wants to have this city in permanent list)
                            cityList.append(city)
                            UserDefaults.standard.setValue(cityList, forKey: "cityList")
                        }else{
                            completion("Specified city is already in the list")
                            return
                        }
                    }else{
                        completion("Internal error")
                        return
                    }
                }else{
                    completion("City could not be found")
                    return
                }
            }
            completion(self.errorMsg)
            return 
        }
//            }
        
    }
    
    func deleteCity(index: Int){
        var i = index
        if let currentCity = self.currentCity{
            if i == 0{
                cities.removeValue(forKey: currentCity)
                self.currentCity = nil
                locationManager.stopUpdatingLocation()
                return
            }
            i -= 1
        }
        if var cityList = UserDefaults.standard.stringArray(forKey: "cityList"){
            cities.removeValue(forKey: cityList[i])
            cityList.remove(at: i)
            UserDefaults.standard.setValue(cityList, forKey: "cityList")
        }
    }
    
    func size() -> Int{
        var res = 0
        
        if let cityList = UserDefaults.standard.stringArray(forKey: "cityList"){
            res = cityList.count
            if currentCity != nil{
                res += 1
            }
        }
        return res
    }
    
    func get(index: Int) -> WeatherResponse?{
        var i = index
        if let currentCity = currentCity{
            if i == 0{
                return cities[currentCity]
            }
            i -= 1
        }
        if let cityList = UserDefaults.standard.stringArray(forKey: "cityList"){
            return cities[cityList[i]]
        }
        return nil
    }
    
    func get(name: String) -> WeatherResponse?{
        return cities[name]
    }
}

extension Model : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            case .restricted,.denied,.notDetermined:
                print("error")
            default:
                manager.startUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        if let location = location{
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                if let newCity = placemarks?.first?.locality{
                    if let current = self.currentCity{
                        if let cityList = UserDefaults.standard.stringArray(forKey: "cityList"){
                            if !cityList.contains(current){
                                self.cities.removeValue(forKey: current)
                            }
                        }
                    }
                    self.error = false
                    self.errorMsg = nil
                    self.fetchCity(city: newCity){ city in
                        if !self.error{
                            self.currentCity = city // to keep track with unique api based name
                            DispatchQueue.main.async {
                                self.delegate?.modelDidUpdate(sender: self)
                            }
                            
                        }
                    }
                }
            }
        }
        
    }
}
