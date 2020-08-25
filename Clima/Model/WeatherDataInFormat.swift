//
//  WeatherDataInFormat.swift
//  Clima
//
//  
//

import Foundation
struct WeatherDataInFormat {
    var cityName:String
    var cityTemp:Double
    var cityId:Int
    
    var tempInOnePoint : String{
        return  String(format:"%.1f", cityTemp)
    }
    
    var conditionName: String {
        switch cityId      {
        case 200...232 :
            return "cloud.bolt.rain"
        case 300...321 :
            return "cloud.drizzle"
        case 500...531 :
            return "cloud.heavyrain"
        case 600...622 :
            return "cloud.snow.fill"
        case 701...781 :
            return"cloud.fog"
        case 800 :
            return "sun.max"
        case 801...804 :
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}
