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
    var practiceMinutes: String
    var dateCreated: Date
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
