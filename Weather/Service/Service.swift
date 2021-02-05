//
//  Service.swift
//  Services
//
//  Created by Saba Khutsishvili on 12/18/20.
//

import Foundation
import KeychainSwift

class Service {
    
    private var components = URLComponents()
    private var parameters: [String:String]
    let keychain = KeychainSwift()
  
    //    http://api.openweathermap.org/data/2.5/forecast?q=tbilisi&appid=5bea068f287ea513788d00f99b61720a&cnt=40&units=metric
  //    http://api.openweathermap.org/data/2.5/weather?q=tbilisi&appid=5bea068f287ea513788d00f99b61720a&units=metric
  
    
    init() {
        keychain.set("5bea068f287ea513788d00f99b61720a", forKey: "apiKey")
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        parameters = ["":""]
    }
    
    func loadWeather(for city: String, type: APIType ,completion: @escaping (Result<Any, Error>) -> ()) {
        if type == .forecast{
            components.path = "/data/2.5/forecast"
            parameters = [
                "appid": keychain.get("apiKey") ?? "",
                "q": city,
                "units":"metric",
                "cnt":"40"
            ]
        }else{
            components.path = "/data/2.5/weather"
            parameters = [
                "appid": keychain.get("apiKey") ?? "",
                "q": city,
                "units":"metric"
            ]
        }
        components.queryItems = parameters.map { key, value in
            return URLQueryItem(name: key, value: value)
        }
        
        if let url = components.url {
//            print(components.url)
            let request = URLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                if let error = error {
                    print("error")
                    completion(.failure(error))
                    return
                }
                
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        print(data.debugDescription)
                        if (type == APIType.current){
                            let result = try decoder.decode(WeatherResponse.self, from: data)
                            completion(.success(result))
                            
                        }else{
                            let result = try decoder.decode(ForecastResponse.self, from: data)
                            completion(.success(result))
                            
                        }
                        
                        print("success")
                    } catch {
                        print("decoder failure")
                        completion(.failure(error))
                    }
                } else {
                    print("cast failure")
                    completion(.failure(ServiceError.noData))
                }
            })
            task.resume()
        } else {
            print ("invalid parameters")
            completion(.failure(ServiceError.invalidParameters))
        }
    }
}

enum ServiceError: Error {
    case noData
    case invalidParameters
}

enum APIType: String {
    case forecast = "forecast"
    case current = "current"
}
