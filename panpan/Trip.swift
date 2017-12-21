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
    var duration: Float
    
    init(withTheHours newHours: String, andADurationOf newDuration: Float) {
        self.hours = newHours
        self.duration = newDuration
    }
}
