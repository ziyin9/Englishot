//
//  level1Data.swift
//  coreMLtext
//
//  Created by 李庭宇 on 2025/2/25.
//

import SwiftUI



let BathroomData = GameLevelData(
    levelID:"bathroom",
    title: "Bathroom",
    backgroundImage: "Bathroom_background",
    answers: [
        [nil, nil, nil, "t", nil, nil, nil, "t", nil, nil, nil],
        [nil, nil, "c", "o", "m", "b", nil, "o", nil, nil, nil],
        [nil, nil, nil, "o", nil, nil, nil, "i", nil, nil, nil],
        [nil, nil, nil, "t", "o", "w", "e", "l", nil, nil, nil],
        [nil, nil, nil, "h", nil, nil, nil, "e", nil, nil, nil],
        [nil, nil, nil, "b", nil, nil, nil, "t", nil, nil, nil],
        [nil, nil, nil, "r", nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, "u", nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, "s", "o", "a", "p", nil, nil, nil, nil],
        [nil, nil, nil, "h", nil, nil, nil, nil, nil, nil, nil],
    ],
    numberHints: [
        ((1, 2), 1),
        ((0, 7), 3),
        ((0, 3), 2),
        ((3, 3), 4),
        ((8, 3), 5)
    ],
    acrossHints: [
        "1. I use a c__b to style my hair.",
        "4. I dry my hands with a t___l.",
        "5. I wash my hands with s__p."
    ],
    downHints: [
        "2. I use my t________h to clean my teeth.",
        "3. Bob ran to the t____t because he had to pee."
    ],
    game_vocabulary: [
            vocabularyList[4],
            vocabularyList[5],
            vocabularyList[6],
            vocabularyList[7],
            vocabularyList[8]
        ],
    wordsToCheck: ["comb", "toothbrush", "toilet", "soap", "towel"],
    wordPositions: [
            "comb": (2...5).map {GridPosition(row: 1, col: $0)},
            "toothbrush": (0...9).map {GridPosition(row: $0, col: 3)},
            "toilet": (0...5).map {GridPosition(row: $0, col: 7)},
            "soap": (3...6).map {GridPosition(row: 8, col: $0)},
            "towel": (3...7).map {GridPosition(row: 3, col: $0)}
    ]
)



