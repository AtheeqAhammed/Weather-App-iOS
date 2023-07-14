//
//  HomeViewModelImp.swift
//  WeatherAppModelMVVMDemo3
//
//  Created by Ateeq Ahmed on 04/06/23.
//

import Foundation
class HomeViewModelImp: HomeViewModel {
    func getWeatherDetails(endPoint: String, completion: @escaping Response<WeatherAppModel>) {
        WeatherAppModel.getUserDetails(endPoint: endPoint) { result in
            switch result{
                
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
