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
        [nil, nil, nil, "o", nil, nil, nil, "o", nil, nil, nil],
        [nil, nil, nil, "o", nil, nil, nil, "i", nil, nil, nil],
        [nil, nil, nil, "t", "o", "w", "e", "l", nil, nil, nil],
        [nil, nil, nil, "h", nil, nil, nil, "e", nil, nil, nil],
        [nil, nil, nil, "b", nil, nil, nil, "t", nil, nil, nil],
        [nil, nil, nil, "r", nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, "c", "u", "p", nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, "s", nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, "h", nil, nil, nil, nil, nil, nil, nil],
    ],
    numberHints: [
        ((0, 3), 1),
        ((3, 3), 2),
        ((0, 7), 3),
        ((7, 2), 4),

    ],
    acrossHints: [
        "2. I dry my hands with a t___l.",
        "4. cup"
    ],
    downHints: [
        "1. I use my t________h to clean my teeth.",
        "3. Bob ran to the t____t because he had to pee."
    ],
    game_vocabulary: [
            vocabularyList[4],
            vocabularyList[5],
            vocabularyList[6],
            vocabularyList[7]
        ],
    wordPositions: [
            "toothbrush": (0...9).map
            {GridPosition(row: $0, col: 3)},
            "toilet": (0...5).map
            {GridPosition(row: $0, col: 7)},
            "cup": (2...4).map
            {GridPosition(row: 7, col: $0)},
            "towel": (3...7).map
            {GridPosition(row: 3, col: $0)}
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
    wordPositions: [
            "spoon":(2...7).map
            {GridPosition(row: 2, col: $0)},
            "fork": (1...4).map
            {GridPosition(row: $0, col: 5)},
            "knife": (5...9).map
            {GridPosition(row:4 , col: $0)},
            "plate": (2...6).map
            {GridPosition(row: $0 , col: 3)}
    ]
)



let Living_RoomData = GameLevelData(
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
            vocabularyList[8],
            vocabularyList[9],
            vocabularyList[10],
            vocabularyList[11],
        ],
    wordPositions: [
        "key": (4...6).map
        {GridPosition(row: 1, col: $0)},
        "television":  (0...9).map
        {GridPosition(row: $0, col: 5)},
        "sofa":  (4...7).map
        {GridPosition(row: 8, col: $0)},
        "fan": (7...9).map
        {GridPosition(row: $0, col: 7)},

    ]
)



let GarageData = GameLevelData(
    levelID:"garage",
    title: "Garage",
    backgroundImage: "Garage_background",
    answers: [
        [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, "c", nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, "a", nil, "t", nil, nil],
        [nil, nil, nil, nil, nil, nil, "r", nil, "i", nil, nil],
        [nil, nil, "s", "c", "o", "o", "t", "e", "r", nil, nil],
        [nil, nil, nil, "a", nil, nil, "o", nil, "e", nil, nil],
        [nil, nil, nil, "r", nil, nil, "n", nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],

    ],
    numberHints: [
        ((1, 6), 1),
        ((2, 8), 2),
        ((4, 2), 3),
        ((4, 3), 4)
    ],
    acrossHints: [
        "3.I use my b__e to go to the park with my friends. It has two wheels and you pedal it."
    ],
    downHints: [
        "1. carton",
        "2. tire",
        "4. car"
    ],
    game_vocabulary: [
            vocabularyList[12],
            vocabularyList[13],
            vocabularyList[14],
            vocabularyList[15]
        ],
    wordPositions: [
            
            "tire": (2...5).map
            {GridPosition(row: $0, col: 8)},
            "scooter":  (2...8).map
            {GridPosition(row: 4, col: $0)},
            "carton":  (1...6).map
            {GridPosition(row:$0 , col: 6)},
            "car": (4...6).map
            {GridPosition(row:$0 , col: 3)},
    ]
)
