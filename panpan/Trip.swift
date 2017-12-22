//
//  Trip.swift
//  panpan
//
//  Created by Dorian Delorme on 21/12/2017.
//  Copyright © 2017 Dorian Delorme. All rights reserved.
//

import Foundation

class Trip {
    let hours: String
    var date: String
    
    init(withTheHours newHours: String, andADateOf newDate: String) {
        self.hours = newHours
        self.date = newDate
    }
}
