//
//  GameLevelData.swift
//  coreMLtext
//
//  Created by 李庭宇 on 2025/2/25.
//

import SwiftUI

struct GameLevelData {
    var levelID: String
    let title: String
    let backgroundImage: String
    let answers: [[String?]]
    let numberHints: [((Int, Int), Int)]
    let acrossHints: [String]
    let downHints: [String]
    let game_vocabulary: [Vocabulary]
    let wordPositions: [String: [GridPosition]]
}
struct GridPosition {
    let row: Int
    let col: Int
}
