//
//  MainModel.swift
//  Weather
//
//  Created by Ilya on 21.04.2023.
//

import Foundation

import Moya
import RealmSwift

protocol MainModelDelegate: AnyObject {

    func didReceiveWeather(_ weather: WeatherObject)
}

final class MainModel {

    init() {
    }

    weak var delegate: MainModelDelegate?

    func requestStoredWeather(for city: String? = UserDefaults.standard.string(forKey: MainModel.CityKey)) {

        if let city = city,
           let weather = getStoredWeather(for: city) {

            guard let delegate = delegate else {

                assertionFailure("'delegate' is nil.")

                return
            }

            delegate.didReceiveWeather(weather)
        }
    }

    func requestWeatherForCity(_ city: String) {

        requestStoredWeather(for: city)

        let provider = MoyaProvider<WeatherService>()

        provider.request(.getWeather(city: city)) { [weak self] result in

            guard let this = self else {

                return
            }

            switch result {

            case .success(let response):

                do {

                    let _ = try response.filterSuccessfulStatusCodes()

                    let weatherResponse = try this.jsonDecoder.decode(WeatherService.Response.self, from: response.data)

                    guard let delegate = this.delegate else {

                        assertionFailure("'delegate' is nil.")

                        return
                    }

                    let weatherObject = this.storeWeatherResponse(weatherResponse)
                    delegate.didReceiveWeather(weatherObject)
                    UserDefaults.standard.set(city, forKey: Self.CityKey)

                } catch {

                    print("Error. Can't get response:\(error).")
                }

            case .failure(let error):

                print("Weather request error:\(error).")
            }
        }
    }

    // MARK: - Privates

    private static let CityKey = "lastSearchCity"

    private let jsonDecoder: JSONDecoder = .init()

    private func getStoredWeather(for city: String) -> WeatherObject? {

        let realm = try! Realm()

        let weatherObjects = realm.objects(WeatherObject.self)

        return weatherObjects.where({ $0.city == city }).first
    }

    private func storeWeatherResponse(_ weatherResponse: WeatherService.Response) -> WeatherObject {

        let realm = try! Realm()

        let weatherObjects = realm.objects(WeatherObject.self)

        if let weather = weatherObjects.where({ $0.city == weatherResponse.city }).first {

            realm.writeAsync {

                weather.icon = weatherResponse.currentConditions.icon
                weather.tempC = weatherResponse.currentConditions.temp
                weather.shortDescription = weatherResponse.currentConditions.conditions
                weather.longDescription = weatherResponse.days.first?.description ?? ""
            }

            return weather

        } else {

            let weather = WeatherObject(

                city: weatherResponse.city,
                address: weatherResponse.fullAddress,
                icon: weatherResponse.currentConditions.icon,
                tempC: weatherResponse.currentConditions.temp,
                shortDescription: weatherResponse.currentConditions.conditions,
                longDescription: weatherResponse.days.first?.description ?? ""
            )

            realm.writeAsync {

                realm.add(weather)
            }

            return weather
        }
    }

} // MainModel
