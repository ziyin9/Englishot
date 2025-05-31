//
//  GameLevelData.swift
//  coreMLtext
//
//  Created by 李庭宇 on 2025/2/25.
//

import SwiftUI

struct GameLevelData_2 {
    let title: String
    let backgroundImage: String
    let imageHint : String
    let answers: [[String?]]
    let numberHints: [((Int, Int), Int)]
    let game_vocabulary: [Vocabulary]
    let wordPositions: [String: [GridPosition]]
}
struct GridPosition_2 {
    let row: Int
    let col: Int
}
