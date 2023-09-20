//
//  WeatherModel.swift
//  NIU App
//
//  Created by Jacky Ben on 2023/9/20.
//

import Foundation

// MARK: - WeatherResult
class WeatherResult: Codable {
    let success: String
    let result: Result
    let records: Records

    init(success: String, result: Result, records: Records) {
        self.success = success
        self.result = result
        self.records = records
    }
}

// MARK: - Records
class Records: Codable {
    let location: [Location]

    init(location: [Location]) {
        self.location = location
    }
}

// MARK: - Location
class Location: Codable {
    let lat, lon, locationName, stationID: String
    let time: Time
    let weatherElement: [WeatherElement]
    let parameter: [Parameter]

    enum CodingKeys: String, CodingKey {
        case lat, lon, locationName
        case stationID = "stationId"
        case time, weatherElement, parameter
    }

    init(lat: String, lon: String, locationName: String, stationID: String, time: Time, weatherElement: [WeatherElement], parameter: [Parameter]) {
        self.lat = lat
        self.lon = lon
        self.locationName = locationName
        self.stationID = stationID
        self.time = time
        self.weatherElement = weatherElement
        self.parameter = parameter
    }
}

// MARK: - Parameter
class Parameter: Codable {
    let parameterName, parameterValue: String

    init(parameterName: String, parameterValue: String) {
        self.parameterName = parameterName
        self.parameterValue = parameterValue
    }
}

// MARK: - Time
class Time: Codable {
    let obsTime: String

    init(obsTime: String) {
        self.obsTime = obsTime
    }
}

// MARK: - WeatherElement
class WeatherElement: Codable {
    let elementName, elementValue: String

    init(elementName: String, elementValue: String) {
        self.elementName = elementName
        self.elementValue = elementValue
    }
}

// MARK: - Result
class Result: Codable {
    let resourceID: String
    let fields: [Field]

    enum CodingKeys: String, CodingKey {
        case resourceID = "resource_id"
        case fields
    }

    init(resourceID: String, fields: [Field]) {
        self.resourceID = resourceID
        self.fields = fields
    }
}

// MARK: - Field
class Field: Codable {
    let id, type: String

    init(id: String, type: String) {
        self.id = id
        self.type = type
    }
}

enum WeatherStatus {
    case sun
    case cloud
    case rain
    case storm
}

class Weather {
    // 濕度
    let HUMD: Float
    // 溫度
    let TEMP: Float
    // 氣象狀況
    let status: WeatherStatus
    init(HUMD: String, TEMP: String, Weather: String) {
        self.HUMD = Float(HUMD) ?? 0.0
        self.TEMP = Float(TEMP) ?? 0.0
        if (Weather.contains("雷") || Weather.contains("電")) {
            self.status = .storm
        } else if (Weather.contains("雨")) {
            self.status = .rain
        } else if (Weather.contains("雲")) {
            self.status = .cloud
        } else {
            self.status = .sun
        }
    }
}
