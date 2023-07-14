//
//  HomeViewModel.swift
//  WeatherAppModelMVVMDemo3
//
//  Created by Ateeq Ahmed on 04/06/23.
//

import Foundation
protocol HomeViewModel {
    func getWeatherDetails(endPoint: String, completion: @escaping Response<WeatherAppModel>)
}
