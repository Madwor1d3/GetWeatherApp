//
//  ViewController.swift
//  GetWeather
//
//  Created by Madwor1d3 on 12/02/2019.
//  Copyright © 2019 Madwor1d3. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherVC: UIViewController, CLLocationManagerDelegate {
    
    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "9514f2012a6166b7dd124fac9d129950"
    
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self //Принимает делигирование на себя
        
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
        
    }


    @IBAction func changeViewsButtonPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "goToChangeCityVC", sender: self)
        
    }
    
    
    
    //Mark: - Networking
    /***************************************************************/
    
    func getWeatherData(url: String, parameters: [String: String]) {
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                
                print("Success! Got the weather data")
                let weatherJSON : JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
            }
            else {
                print("Error \(String(describing: response.result.error))")
                self.cityLabel.text = "Connection Issues"
            }
        }
    }
    
    
    //Mark: - Location Manager Delegate Methods
    /***************************************************************/
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[locations.count - 1] //Когда CoreLocation ищет информацию, то помещает данные в массив [CLLocation], последний индекс - самая точная инфа
        
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params : [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
            getWeatherData(url: WEATHER_URL, parameters: params)
            
        }
    }
    
    
    //Mark: - JSON Parsing
    /***************************************************************/
    
    func updateWeatherData(json: JSON) {
        
        if let tempResult = json["main"]["temp"].double {
        
        weatherDataModel.temperature = Int(tempResult - 273.15)
        
        weatherDataModel.city = json["name"].stringValue
        
        weatherDataModel.condition = json["weather"][0]["id"].intValue
        
        weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
        }
        else {
            cityLabel.text = "Weather unavailable"
        }
    }
    
    
    //Mark: - UI Updates
    /***************************************************************/
    
    func updateUIWithWeaherData() {
        
        cityLabel.text = weatherDataModel.city
        
        temperatureLabel.text = "\(weatherDataModel.temperature)°"
        
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print(error)
        
        cityLabel.text = "Location   Unavailable"
        
    }
}

