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
        "1. The t__e of my bike is flat, so I need to pump it up. It helps the bike roll.",
        "3.I use my b__e to go to the park with my friends. It has two wheels and you pedal it."
    ],
    downHints: [
        "2. I use my t________h to clean my teeth.",
        "3. Bob ran to the t____t because he had to pee.",
        "5. My dad drives a cr to work. It has four wheels and you need a key to start it."
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
        "1. The t__e of my bike is flat, so I need to pump it up. It helps the bike roll.",
        "3.I use my b__e to go to the park with my friends. It has two wheels and you pedal it."
    ],
    downHints: [
        "2. I use my t________h to clean my teeth.",
        "3. Bob ran to the t____t because he had to pee.",
        "5. My dad drives a cr to work. It has four wheels and you need a key to start it."
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
        "1. The t__e of my bike is flat, so I need to pump it up. It helps the bike roll.",
        "3.I use my b__e to go to the park with my friends. It has two wheels and you pedal it."
    ],
    downHints: [
        "2. I use my t________h to clean my teeth.",
        "3. Bob ran to the t____t because he had to pee.",
        "5. My dad drives a cr to work. It has four wheels and you need a key to start it."
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
