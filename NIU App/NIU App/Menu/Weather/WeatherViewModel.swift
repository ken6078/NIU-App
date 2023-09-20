//
//  WeatherViewModel.swift
//  NIU App
//
//  Created by Jacky Ben on 2023/9/20.
//

import Foundation

class WeatherViewModel {
    // MARK: getWeatherInformation
    func getWeatherInformation() async -> Weather {
        let url = URL(string: "https://opendata.cwa.gov.tw/api/v1/rest/datastore/O-A0003-001?Authorization=CWB-53A3CA8D-61F3-4264-BDB2-E36CB7988719&stationId=467080")!
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        
        let weatherResult: WeatherResult
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            weatherResult = try decoder.decode(WeatherResult.self, from: data)
            return Weather(
                HUMD: (weatherResult.records.location.first?.weatherElement[4].elementValue)!,
                TEMP: (weatherResult.records.location.first?.weatherElement[3].elementValue)!,
                Weather: (weatherResult.records.location.first?.weatherElement.last!.elementValue)!
            )
        } catch {
            print("Getting information ERROR")
        }
        
        
        return Weather(HUMD: "0", TEMP: "0", Weather: "")
    }
}
