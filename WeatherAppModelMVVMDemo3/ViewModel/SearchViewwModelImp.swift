//
//  SearchViewwModelImp.swift
//  WeatherAppModelMVVMDemo3
//
//  Created by Ateeq Ahmed on 05/06/23.
//

import Foundation
class SearchViewwModelImp: SearchViewModel {
    func getCityDetails(endPoint: String, completion: @escaping Response<[CityList]>) {
        CityList.getCityDetails(endPoint: endPoint) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
