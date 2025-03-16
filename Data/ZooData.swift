//
//  ZooData.swift
//  Englishot
//
//  Created by 陳姿縈 on 3/6/25.
//

import SwiftUI

let Mammals1Data = GameLevelData(
    title: "Mammals1",
    backgroundImage: "Mammals1",
    answers: [
        [nil, nil, nil, "m", nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, "o", nil, nil, "g", nil, nil, nil, nil],
        [nil, nil, nil, "n", nil, nil, "i", nil, nil, nil, nil],
        [nil, "z", nil, "k", nil, nil, "r", nil, nil, nil, nil],
        [nil, "e", "l", "e", "p", "h", "a", "n", "t", nil, nil],
        [nil, "b", nil, "y", nil, nil, "f", nil, nil, nil, nil],
        [nil, "r", nil, nil, "l", nil, "f", nil, nil, nil, nil],
        [nil, "a", nil, "t", "i", "g", "e", "r", nil, nil, nil],
        [nil, nil, nil, nil, "o", nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, "n", nil, nil, nil, nil, nil, nil],
    ],
    numberHints: [
        ((0, 3), 1),
        ((1, 6), 2),
        ((3, 1), 3),
        ((4, 1), 4),
        ((6, 4), 5),
        ((7, 3), 6),
    ],
    acrossHints: [
    ],
    downHints: [
    ],
    game_vocabulary: [
        vocabularyList[63],
        vocabularyList[64],
        vocabularyList[65],
        vocabularyList[66],
        vocabularyList[67],
        vocabularyList[68]
    ],
    wordPositions: [
            "lion": (6...9).map {GridPosition(row: $0, col: 4)},
            "tiger": (3...7).map {GridPosition(row: 7, col: $0)},
            "elephant": (1...8).map {GridPosition(row: 4, col: $0)},
            "giraffe": (1...7).map {GridPosition(row: $0, col: 6)},
            "zebra": (3...7).map {GridPosition(row: $0, col: 1)},
            "monkey": (0...5).map {GridPosition(row: $0, col: 3)},
    ]
)

