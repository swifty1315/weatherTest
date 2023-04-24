//
//  Weather.swift
//  Weather
//
//  Created by Ilya on 24.04.2023.
//

import Foundation
import RealmSwift

class WeatherObject: Object {

    @Persisted(primaryKey: true) var _id: ObjectId

    @Persisted var city: String = ""
    @Persisted var address: String = ""
    @Persisted var icon: String = ""
    @Persisted var tempC: Double = 0
    @Persisted var shortDescription: String = ""
    @Persisted var longDescription: String = ""

    convenience init(

        city: String,
        address: String,
        icon: String,
        tempC: Double,
        shortDescription: String,
        longDescription: String

    ) {

        self.init()

        self.city = city
        self.address = address
        self.icon = icon
        self.tempC = tempC
        self.shortDescription = shortDescription
        self.longDescription = longDescription
    }

} // WeatherObject
