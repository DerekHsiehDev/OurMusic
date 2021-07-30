//
//  UserPieceModel.swift
//  PianoFly
//
//  Created by Derek Hsieh on 7/11/21.
//

import Foundation
import SwiftUI

struct UserPiece: Hashable, Codable {
    let pieceTitle: String
    let composer: String
    let iconColor: String
}
