//
//  ViewController.swift
//  MyWeather_Youtube
//
//  Created by Admin on 21.04.2022.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    
    
    let locationManager = CLLocationManager()
    var weatherData = WeatherData()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
     startLocationManager()
    }
    
    func startLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.pausesLocationUpdatesAutomatically = false
            locationManager.startUpdatingLocation()
        }
    }
    
    func updateView(){
        cityNameLabel.text = weatherData.name
        weatherDescriptionLabel.text = DataSource.weatherIDs[  weatherData.weather[0].id]
        temperatureLabel.text = weatherData.main.temp.description + "º"
        weatherIconImageView.image = UIImage(named: weatherData.weather[0].icon)
        
    }
    
    
    func updateWEatherInfo(latitude: Double, lontitude: Double) {
        let session = URLSession.shared
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=57&lon=-2.15&appid=a7007d41b9dd828665dbb28557093dad&units=metric")!
        let task = session.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print("DataTask error: \(error!.localizedDescription)")
                return
            }
            do {
                self.weatherData = try JSONDecoder().decode(WeatherData.self, from: data!)
                DispatchQueue.main.async {
                    self.updateView()
                }
                print(self.weatherData)
            } catch
            {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}


    extension ViewController: CLLocationManagerDelegate {
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let lastLocation = locations.last {
                updateWEatherInfo(latitude: lastLocation.coordinate.latitude, lontitude: lastLocation.coordinate.longitude)
                print(lastLocation.coordinate.latitude, lastLocation.coordinate.longitude)
            }
        }
        
    }
    


