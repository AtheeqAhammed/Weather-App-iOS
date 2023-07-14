//
//  ViewController.swift
//  WeatherAppModelMVVMDemo3
//
//  Created by Ateeq Ahmed on 04/06/23.
//

import UIKit
import SDWebImage
import CoreLocation

class ViewController: BaseViewController, CLLocationManagerDelegate {
    
    

    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var weatherDeatailsOutlet: UILabel!
    @IBOutlet weak var degreeOutlet: UILabel!
    @IBOutlet weak var weatherDescriptionOutlet: UILabel!
    @IBOutlet weak var cityNameOutlet: UILabel!
    @IBOutlet weak var imageWeatherIcon: UIImageView!
    
    private let HomeViewModel = HomeViewModelImp()
    private var WeatherAppModel: WeatherAppModel?
    var locManager = CLLocationManager()
    var longitude: String?
    var latitude: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locManager.requestWhenInUseAuthorization()
        locManager.delegate = self
        locManager.requestLocation()
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            guard let currentLocation = locManager.location else {
                return
            }
            print(currentLocation.coordinate.latitude)
            print(currentLocation.coordinate.longitude)
            
        }
        
    }

    @IBAction func searchButtonAction(_ sender: Any) {
        let popOver = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CitySearchViewController") as! CitySearchViewController
        popOver.delegate = self
        present(popOver, animated: true, completion: nil)
    }
    @IBAction func refreshButtonAction(_ sender: Any) {
        getWeatherDetails(latitude: latitude ?? "", longitude: longitude ?? "")
    }
    //MARK: Functions
    func locationManager(_ manager: CLLocationManager, didUpdateLocations Locations: [CLLocation]) {
        let currentlocation = Locations.last! as CLLocation
        latitude = "\(currentlocation.coordinate.latitude)"
        longitude = "\(currentlocation.coordinate.longitude)"
        getWeatherDetails(latitude: "\(currentlocation.coordinate.latitude)", longitude: "\(currentlocation.coordinate.longitude)")
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
        getWeatherDetails(latitude: "44.34", longitude: "10.99")
    }
    
    private func getWeatherDetails(latitude: String, longitude: String) {
        if Connectivity.isConnectedToInternet{
            startAnimation()
            HomeViewModel.getWeatherDetails(endPoint: String(format: Constants.kHomeURL, latitude, longitude,Constants.kAppid)) {Response in
                self.stopAnimation()
                switch Response{
                    
                case .success(let data):
                    self.WeatherAppModel = data
                    self.updateUI()
                case .failure(let error):
                    self.showAlertMessage(error.localizedDescription, title: NSLocalizedString("General.Error", comment: ""), ok: NSLocalizedString("General.ok", comment: ""), cancel: nil)
                }
            }
        }
        else {
            self.showAlertMessage(NSLocalizedString("General.Network.Error", comment: ""), title: NSLocalizedString("General.Error", comment: ""), ok: NSLocalizedString("General.ok", comment: ""), cancel: nil)
        }
    }
    func updateUI(){
        DispatchQueue.main.async {
            self.cityNameOutlet.text = self.WeatherAppModel?.name
            if let temp = self.WeatherAppModel?.main?.temp {
                self.degreeOutlet.text = "\(Int(temp - 273.15))°c"
            }
            let imageUrl = String(format: Constants.kImageURL, self.WeatherAppModel?.weather?.first?.icon ?? "")
            self.imageWeatherIcon.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "background.jpg"))
            self.weatherDescriptionOutlet.text = self.WeatherAppModel?.weather?.first?.description ?? ""
            if let humidity = self.WeatherAppModel?.main?.humidity {
                self.humidityLabel.text = "\(humidity)"
            }
            if let feelsLike = self.WeatherAppModel?.main?.feelsLike {
                self.feelsLikeLabel.text = "\(feelsLike)"
            }
            if let tempMin = self.WeatherAppModel?.main?.tempMin {
                self.minTempLabel.text = "\(tempMin)"
            }
            if let tempMax = self.WeatherAppModel?.main?.tempMax {
                self.maxTempLabel.text = "\(tempMax)"
            }
        }
    }
}
extension ViewController : SearchCityProtocolDelegate {
    func getSearchedCity(city: CityList) {
        if let latitude = city.lat, let longitude = city.lon{
            self.getWeatherDetails(latitude: "\(latitude)", longitude: "\(longitude)")
        }
    }
}
