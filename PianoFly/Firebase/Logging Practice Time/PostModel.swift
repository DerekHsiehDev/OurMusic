//
//  PostModel.swift
//  PianoFly
//
//  Created by Derek Hsieh on 6/15/21.
//

import Foundation
import SwiftUI

struct PostModel: Identifiable, Hashable {
    var id = UUID()
    var postID: String
    var practiceMinutes: Int
    var dateCreated: Date
    var pieces: [String: Int]?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
