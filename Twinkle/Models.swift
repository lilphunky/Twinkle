//
//  Models.swift
//  Twinkle
//
//  Created by Micky Chettanapanich on 2/2/20.
//  Copyright © 2020 Twinkle. All rights reserved.
//

import Foundation

struct HOROSCOPE: Codable{
    let sign: String
    let date: String
    let horoscope: String
}

struct GENERAL_PLANET_PARAM: Codable {
    let day: Int
    let month: Int
    let year: Int
    let hour: Int
    let min: Int
    let lat: Double
    let lon: Double
    let tzone: Double
}

struct GENERAL_PLANET_REPORT: Codable {
    let id: Int
    let name: String
    let fullDegree: Decimal
    let normDegree: Decimal
    let speed: Decimal
    let isRetro: String
    let sign: String
    let signLord: String
    let nakshatra: String
    let nakshatraLord: String
    let nakshatra_pad: Int
    let house: Int
    let is_planet_set: Bool
    let planet_awastha: String
}


struct ASC_REPORT: Codable {
    let ascendant: String
    let report: String
}

