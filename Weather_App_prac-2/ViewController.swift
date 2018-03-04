//
//  ViewController.swift
//  Weather_App_prac-2
//
//  Created by 최동호 on 2018. 3. 2..
//  Copyright © 2018년 최동호. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

struct Summary {
    let skyCode: String
    let skyName: String
    let minTemp: Double
    let maxTemp: Double
    let currentTemp: Double
    
    init?(json: JSON) {
        guard let weatherDict = json["weather"].dictionary else {
            fatalError("parsing error")
        }
        
        guard let minutely = weatherDict["minutely"]?.array?.first else {
            fatalError("parsing error")
        }
        guard let sky = minutely["sky"].dictionary else {
            fatalError("parsing error")
        }
        
        guard let code = sky["code"]?.string, let name = sky["name"]?.string else {
            fatalError("parsing error")
        }
        
        skyCode = code
        skyName = name
        
        guard let temperature = minutely["temperature"].dictionary else {
            fatalError("parsing error")
        }
        
        guard let currentTemperature = temperature["tc"]?.string, let minTemperature = temperature["tmin"]?.string, let maxTemperature = temperature["tmax"]?.string, let tc = Double(currentTemperature), let min = Double(minTemperature), let max = Double(maxTemperature) else {
            fatalError("parsing error")
        }
        
        minTemp = min
        maxTemp = max
        currentTemp = tc
        
        
        
        
        
    }
}

struct Forecast {
    
    let date: Date
    let skyCode: String
    let skyName: String
    let temperature: Double
    
}

class ViewController: UIViewController {

    var SummaryData: Summary?
    
    var ForecastData = [Forecast]()
    
    lazy var locationManager: CLLocationManager = {
        let m = CLLocationManager()
        m.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        m.delegate = self
        return m
    }()

