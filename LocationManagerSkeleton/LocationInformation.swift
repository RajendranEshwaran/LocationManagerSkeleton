//
//  LocationInformation.swift
//  LocationManagerSkeleton
//
//  Created by gomathi saminathan on 1/28/20.
//  Copyright © 2020 Rajendran Eshwaran. All rights reserved.
//

import Foundation
import CoreLocation

class LocationInformation {
    var city:String?
    var address:String?
    var latitude:CLLocationDegrees?
    var longitude:CLLocationDegrees?
    var zip:String?
    var state :String?
    var country:String?
    init(city:String? = "",address:String? = "",latitude:CLLocationDegrees? = Double(0.0),longitude:CLLocationDegrees? = Double(0.0),zip:String? = "",state:String? = "",country:String? = "") {
        self.city    = city
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.zip        = zip
        self.state = state
        self.country = country
    }
}
