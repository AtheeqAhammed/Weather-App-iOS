//
//  CityList.swift
//  WeatherAppModelMVVMDemo3
//
//  Created by Ateeq Ahmed on 05/06/23.
//

import Foundation

// MARK: - WelcomeElement
struct CityList: Codable, Equatable, Hashable {
    static func == (lhs: CityList, rhs: CityList) -> Bool {
        return lhs.lat == rhs.lat && lhs.lon == rhs.lon
    }
    var hashValue: Int {
            return name.hashValue ^ lat.hashValue ^ lon.hashValue ^ state.hashValue
        }
    let name: String?
    let localNames: LocalNames?
    let lat, lon: Double?
    let country, state: String?

    enum CodingKeys: String, CodingKey {
        case name
        case localNames = "local_names"
        case lat, lon, country, state
    }
}

// MARK: - LocalNames
struct LocalNames: Codable {
    let en, ta, lt, es: String?
}

extension CityList {
    static func getCityDetails(endPoint:String, completion: @escaping Response<[CityList]>) {
        WebServiceManager.sharedInstance.getRequestWithHeadersEndpoint(endpoint: endPoint,
                                                                       headers: nil,
                                                                    onFinished: completion)
    }
}