    let backgroundImage: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "back"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let alphaImageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.7
        view.backgroundColor = .black
        return view
    }()
    
    let topTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "업데이트 중.."
        label.textColor = .white
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.dataSource = self
        tv.delegate = self
        tv.rowHeight = UITableViewAutomaticDimension
        tv.estimatedRowHeight = 170
        tv.register(SummaryTableViewCell.self, forCellReuseIdentifier: "cell")
        tv.register(ForecastTableViewCell.self, forCellReuseIdentifier: "forecastCell")
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.allowsSelection = false
        tv.showsHorizontalScrollIndicator = false
        tv.showsVerticalScrollIndicator = false
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let status = CLLocationManager.authorizationStatus()
//
        switch status {
        case .authorizedWhenInUse:
            updateLocation()
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
        default:
            print("Error")
        }
        
        self.view.addSubview(self.backgroundImage)
        self.backgroundImage.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        self.backgroundImage.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.backgroundImage.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        self.backgroundImage.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        
        self.view.addSubview(self.alphaImageView)
        self.alphaImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        self.alphaImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.alphaImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        self.alphaImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        
        self.view.addSubview(self.topTitleLabel)
        self.topTitleLabel.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 20).isActive = true
        self.topTitleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.view.addSubview(self.tableView)
        self.tableView.topAnchor.constraint(equalTo: self.topTitleLabel.bottomAnchor, constant: 8).isActive = true
        self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        
        
        
        
    }
    
    func fetchSummary(with coordinate: CLLocationCoordinate2D){
        let urlStr = "https://api2.sktelecom.com/weather/current/minutely?version=1&lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&appKey=df1f6490-e3c9-48e8-af94-e7f686cdb558"
        
        guard let url = URL(string: urlStr) else {
            return
        }
        
        Alamofire.request(url).responseJSON { (response) in
            if response.result.isSuccess {
                if let dict = response.result.value as? [String: Any] {
                    let json = JSON(dict)
                    if let summary = Summary(json: json) {
//                        dump(summary)
                        self.SummaryData = summary
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    } else {
                        fatalError("failed parsing")
                    }
                }
            } else {
                fatalError()
            }
        }
        
        
    }
    
    func fetchForecast(with coordinate: CLLocationCoordinate2D) {
        let urlStr = "https://api2.sktelecom.com/weather/forecast/3days?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&appKey=df1f6490-e3c9-48e8-af94-e7f686cdb558"
        
        guard let url = URL(string: urlStr) else {
            fatalError()
        }
        
        Alamofire.request(url).responseJSON { (response) in
            if response.result.isSuccess {
                if let dict = response.result.value as? [String: Any] {
                    let json = JSON(dict)
//                    dump(json)
                    
                    guard let weather = json["weather"].dictionary else {
                        fatalError()
                    }
                    
                    guard let forecast3days = weather["forecast3days"]?.array?.first else {
                        fatalError()
                    }
                    
                    guard let fcst3hours = forecast3days["fcst3hour"].dictionary else {
                        fatalError()
                    }
                    self.ForecastData.removeAll()
                    
                    
                    let comps = Calendar.current.dateComponents([.month, .day, .hour], from: Date())
                    
                    guard let now = Calendar.current.date(from: comps) else {
                        return
                    }
                    
                    var hour = 4
                    
                    while hour <= 64 {
                        defer {
                            hour += 3
                        }
                        
                        guard let sky = fcst3hours["sky"]?.dictionary else {
                            continue
                        }
                        
                        guard let code = sky["code\(hour)hour"]?.string, let name = sky["name\(hour)hour"]?.string, code.count > 0, name.count > 0 else {
                            continue
                        }
                        
                        
                        guard let temperature = fcst3hours["temperature"]?.dictionary else {
                           continue
                        }
                        
                        guard let temp = temperature["temp\(hour)hour"]?.string else {
                           continue
                        }
                        
                        let doubledTemp = Double(temp) ?? 0.0
                        
//
                        let dt = now.addingTimeInterval(TimeInterval(hour * 3600))
//
                        let forecast = Forecast(date: dt, skyCode: code, skyName: name, temperature: doubledTemp)
//
                        self.ForecastData.append(forecast)
//
                        
                    }
//                    print(self.ForecastData)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            } else {
                fatalError()
            }
        }
    }
    
    var topInset: CGFloat = 0.0
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if topInset == 0.0 {
            let first = IndexPath(row: 0, section: 0)
            if let cell = self.tableView.cellForRow(at: first) {
                topInset = self.tableView.frame.height - cell.frame.height
                self.tableView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
            }
            
        }
    }
    
    

}



extension ViewController: CLLocationManagerDelegate {

    func updateLocation() {
        self.locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let current = locations.last {
            self.fetchSummary(with: current.coordinate)
            self.fetchForecast(with: current.coordinate)
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(current, completionHandler: { (list, error) in
                if let error = error {
                    print("Error")
                }

                if let first = list?.first {
                    if let gu = first.locality, let dong = first.subLocality {
                        self.topTitleLabel.text = "\(gu) \(dong)"
//                        print("\(gu) \(dong)")
                    } else {
                        print("name: \(first.name)")
                    }
                }
            })
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            updateLocation()
        default:
            print("Error")
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 170
        }
        
        return 80
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return self.ForecastData.count
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SummaryTableViewCell
            
            if let data = self.SummaryData {
                print("Data Completed")
                cell.weatherImageView.image = UIImage(named: data.skyCode)
                cell.skyNameLabel.text = data.skyName
                cell.minMaxLabel.text = "최대 \(data.maxTemp) 최소 \(data.minTemp)"
                cell.tempLabel.text = "현재 \(data.currentTemp)"
            } else {
                print("Data uncompleted")
            }
            cell.backgroundColor = UIColor.clear
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "forecastCell") as! ForecastTableViewCell
        
        let targetForecastData = self.ForecastData[indexPath.row]
        
        cell.dateLabel.text = targetForecastData.date.description
        cell.weatherImageView.image = UIImage(named: targetForecastData.skyCode)
        cell.rightTempLabel.text = "\(targetForecastData.temperature)"
        
        
        cell.backgroundColor = UIColor.clear
        
        return cell
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
}

