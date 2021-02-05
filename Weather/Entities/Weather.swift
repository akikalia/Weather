////
////  Weather.swift
////  Weather
////
////  Created by Alexsandre kikalia on 1/28/21.
////
//
import Foundation
////
////{
////    "coord": {
////        "lon": 49.892,
////        "lat": 40.3777
////    },
////    "weather": [
////        {
////            "id": 803,
////            "main": "Clouds",
////            "description": "broken clouds",
////            "icon": "04n"
////        }
////    ],
////    "base": "stations",
////    "main": {
////        "temp": 281.15,
////        "feels_like": 276.84,
////        "temp_min": 281.15,
////        "temp_max": 281.15,
////        "pressure": 1023,
////        "humidity": 93
////    },
////    "visibility": 10000,
////    "wind": {
////        "speed": 5.14,
////        "deg": 160
////    },
////    "clouds": {
////        "all": 75
////    },
////    "dt": 1612200515,
////    "sys": {
////        "type": 1,
////        "id": 8841,
////        "country": "AZ",
////        "sunrise": 1612151390,
////        "sunset": 1612187885
////    },
////    "timezone": 14400,
////    "id": 587084,
////    "name": "Baku",
////    "cod": 200
////}
//
////MARK: - my stuff
////
////
////
//
////
struct WeatherResponse: Codable{
    let coord: Coordinates?
    let weather: [WeatherEntry]?
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Int64?
    let sys: Sys?
    let timezone: Int?
    let id: Int?
    let name: String?
//
//    //mutural
//    let cod: Int?
//
//    //additional from Forecast
//    let message: Int?
//    let cnt: Int?
//    let list:[DaytimeForecast]?
//    let city: City?
}

struct ForecastResponse: Codable{

    //mutural
    let cod: String

    //additional from Forecast
    let message: Int?
    let cnt: Int?
    let list:[DaytimeForecast]?
    let city: City?
}
//
//
//struct WeatherResponse: Codable{
//    let coord: Coordinates
//    let weather: [WeatherEntry]
//    let base: String
//    let main: Main
//    let visibility: Int64
//    let wind: Wind
//    let clouds: Clouds
//    let dt: Int64
//    let sys: Sys
//    let timezone: Int
//    let id: Int
//    let name: String
//    let cod: Int
//}
//
//struct Forecast: Codable {
//    let cod: String
//    let message: Int
//    let cnt: Int
//    let list: [DaytimeForecast]
//    let city: City
//
//}
//
struct DaytimeForecast: Codable {
    let dt: Int64
    let main: Main
    let weather: [WeatherEntry]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let pop: Double
    let sys: Sys
    let dt_txt: String
    let rain: Rain?
}

struct Rain: Codable {
    let the3H: Double

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}


struct Main: Codable{
    let temp: Double?
    let feels_like: Double?
    let temp_min: Double?
    let temp_max: Double?
    let pressure: Int?
    let sea_level: Int?
    let grnd_level: Int?
    let humidity: Int?
    let temp_kf: Double?
}
struct WeatherEntry: Codable{
    let id: Int
    let main: String
    let descr: String
    let icon: String
    enum CodingKeys: String, CodingKey {
        case descr = "description"
        case id = "id"
        case main = "main"
        case icon = "icon"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        descr = try container.decode(String.self, forKey: .descr)
        id = try container.decode(Int.self, forKey: .id)
        main = try container.decode(String.self, forKey: .main)
        icon = try container.decode(String.self, forKey: .icon)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(descr, forKey: .descr)
        try container.encode(id, forKey: .id)
        try container.encode(main, forKey: .main)
        try container.encode(icon, forKey: .icon)
    }

}
struct Clouds: Codable{
    let all: Int
}
struct Wind: Codable{
    let speed: Double
    let deg: Int
}

struct Sys: Codable{
    let pod: String?
    let type: Int64?
    let id: Int64?
    let country: String?
    let sunrise: Int64?
    let sunset: Int64?
}


struct City: Codable {
    let id: Int
    let name: String
    let coord: Coordinates
    let country: String
    let population: Int64
    let timezone: Int?
    let sunrise: Int64
    let sunset: Int64
}

struct Coordinates: Codable{
    let lat: Double
    let lon: Double
}







