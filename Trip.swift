//
//  Trip.swift
//  
//
//  Created by Dorian Delorme on 21/12/2017.
//

import Foundation

class Trip {
    let title: String
    var score: Float
    
    init(withTheTitle newTitle: String, andAScoreOf newScore: Float) {
        self.title = newTitle
        self.score = newScore
    }
}

