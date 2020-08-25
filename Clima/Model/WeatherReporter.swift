//
//  WeatherReporter.swift
//  Clima
//
// 
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherReporter:WeatherReporter,Weather:WeatherDataInFormat)
    
    func isFailWithErrorInInternet(_ weatherReporter:WeatherReporter,error:Error)
    func isFailWithErrorInUserEntry(_ weatherReporter:WeatherReporter,error:Error)
}

struct WeatherReporter {
    
    let url = "https://api.openweathermap.org/data/2.5/weather?&appid=d34197493a6a93efdf139ad4a9d3dad1&units=metric"
    var delegate : WeatherManagerDelegate?
    func enteredCity(cityName:String)  {
        
        let urlWithCity = "\(url)&q=\(cityName)"
        
        performRequest(urlWithCity:urlWithCity)
    }
    
    func userCityWithLatAndLon(_ latitude:CLLocationDegrees, _ longitude:CLLocationDegrees) {
        let urlWithCity = "\(url)&lat=\(latitude)&lon=\(longitude)"
        performRequest(urlWithCity:urlWithCity)
    }
    
    //    .................Networking..........................
    
    func performRequest(urlWithCity:String){
        
        if let URL = URL(string: urlWithCity){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: URL) { (data:Data?, urlResponse:URLResponse?, error:Error?) in
                
                if let safeData = data{
                    if let Weather =  self.praseJSON(safeData){
                        self.delegate?.didUpdateWeather(self, Weather: Weather)
                        
                    }
                }
                if  error != nil {
                    
                    self.delegate?.isFailWithErrorInInternet(self, error: error!)
                    return
                }
            }
            task.resume()
        }
    }
    //    ........................Prasing JSON Data...................................
    
    func praseJSON(_ WeatherData:Data) -> WeatherDataInFormat?{
        let decoder = JSONDecoder()
        do{
            
            let decodedData = try decoder.decode(WeatherModel.self, from: WeatherData)
            let name = (decodedData.name)
            let temp = (decodedData.main.temp)
            let id = (decodedData.weather[0].id)
            let weather = WeatherDataInFormat(cityName: name, cityTemp: temp, cityId: id)
            return weather
        }
        catch{
            
            self.delegate?.isFailWithErrorInUserEntry(self, error: error)
            
            return nil
            
        }
    }
}
