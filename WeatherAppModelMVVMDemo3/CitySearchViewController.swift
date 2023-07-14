//
//  CitySearchViewController.swift
//  WeatherAppModelMVVMDemo3
//
//  Created by Ateeq Ahmed on 04/06/23.
//

import UIKit

protocol SearchCityProtocolDelegate: AnyObject{
    func getSearchedCity(city: CityList)
}

class CitySearchViewController: BaseViewController {
    var cityList = [CityList]()
    var catchedCityList = [CityList]()
    private let SearchViewModel = SearchViewwModelImp()
    // Step 2
    weak var delegate: SearchCityProtocolDelegate?
    
    
    @IBOutlet weak var searchTableViewOutlet: UITableView!
    @IBOutlet weak var searchCityOutlet: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    @IBAction func searchButtonAction(_ sender: Any) {
        getCityList()
    }
    private func setupUI() {
        searchTableViewOutlet.separatorColor = .clear
        searchCityOutlet.layer.cornerRadius = 20
        searchTableViewOutlet.clipsToBounds = true
        searchTableViewOutlet.delegate = self
        searchTableViewOutlet.dataSource = self
        if let data = UserDefaults.standard.data(forKey: "cities") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                // Decode Note
                self.cityList = try decoder.decode([CityList].self, from: data)
                catchedCityList = try decoder.decode([CityList].self, from: data)
            } catch {
                print("Unable to Decode Note (\(error))")
            }
        }
    }
    func getCityList() {
        if Connectivity.isConnectedToInternet {
            startAnimation()
            SearchViewModel.getCityDetails(endPoint: String(format: Constants.kSearchCityURL, searchCityOutlet.text ?? "",Constants.kAppid)) { response in
                self.stopAnimation()
                switch response {
                case .success(let data):
                    let list = data.filter({$0.country == "US"})
                    if list.isEmpty {
                        self.showAlertMessage(NSLocalizedString("SearchCity.noresults.error", comment: ""), title: NSLocalizedString("General.Error", comment: ""), ok: NSLocalizedString("General.ok", comment: ""), cancel: nil)
                    } else {
                        self.cityList = list
                        DispatchQueue.main.async {
                            self.searchTableViewOutlet.reloadData()
                        }
                    }
                case .failure(let error):
                    self.showAlertMessage(error.localizedDescription, title: NSLocalizedString("General.Error", comment: ""), ok: NSLocalizedString("General.ok", comment: ""), cancel: nil)
                }
            }
        } else {
            self.showAlertMessage(NSLocalizedString("General.Network.Error", comment: ""), title: NSLocalizedString("General.Error", comment: ""), ok: NSLocalizedString("General.ok", comment: ""), cancel: nil)
        }
        
    }
}
extension CitySearchViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCellViewController", for: indexPath) as! CityCellViewController
        cell.cityNameLbl.text = cityList[indexPath.row].name
        cell.cityStateLabel.text = cityList[indexPath.row].state
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var cities = [CityList]()
        cities.append(cityList[indexPath.row])
        cities.append(contentsOf: catchedCityList)
        let points: Set<CityList> = Set(cities)
        cities.removeAll()
        cities.append(contentsOf: points)
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()
            // Encode Note
            let data = try encoder.encode(cities)
            // Write/Set Data
            UserDefaults.standard.set(data, forKey: "cities")
            
        } catch {
            print("Unable to Encode Note (\(error))")
        }
        // Step 3
        delegate?.getSearchedCity(city: cityList[indexPath.row])
        self.dismiss(animated: true)
        
    }
}
