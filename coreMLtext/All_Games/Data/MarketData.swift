//
//  MarketData.swift
//  Englishot
//
//  Created by 陳姿縈 on 3/6/25.
//

import SwiftUI

let FruitData = GameLevelData(
    title: "Fruit",
    backgroundImage: "Fruit",
    answers: [
        [nil, nil, nil, nil, nil, "d", nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, "u", nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, "r", nil, nil, nil, nil, nil],
        [nil, nil, "k", "i", "w", "i", nil, nil, "g", nil, nil],
        [nil, nil, nil, nil, nil, "a", nil, nil, "r", nil, nil],
        [nil, nil, nil, "b", "a", "n", "a", "n", "a", nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil, "p", nil, nil],
        [nil, nil, nil, nil, "a", "p", "p", "l", "e", nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
    ],
    numberHints: [
        ((0, 5), 1),
        ((3, 2), 2),
        ((5, 3), 3),
        ((3, 8), 4),
        ((7, 4), 5)
    ],
    acrossHints: [
        "2. K__i looks brown and fuzzy on ",
        "the outside.",
        "3. I ate a b____a.",
        "5. The a___e is red."
    ],
    downHints: [
        "1. D____n is soft and creamy ",
        "inside, even though it smells ",
        "strong.",
        "4. I like purple g___e(s).",
    ],
    game_vocabulary: [
        vocabularyList[49],
        vocabularyList[50],
        vocabularyList[51],
        vocabularyList[52],
        vocabularyList[53]
        ],
    wordPositions: [
            "durian": (0...5).map {GridPosition(row: $0, col: 5)},
            "kiwi": (2...5).map {GridPosition(row: 3, col: $0)},
            "grape": (3...7).map {GridPosition(row: $0, col: 8)},
            "banana": (3...8).map {GridPosition(row: 5, col: $0)},
            "apple": (4...8).map {GridPosition(row: 7, col: $0)},
    ]
)

let VegetableData = GameLevelData(
    title: "Vegetable",
    backgroundImage: "Vegetable",
    answers: [
        [nil, nil, nil, nil, nil, nil, "p", nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, "u", nil, nil, "b", nil],
        [nil, nil, "c", "u", "c", "u", "m", "b", "e", "r", nil],
        [nil, nil, "a", nil, "a", nil, "p", nil, nil, "o", nil],
        [nil, nil, "b", nil, "r", nil, "k", nil, nil, "c", nil],
        [nil, nil, "b", nil, "r", nil, "i", nil, nil, "c", nil],
        [nil, nil, "a", nil, "o", nil, "n", nil, nil, "o", nil],
        [nil, nil, "g", nil, "t", nil, nil, nil, nil, "l", nil],
        [nil, nil, "e", nil, nil, nil, nil, nil, nil, "i", nil],
        [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
    ],
    numberHints: [
        ((0, 6), 1),
        ((1, 9), 2),
        ((2, 2), 3),
        ((2, 4), 4),
    ],
    acrossHints: [
        "3. Jason cut the c______r into ",
        "thin, round pieces.",
    ],
    downHints: [
        "1. He grows p_____n(s) in his ",
        "yard.",
        "2. B______i looks like tiny ",
        "green trees.",
        "3. The c_____e is green.",
        "4. Sophie’s rabbit loves fresh ",
        "c____t(s) from the garden.",
    ],
    game_vocabulary: [
        vocabularyList[54],
        vocabularyList[55],
        vocabularyList[56],
        vocabularyList[57],
        vocabularyList[58]
        ],
    wordPositions: [
            "pumpkin": (0...6).map {GridPosition(row: $0, col: 6)},
            "broccoli": (1...8).map {GridPosition(row: $0, col: 9)},
            "cabbage": (2...8).map {GridPosition(row: $0, col: 2)},
            "cucumber": (2...9).map {GridPosition(row: 2, col: $0)},
            "carrot": (2...7).map {GridPosition(row: $0, col: 4)},
    ]
)

let SpicesData = GameLevelData(
    title: "Spices",
    backgroundImage: "Spices",
    answers: [
        [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, "c", nil, nil, nil, "g", nil, nil, nil],
        [nil, nil, nil, "h", nil, nil, nil, "a", nil, nil, nil],
        [nil, nil, "g", "i", "n", "g", "e", "r", nil, nil, nil],
        [nil, nil, nil, "l", nil, nil, nil, "l", nil, nil, nil],
        [nil, nil, nil, "i", nil, "o", "n", "i", "o", "n", nil],
        [nil, nil, nil, nil, nil, nil, nil, "c", nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
    ],
    numberHints: [
        ((2, 3), 1),
        ((2, 7), 2),
        ((4, 2), 3),
        ((6, 5), 4),
    ],
    acrossHints: [
        "3. She added g____r to the soup. ",
        "4. When you cut an o___n, it can ",
        "make your eyes water.",
    ],
    downHints: [
        "1. C___i can be spicy.",
        "2. G____c is small and white with ",
        "a strong smell.",
    ],
    game_vocabulary: [
        vocabularyList[59],
        vocabularyList[60],
        vocabularyList[61],
        vocabularyList[62]
        ],
    wordPositions: [
            "chili": (2...6).map {GridPosition(row: $0, col: 3)},
            "garlic": (2...7).map {GridPosition(row: $0, col: 7)},
            "ginger": (2...7).map {GridPosition(row: 4, col: $0)},
            "onion": (5...9).map {GridPosition(row: 6, col: $0)},
    ]
)
