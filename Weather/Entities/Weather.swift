//
//  Weather.swift
//  Weather
//
//  Created by Alexsandre kikalia on 1/28/21.
//

import Foundation

struct WeatherResponse: Codable{
    let coord: Coordinates?
    let weather: [WeatherEntry]?
    let base: String?
    let main: Main?
    let Visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Int64?
    let sys: Sys?
    let timezone: Int?
    let id: Int?
    let name: String?
    
    //mutural
    let cod: Int?
    
    //additional from Forecast
    let message: Int?
    let cnt: Int?
    let list:[DaytimeForecast]?
    let city: City?
}

//
//struct Current: Codable{
//    let coord: Coordinates
//    let weather: [WeatherEntry]
//    let base: String
//    let main: Main
//    let Visibility: Int?
//    let wind: Wind
//    let clouds: Clouds
//    let dt: Int64
//    let sys: Sys
//    let timezone: Int
//    let id: Int
//    let name: String
//    let cod: String
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

struct DaytimeForecast: Codable {
    let dt: Int64
    let main: Main
    let Weather: [WeatherEntry]
    let clouds: Clouds
    let Wind: Wind
    let Visibility: Int
    let pop: Int
    let sys: Sys
    let dt_txt: String
}

struct Main: Codable{
    let temp: Float
    let feels_like: Float
    let temp_min: Float
    let temp_max: Float
    let pressure: Int
    let sea_level: Int
    let grnd_level: Int
    let humidity: Int
    let temp_kf: Float
}
struct WeatherEntry: Codable{
    let id: Int
    let main: String
    let description: String
    let icon: String
}
struct Clouds: Codable{
    let all: Int
}
struct Wind: Codable{
    let speed: Int
    let deg: Int
}
struct Sys: Codable{
    let pod: String
}

struct City: Codable {
    let id: Int
    let name: String
    let coord: Coordinates
    let country: String
    let population: Int64
    let sunrise: Int64
    let sunset: Int64
}

struct Coordinates: Codable{
    let lat: Float
    let lon: Float
}
