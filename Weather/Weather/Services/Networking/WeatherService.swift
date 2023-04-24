//
//  WeatherService.swift
//  Weather
//
//  Created by Ilya on 21.04.2023.
//

import Foundation
import Moya

enum WeatherService {

    case getWeather(city: String)

    struct Response: Decodable {

        let days: [Day]
        let city: String
        let fullAddress: String
        let currentConditions: CurrentConditions

        struct Day: Decodable {

            let description: String

            private enum CodingKeys: String, CodingKey {

                case description = "description"
            }

        } // Day

        struct CurrentConditions: Decodable {

            let icon: String
            let temp: Double
            let conditions: String

            private enum CodingKeys: String, CodingKey {

                case icon = "icon"
                case temp = "temp"
                case conditions = "conditions"
            }

        } // CurrentConditions

        private enum CodingKeys: String, CodingKey {

            case days = "days"
            case city = "address"
            case fullAddress = "resolvedAddress"
            case currentConditions = "currentConditions"
        }

    } // Response
}

extension WeatherService: TargetType {

    var baseURL: URL {

        .init(string: "https://weather.visualcrossing.com/VisualCrossingWebServices/rest")!
    }

    var path: String {

        switch self {
        case .getWeather(let city): return "services/timeline/\(city)/today"
        }
    }

    var method: Moya.Method {

        switch self {
        case .getWeather: return .get
        }
    }

    var task: Moya.Task {

        switch self {

        case .getWeather:

            return .requestParameters(

                parameters: [

                    "unitGroup": "metric",
                    "include": "current",
                    "key": "R4VWWX9N3ESVN9RY97L6RABYB",
                    "contentType": "json",
                ],
                encoding: URLEncoding.queryString
            )
        }
    }

    var headers: [String : String]? {

        [ : ]
    }
}
