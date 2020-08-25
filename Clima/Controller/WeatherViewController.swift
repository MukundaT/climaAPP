//
//  ViewController.swift
//  Clima
//
// 
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    
    var   weatherReporter = WeatherReporter()
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        inputTextField.delegate = self
        weatherReporter.delegate = self
        
    }
    @IBAction func homeButton(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}
//MARK: - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate{
    @IBAction func searchButton(_ sender: UIButton) {
        inputTextField.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputTextField.endEditing(true)
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            textField.placeholder = "Search"
            return true
        }
        else{
            textField.placeholder = "PleaseEnterCity"
            return false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let cityName = textField.text{
            weatherReporter.enteredCity(cityName: cityName)
            
        }
        inputTextField.text = ""
        
    }
}

//MARK: - WeatherManagerdelegate

extension WeatherViewController:WeatherManagerDelegate{
    
    func didUpdateWeather(_ weatherReporter:WeatherReporter, Weather: WeatherDataInFormat) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = Weather.tempInOnePoint
            self.cityLabel.text = Weather.cityName
            self.conditionImageView.image = UIImage(systemName: Weather.conditionName)
        }
    }
    func isFailWithErrorInInternet(_ weatherReporter:WeatherReporter ,error: Error) {
        
        DispatchQueue.main.async {
            
            self.cityLabel.text = "CheckYourInternet"    }
    }
    
    func isFailWithErrorInUserEntry(_ weatherReporter:WeatherReporter ,error: Error) {
        
        DispatchQueue.main.async {
            
            self.cityLabel.text = "EnterVaildCityName"
            //MARK: - <#SectionHeading#>
        }
    }
}


//MARK: - CLLocationManagerDelagate
extension WeatherViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherReporter.userCityWithLatAndLon(lat, lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            
            self.cityLabel.text = "GiveAccessLocation"
        }
    }}
