//
//  WebServiceManager.swift
//  MVVMDemo
//
//  Created by Mahaboob on 10/09/20.
//  Copyright © 2020 Meheboob. All rights reserved.
//



import UIKit
import Alamofire


typealias Response<T: Codable> = (Result<T, Error>) -> Void
struct None: Codable {} // Used when the response is empty

//enum ResponseStatus: Int {
//    case SuccessCreation = 201
//    case Success = 200
//    case SuccessDeletion = 204
//    case UnAuthorized = 401
//    case NotFound = 404
//}

class WebServiceManager: NSObject {
    
    static var sharedInstance = WebServiceManager()
    
    private override init() {
        
    }
    
    func getRequestWithHeadersEndpoint<T: Codable>(endpoint: String,
                                                   headers: HTTPHeaders?,
                                                   onFinished: @escaping Response<T>)  {
        let url = Bundle.main.baseURL + endpoint
        AF.request(url, method: .get,  parameters: nil, encoding: JSONEncoding.default)
            .responseJSON { response in
                debugPrint(response)
                switch response.result {
                case .success:
                    if let result = response.data {
                        do {
                            let decoder = JSONDecoder()
                            let data = try decoder.decode(T.self, from: result)
                            onFinished(.success(data))
                        }
                        catch {
                            onFinished(.failure(error))
                            debugPrint("Failed to decode")
                        }
                    } else {
                        if let error = response.error {
                            onFinished(.failure(error))
                        } else {
                            let error = NSError(domain: "", code: 500, userInfo: [ NSLocalizedDescriptionKey: "Something went wrong"])
                            onFinished(.failure(error))
                            debugPrint(error)
                        }
                    }
                    break
                case .failure(let error):
                    onFinished(.failure(error))
                    debugPrint(error)
                }
            }
    }
}


extension Bundle {
    var baseURL: String {
        return "https://api.openweathermap.org/"
    }

}

