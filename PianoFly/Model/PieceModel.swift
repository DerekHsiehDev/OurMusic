//
//  PieceModel.swift
//  PianoFly
//
//  Created by Derek Hsieh on 7/5/21.
//

import Foundation
import SwiftUI

struct Piece: Hashable {
    let composer: String
    let title: String
    var practiceArray: [PracticeDays]
    var thisWeekPracticeMinutes: Int
    var allTimePracticeMinutes: Int
    var iconColor: String
}

struct PracticeDays: Hashable {
    let date: String
    var practiceMinutes: Int
}