let Mammals2Data = GameLevelData(
    title: "Mammals2",
    backgroundImage: "Mammals2",
    answers: [
        [nil, nil, nil, "k", nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, "o", nil, nil, "k", nil, nil, nil, nil],
        [nil, nil, "p", "a", "n", "d", "a", nil, nil, nil, nil],
        [nil, nil, nil, "l", nil, nil, "n", nil, nil, nil, nil],
        [nil, "b", "e", "a", "r", nil, "g", nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, "a", nil, nil, nil, nil],
        [nil, nil, "s", "q", "u", "i", "r", "r", "e", "l", nil],
        [nil, nil, nil, nil, nil, nil, "o", nil, nil, nil, nil],
        [nil, nil, nil, nil, "s", "l", "o", "t", "h", nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
    ],
    numberHints: [
        ((0, 3), 1),
        ((1, 6), 2),
        ((2, 2), 3),
        ((4, 1), 4),
        ((6, 2), 5),
        ((8, 4), 6),
    ],
    acrossHints: [
    ],
    downHints: [
    ],
    game_vocabulary: [
        vocabularyList[69],
        vocabularyList[70],
        vocabularyList[71],
        vocabularyList[72],
        vocabularyList[73],
        vocabularyList[74],
    ],
    wordPositions: [
            "koala": (0...4).map {GridPosition(row: $0, col: 3)},
            "squirrel": (2...9).map {GridPosition(row: 6, col: $0)},
            "sloth": (4...8).map {GridPosition(row: 8, col: $0)},
            "bear": (1...4).map {GridPosition(row: 4, col: $0)},
            "panda": (2...6).map {GridPosition(row: 2, col: $0)},
            "kangaroo": (1...8).map {GridPosition(row: $0, col: 6)},
    ]
)

let Mammals3Data = GameLevelData(
    title: "Mammals3",
    backgroundImage: "Mammals3",
    answers: [
        [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, "w", nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, "f", "o", "x", nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, "l", nil, "c", nil, nil, nil, nil],
        [nil, nil, "b", "u", "f", "f", "a", "l", "o", nil, nil],
        [nil, nil, nil, nil, nil, nil, "m", nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, "d", "e", "e", "r", nil, nil],
        [nil, nil, nil, nil, nil, nil, "l", nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
    ],
    numberHints: [
        ((1, 4), 1),
        ((2, 3), 2),
        ((3, 6), 3),
        ((4, 2), 4),
        ((6, 5), 5),
    ],
    acrossHints: [
    ],
    downHints: [
    ],
    game_vocabulary: [
        vocabularyList[75],
        vocabularyList[76],
        vocabularyList[77],
        vocabularyList[78],
        vocabularyList[79]
    ],
    wordPositions: [
            "camel": (3...7).map {GridPosition(row: $0, col: 6)},
            "buffalo": (2...8).map {GridPosition(row: 4, col: $0)},
            "deer": (5...8).map {GridPosition(row: 6, col: $0)},
            "wolf": (1...4).map {GridPosition(row: $0, col: 4)},
            "fox": (3...5).map {GridPosition(row: 2, col: $0)},
    ]
)

let Marine_AnimalsData = GameLevelData(
    title: "Marine Animals",
    backgroundImage: "Marineanimals",
    answers: [
        [nil, nil, nil, nil, nil, nil, nil, nil, nil, "w", nil],
        [nil, "j", "e", "l", "l", "y", "f", "i", "s", "h", nil],
        [nil, nil, nil, nil, nil, nil, nil, nil, nil, "a", nil],
        [nil, nil, nil, nil, nil, nil, "d", nil, nil, "l", nil],
        [nil, nil, "s", "e", "a", "h", "o", "r", "s", "e", nil],
        [nil, nil, nil, nil, nil, nil, "l", nil, "h", nil, nil],
        [nil, nil, nil, nil, nil, nil, "p", nil, "a", nil, nil],
        [nil, nil, nil, nil, nil, nil, "h", nil, "r", nil, nil],
        [nil, nil, nil, nil, nil, nil, "i", nil, "k", nil, nil],
        [nil, nil, nil, nil, nil, nil, "n", nil, nil, nil, nil],
       
    ],
    numberHints: [
        ((0, 9), 1),
        ((1, 1), 2),
        ((3, 6), 3),
        ((4, 2), 4),
        ((4, 8), 5),
    ],
    acrossHints: [
    ],
    downHints: [
    ],
    game_vocabulary: [
        vocabularyList[80],
        vocabularyList[81],
        vocabularyList[82],
        vocabularyList[83]
        ],
    wordPositions: [
            "dolphin": (3...9).map {GridPosition(row: $0, col: 6)},
            "shark": (4...8).map {GridPosition(row: $0, col: 8)},
            "whale": (0...4).map {GridPosition(row: $0, col: 9)},
            "jellyfish": (1...9).map {GridPosition(row: 1, col: $0)},
            "seahorse": (2...8).map {GridPosition(row: 4, col: $0)},
    ]
)

let BirdsData = GameLevelData(
    title: "Birds",
    backgroundImage: "Birds",
    answers: [
        [nil, nil, nil, nil, nil, nil, nil, "o", "w", "l", nil],
        [nil, nil, nil, nil, nil, nil, nil, "s", nil, nil, nil],
        [nil, nil, "p", "a", "r", "r", "o", "t", nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, "r", nil, nil, nil],
        [nil, nil, "p", "e", "n", "g", "u", "i", "n", nil, nil],
        [nil, nil, nil, "a", nil, nil, nil, "c", nil, nil, nil],
        [nil, nil, nil, "g", nil, nil, nil, "h", nil, nil, nil],
        [nil, nil, nil, "l", nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, "e", nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
    ],
    numberHints: [
        ((0, 7), 1),
        ((2, 2), 2),
        ((4, 2), 3),
        ((4, 3), 4),
    ],
    acrossHints: [
    ],
    downHints: [
    ],
    game_vocabulary: [
        vocabularyList[84],
        vocabularyList[85],
        vocabularyList[86],
        vocabularyList[87],
    ],
    wordPositions: [
            "parrot": (2...7).map {GridPosition(row: 2, col: $0)},
            "owl": (7...9).map {GridPosition(row: 0, col: $0)},
            "eagle": (4...8).map {GridPosition(row: $0, col: 3)},
            "penguin": (2...8).map {GridPosition(row: 4, col: $0)},
            "ostrich": (0...6).map {GridPosition(row: $0, col: 7)},
    ]
)
