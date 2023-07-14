//
//  Constants.swift
//  WeatherAppModelMVVMDemo3
//
//  Created by Ateeq Ahmed on 05/06/23.
//

import UIKit
class Constants: NSObject{
    static let kHomeURL = "data/2.5/weather?lat=%@&lon=%@&appid=%@"
    static let kImageURL = "https://openweathermap.org/img/wn/%@@2x.png"
    static let kSearchCityURL = "geo/1.0/direct?q=%@&limit=100&appid=%@&countrycode=US"
    static let kAppid = "f32f36efd5c0cefa353f90cb87fa26d5"
}
