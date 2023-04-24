//
//  MainViewModel.swift
//  Weather
//
//  Created by Ilya on 21.04.2023.
//

import Foundation

protocol MainViewModelDelegate: AnyObject {

    func didReceiveWeather(_ weather: MainViewModel.Weather)
}

final class MainViewModel: MainModelDelegate {

    struct Weather {

        let city: String
        let address: String
        let icon: Icon
        let tempC: String
        let shortDescription: String
        let longDescription: String

        enum Icon: String {

            case moon = "moon.fill"
            case sun = "sun.max.fill"
            case cloud = "cloud.fill"
            case fog = "cloud.fog.fill"
            case snow = "cloud.snow.fill"
            case rain = "cloud.rain.fill"
            case wind = "wind.circle.fill"
            case partlyCloudDay = "cloud.sun.fill"
            case partlyCloudNight = "cloud.moon.fill"

            init(with condition: String) {

                switch condition {
                case "fog": self = .fog
                case "rain": self = .rain
                case "snow": self = .snow
                case "wind": self = .wind
                case "cloudy": self = .cloud
                case "clear-day": self = .sun
                case "clear-night": self = .moon
                case "partly-cloudy-day": self = .partlyCloudDay
                case "partly-cloudy-night": self = .partlyCloudNight
                default: self = .sun
                }
            }
        }
    }

    init() {

        model.delegate = self
    }

    weak var delegate: MainViewModelDelegate?

    func viewLoaded() {

        model.requestStoredWeather()
    }

    func searchWeather(forCity city: String?) {

        guard let city = city else {

            return
        }

        let formattedCity = city

            .lowercased()
            .capitalized
            .trimmingCharacters(in: .whitespaces)

        model.requestWeatherForCity(formattedCity)
    }

    // MARK: - MainModelDelegate

    func didReceiveWeather(_ weather: WeatherObject) {

        guard let delegate = delegate else {

            assertionFailure("'delegate' is nil.")

            return
        }

        delegate.didReceiveWeather(

            .init(

                city: weather.city,
                address: weather.address,
                icon: .init(with: weather.icon),
                tempC: "\(weather.tempC)",
                shortDescription: weather.shortDescription,
                longDescription: weather.longDescription
            )
        )
    }

    // MARK: - Privates

    private let model: MainModel = MainModel()

} // MainViewModel
