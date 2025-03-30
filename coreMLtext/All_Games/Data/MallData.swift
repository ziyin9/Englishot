//
//  MallData.swift
//  Englishot
//
//  Created by 陳姿縈 on 3/6/25.
//

import SwiftUI

let FoodData = GameLevelData(
    title: "Food",
    backgroundImage: "Food",
    answers: [
        [nil, nil, nil, nil, nil, nil, nil, nil, "h", nil,nil],
        [nil, nil, nil, nil, "p", "i", "z", "z", "a", nil,nil],
        [nil, nil, nil, nil, nil, nil, nil, nil, "m", nil,nil],
        [nil, nil, nil, nil, nil, nil, nil, nil, "b", nil,nil],
        [nil, nil, nil, nil, nil, nil, nil, nil, "u", nil,nil],
        [nil, "d", "u", "m", "p", "l", "i", "n", "g", nil,nil],
        [nil, nil, nil, nil, "a", nil, nil, nil, "e", nil,nil],
        [nil, nil, nil, nil, "s", nil, nil, nil, "r", nil,nil],
        [nil, nil, nil, nil, "t", nil, nil, nil, nil, nil,nil],
        [nil, nil, nil, nil, "a", nil, nil, nil, nil, nil,nil],
    ],
    numberHints: [
        ((1, 4), 1),
        ((0, 8), 2),
        ((5, 4), 3),
        ((5, 1), 4),
    ],
    acrossHints: [
        "1. Tom loves p___a with lots of ",
        "cheese and mushrooms.",
        "4. If you bite into the d______g ",
        "with the coin, you’ll have a ",
        "lucky year!"
    ],
    downHints: [
        "2. I like to eat hamburgers from ",
        "McDonald's（麥當勞）.",
        "3. Emily had p___a for lunch at an ",
        "Italian restaurant.",
    ],
    game_vocabulary: [
        vocabularyList[34],
        vocabularyList[35],
        vocabularyList[36],
        vocabularyList[37]
        ],
    wordPositions: [
            "pizza": (4...8).map {GridPosition(row: 1, col: $0)},
            "pasta": (5...9).map {GridPosition(row: $0, col: 4)},
            "dumpling": (1...8).map {GridPosition(row: 5, col: $0)},
            "hamburger": (0...7).map {GridPosition(row: $0, col: 8)},
    ]
)

let Electronics_StoreData = GameLevelData(
    title: "Electronics Store",
    backgroundImage: "Electronicsstore",
    answers: [
        [nil, nil, nil, nil, nil, "s", nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, "m", nil, nil, nil, "w", nil],
        [nil, nil, nil, nil, "c", "a", "m", "e", "r", "a", nil],
        [nil, nil, nil, nil, nil, "r", nil, nil, nil, "t", nil],
        [nil, nil, nil, nil, nil, "t", nil, nil, nil, "c", nil],
        [nil, nil, nil, nil, nil, "p", nil, nil, nil, "h", nil],
        [nil, nil, nil, nil, nil, "h", nil, nil, nil, nil, nil],
        [nil, "k", "e", "y", "b", "o", "a", "r", "d", nil, nil],
        [nil, nil, nil, nil, nil, "n", nil, nil, nil, nil, nil],
        [nil, "m", "o", "u", "s", "e", nil, nil, nil, nil, nil],
    ],
    numberHints: [
        ((1, 9), 1),
        ((0, 5), 2),
        ((2, 4), 3),
        ((7, 1), 4),
        ((9, 1), 5),
    ],
    acrossHints: [
        "3. Ben took a photo with a c____a.",
        "4. He types on the k______d.",
        "5. She clicked the m___e.",
    ],
    downHints: [
        "1. Tom looked at her w___h to ",
        "check the time.",
        "2. We can send messages on a ",
        "s________e."
    ],
    game_vocabulary: [
        vocabularyList[38],
        vocabularyList[39],
        vocabularyList[40],
        vocabularyList[41],
        vocabularyList[42]
        ],
    wordPositions: [
            "watch": (1...5).map {GridPosition(row: $0, col: 9)},
            "camera": (4...9).map {GridPosition(row: 2, col: $0)},
            "keyboard": (1...8).map {GridPosition(row: 7, col: $0)},
            "smartphone": (0...9).map {GridPosition(row: $0, col: 5)},
            "mouse": (1...5).map {GridPosition(row: 9, col: $0)},
    ]
)

let Clothing_StoreData = GameLevelData(
    title: "Clothing Store",
    backgroundImage: "Clothingstore",
    answers: [
        [nil, nil, nil, nil, "p", nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, "a", nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, "c", "a", "p", nil, nil, nil, nil],
        [nil, nil, nil, nil, "k", nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, "b", nil, nil, nil, nil, nil, nil],
        [nil, nil, "g", "l", "a", "s", "s", "e", "s", nil, nil],
        [nil, nil, nil, nil, "c", nil, "h", nil, "h", nil, nil],
        [nil, nil, nil, nil, "k", nil, "o", nil, "i", nil, nil],
        [nil, nil, nil, nil, nil, nil, "e", nil, "r", nil, nil],
        [nil, "s", "h", "o", "r", "t", "s", nil, "t", nil, nil],
    ],
    numberHints: [
        ((0, 4), 1),
        ((2, 4), 2),
        ((5, 2), 3),
        ((5, 6), 4),
        ((5, 8), 5),
        ((9, 1), 6)
    ],
    acrossHints: [
        "2. Tom wore a c_p to block the sun.",
        "3. He wears g____es to read books",
        "6. I wear s___ts in summer."
    ],
    downHints: [
        "1. Grace opened his b______k.",
        "4. Noah got new running s__e(s). ",
        "5. Jason’s s___t has long sleeves ",
        "and buttons."
    ],
    game_vocabulary: [
        vocabularyList[43],
        vocabularyList[44],
        vocabularyList[45],
        vocabularyList[46],
        vocabularyList[47],
        vocabularyList[48]
        ],
    wordPositions: [
            "shirt": (5...9).map {GridPosition(row: $0, col: 8)},
            "shorts": (1...6).map {GridPosition(row: 9, col: $0)},
            "cap": (4...6).map {GridPosition(row: 2, col: $0)},
            "backpack": (0...7).map {GridPosition(row: $0, col: 4)},
            "glasses": (2...8).map {GridPosition(row: 5, col: $0)},
            "shoes": (5...9).map {GridPosition(row: $0, col: 6)},
    ]
)
