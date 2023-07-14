//
//  SearchCityViewModel.swift
//  WeatherAppModelMVVMDemo3
//
//  Created by Ateeq Ahmed on 05/06/23.
//

import Foundation
protocol SearchViewModel {
    func getCityDetails(endPoint: String, completion: @escaping Response<[CityList]>)
}
