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
    let practiceArray: [PracticeDays]
    let thisWeekPracticeMinutes: Int
    let allTimePracticeMinutes: Int
    let iconColor: Color
}

struct PracticeDays: Hashable {
    let date: String
    let practiceMinutes: Int
}