let KitchenData = GameLevelData(
    levelID:"kitchen",
    title: "Kitchen",
    backgroundImage: "Kitchen_background",
    answers: [
        [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, "f", nil, nil, nil, nil, nil],
        [nil, nil, "s", "p", "o", "o", "n", nil, nil, nil, nil],
        [nil, nil, nil, "l", nil, "r", nil, nil, nil, nil, nil],
        [nil, nil, nil, "a", nil, "k", "n", "i", "f", "e", nil],
        [nil, nil, nil, "t", nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, "e", nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
    ],
    numberHints: [
        ((2, 2), 2),
        ((1, 5), 1),
        ((2, 3), 3),
        ((4, 5), 4),
    ],
    acrossHints: [
        "1. I use a c__b to style my hair.",
        "4. I dry my hands with a t___l."
    ],
    downHints: [
        "2. I use my t________h to clean my teeth.",
        "3. Bob ran to the t____t because he had to pee."
    ],
    game_vocabulary: [
            vocabularyList[0],
            vocabularyList[1],
            vocabularyList[2],
            vocabularyList[3]
        ],
    wordsToCheck: ["spoon", "fork", "knife", "plate"],
    wordPositions: [
            "spoon": [GridPosition(row: 1, col: 2), GridPosition(row: 1, col: 3), GridPosition(row: 1, col: 4), GridPosition(row: 1, col: 5)],
            "fork": (1...4).map {GridPosition(row: $0, col: 5)},
            "knife": [GridPosition(row: 3, col: 3), GridPosition(row: 3, col: 4), GridPosition(row: 3, col: 5)],
            "plate": [GridPosition(row: 8, col: 3), GridPosition(row: 8, col: 4), GridPosition(row: 8, col: 5), GridPosition(row: 8, col: 6)],
    ]
)



let Living_roomData = GameLevelData(
    levelID:"living_room",
    title: "Living Room",
    backgroundImage: "Livingroom_background",
    answers: [
        [nil,nil, nil, nil, nil, "t", nil, nil, nil, nil, nil],
        [nil,nil, nil, nil, "k", "e", "y", nil, nil, nil, nil],
        [nil,nil, nil, nil, nil, "l", nil, nil, nil, nil, nil],
        [nil,nil, nil, nil, nil, "e", nil, nil, nil, nil, nil],
        [nil,nil, nil, nil, nil, "v", nil, nil, nil, nil, nil],
        [nil,nil, nil, nil, nil, "i", nil, nil, nil, nil, nil],
        [nil,nil, nil, nil, nil, "s", nil, nil, nil, nil, nil],
        [nil,nil, nil, nil, nil, "i", nil, "f", nil, nil, nil],
        [nil,nil, nil, nil, "s", "o", "f", "a", nil, nil, nil],
        [nil,nil, nil, nil, nil, "n", nil, "n", nil, nil, nil],
    ],
    numberHints: [
        ((1, 4), 1),
        ((8, 4), 2),
        ((0, 5), 3),
        ((7, 7), 4),
    ],
    acrossHints: [
        "3. Let’s watch cartoons on the t________n.",
        "4. He's keeping himself cool with a f_n."
    ],
    downHints: [
        "1. I lost my house k_y and couldn’t open the door.",
        "2. We bought a new s__a that is soft and very comfortable."
    ],
    game_vocabulary: [
            vocabularyList[4],
            vocabularyList[5],
            vocabularyList[6],
            vocabularyList[7],
            vocabularyList[8]
        ],
    wordsToCheck: ["comb", "toothbrush", "toilet", "soap", "towel"],
    wordPositions: [
            "comb": [GridPosition(row: 1, col: 2), GridPosition(row: 1, col: 3), GridPosition(row: 1, col: 4), GridPosition(row: 1, col: 5)],
            "toothbrush": [GridPosition(row: 0, col: 3), GridPosition(row: 1, col: 3), GridPosition(row: 2, col: 3)],
            "toilet": [GridPosition(row: 3, col: 3), GridPosition(row: 3, col: 4), GridPosition(row: 3, col: 5)],
            "soap": [GridPosition(row: 8, col: 3), GridPosition(row: 8, col: 4), GridPosition(row: 8, col: 5), GridPosition(row: 8, col: 6)],
            "towel": [GridPosition(row: 3, col: 5), GridPosition(row: 3, col: 6), GridPosition(row: 3, col: 7)]
    ]
)



let GarageData = GameLevelData(
    levelID:"garage",
    title: "Garage",
    backgroundImage: "Garage_background",
    answers: [
        [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, "t", nil, nil, "s", nil, nil, nil, nil],
        [nil, nil, "b", "i", "c", "y", "c", "l", "e", nil, nil],
        [nil, nil, nil, "r", nil, nil, "o", nil, nil, nil, nil],
        [nil, nil, nil, "e", nil, "b", "o", "x", nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, "t", nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, "e", nil, nil, nil, nil],
        [nil, nil, nil, nil, "c", "a", "r", nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
    ],
    numberHints: [
        ((2, 3), 1),
        ((3, 2), 3),
        ((2, 6), 2),
        ((5, 5), 4),
        ((8, 4), 5),
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
            vocabularyList[4],
            vocabularyList[5],
            vocabularyList[6],
            vocabularyList[7],
            vocabularyList[8]
        ],
    wordsToCheck: ["comb", "toothbrush", "toilet", "soap", "towel"],
    wordPositions: [
            "comb": [GridPosition(row: 1, col: 2), GridPosition(row: 1, col: 3), GridPosition(row: 1, col: 4), GridPosition(row: 1, col: 5)],
            "toothbrush": [GridPosition(row: 0, col: 3), GridPosition(row: 1, col: 3), GridPosition(row: 2, col: 3)],
            "toilet": [GridPosition(row: 3, col: 3), GridPosition(row: 3, col: 4), GridPosition(row: 3, col: 5)],
            "soap": [GridPosition(row: 8, col: 3), GridPosition(row: 8, col: 4), GridPosition(row: 8, col: 5), GridPosition(row: 8, col: 6)],
            "towel": [GridPosition(row: 3, col: 5), GridPosition(row: 3, col: 6), GridPosition(row: 3, col: 7)]
    ]
)
