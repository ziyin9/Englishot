//
//  SchoolData.swift
//  Englishot
//
//  Created by 陳姿縈 on 3/6/25.
//

import SwiftUI

let Classroom1Data = GameLevelData(
    levelID:"classroom1",
    title: "Classroom1",
    backgroundImage: "Classroom1_background",
    answers: [
        [nil,nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
        [nil,nil, "s", "t", "a", "p", "l", "e", "r", nil, nil],
        [nil,nil, "c", nil, nil, "e", nil, nil, nil, nil, nil],
        [nil,nil, "i", nil, nil, "n", nil, nil, nil, nil, nil],
        [nil,nil, "s", nil, nil, "c", nil, nil, nil, nil, nil],
        [nil,nil, "s", nil, nil, "i", nil, nil, nil, nil, nil],
        [nil,nil, "o", nil, nil, "l", nil, nil, nil, nil, nil],
        [nil,nil, "r", nil, nil, nil, nil, nil, nil, nil, nil],
        [nil,nil, "s", nil, nil, nil, nil, nil, nil, nil, nil],
        [nil,nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
                
    ],
    numberHints: [
        ((1, 2), 1),
        ((1, 5), 2),
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
        vocabularyList[16],
        vocabularyList[17],
        vocabularyList[18]
        ],
    wordPositions: [
            "scissors": (1...8).map {GridPosition(row: $0, col: 2)},
            "stapler": (2...8).map {GridPosition(row: 1, col: $0)},
            "pencil": (1...6).map {GridPosition(row: $0, col: 5)},
    ]
    
    
)

let Classroom2Data = GameLevelData(
    levelID:"classroom2",
    title: "Classroom2",
    backgroundImage: "Classroom2_background",
    answers: [
        [nil,nil, nil, nil, "c", nil, nil, nil, nil, nil, nil],
        [nil,nil, nil, nil, "a", nil, nil, nil, nil, nil, nil],
        [nil,nil, nil, nil, "l", nil, "m", nil, nil, nil, nil],
        [nil,nil, nil, nil, "c", "l", "o", "c", "k", nil, nil],
        [nil,nil, nil, nil, "u", nil, "p", nil, nil, nil, nil],
        [nil,nil, nil, nil, "l", nil, nil, nil, nil, nil, nil],
        [nil,nil, nil, nil, "a", nil, nil, nil, nil, nil, nil],
        [nil,nil, nil, nil, "t", nil, nil, nil, nil, nil, nil],
        [nil,"b", "r", "o", "o", "m", nil, nil, nil, nil, nil],
        [nil,nil, nil, nil, "r", nil, nil, nil, nil, nil, nil],
                
    ],
    numberHints: [
        ((0, 4), 1),
        ((2, 6), 2),
        ((3, 4), 3),
        ((8, 1), 4),
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
        vocabularyList[19],
        vocabularyList[20],
        vocabularyList[21],
        vocabularyList[22]
        ],
    wordPositions: [
            "calculator": (0...9).map {GridPosition(row: $0, col: 4)},
            "broom": (1...5).map {GridPosition(row: 8, col: $0)},
            "mop": (2...4).map {GridPosition(row: $0, col: 6)},
            "clock": (4...8).map {GridPosition(row: 3, col: $0)},
    ]
    
    
)

let MusicData = GameLevelData(
    levelID:"music",
    title: "Music",
    backgroundImage: "Music_background",
    answers: [
        [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, "d", "r", "u", "m", nil, nil, nil],
        [nil, nil, nil, nil, nil, "e", nil, nil, nil, nil, nil],
        [nil, nil, nil, "p", nil, "c", nil, nil, nil, nil, nil],
        [nil, nil, nil, "i", nil, "o", nil, nil, nil, nil, nil],
        [nil, nil, nil, "a", nil, "r", nil, nil, nil, nil, nil],
        [nil, nil, nil, "n", nil, "d", nil, nil, nil, nil, nil],
        [nil, nil, "n", "o", "t", "e", nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, "r", nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
        
                
    ],
    numberHints: [
        ((2, 5), 1),
        ((2, 6), 2),
        ((4, 4), 3),
        ((8, 3), 4),
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
        vocabularyList[23],
        vocabularyList[24],
        vocabularyList[25],
        vocabularyList[26]
        ],
    wordPositions: [
            "drum": (5...8).map {GridPosition(row: 2, col: $0)},
            "piano": (4...8).map {GridPosition(row: $0, col: 4)},
            "recorder": (2...9).map {GridPosition(row: $0, col: 6)},
            "note": (3...6).map {GridPosition(row: 8, col: $0)},
    ]
    
    
)

let PlaygroundData = GameLevelData(
    levelID:"playground",
    title: "Playground",
    backgroundImage: "Playground_background",
    answers: [
        [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, "s", nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, "e", nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, "e", nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, "s", "l", "i", "d", "e", nil, nil],
        [nil, nil, nil, nil, "a", nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, "s", "w", "i", "n", "g", nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
        
                
    ],
    numberHints: [
        ((2, 4), 1),
        ((5, 4), 2),
        ((7, 3), 3),
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
        vocabularyList[27],
        vocabularyList[28],
        vocabularyList[29]
        ],
    wordPositions: [
            "slide": (4...8).map {GridPosition(row: 5, col: $0)},
            "swing": (3...7).map {GridPosition(row: 7, col: $0)},
            "seesaw": (2...7).map {GridPosition(row: $0, col: 4)},
    ]
)

let SportsData = GameLevelData(
    levelID:"sports",
    title: "Sports",
    backgroundImage: "Sports_background",
    answers: [
        [nil,"b", nil, nil, nil, nil, nil, nil, nil, nil, nil],
        [nil,"a", nil, nil, nil, nil, nil, nil, nil, nil, nil],
        [nil,"s", "o", "c", "c", "e", "r", nil, nil, nil, nil],
        [nil,"k", nil, nil, nil, nil, nil, nil, nil, nil, nil],
        [nil,"e", nil, nil, nil, nil, "t", nil, nil, nil, nil],
        [nil,"t", nil, nil, nil, nil, "e", nil, nil, nil, nil],
        [nil,"b", "a", "d", "m", "i", "n", "t", "o", "n", nil],
        [nil,"a", nil, nil, nil, nil, "n", nil, nil, nil, nil],
        [nil,"l", nil, nil, nil, nil, "i", nil, nil, nil, nil],
        [nil,"l", nil, nil, nil, nil, "s", nil, nil, nil, nil],
    ],
    numberHints: [
        ((0, 1), 1),
        ((2, 1), 2),
        ((4, 6), 3),
        ((6, 1), 4),
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
        vocabularyList[30],
        vocabularyList[31],
        vocabularyList[32],
        vocabularyList[33]
        ],
    wordPositions: [
            "basketball": (0...9).map {GridPosition(row: $0, col: 1)},
            "soccer": (1...6).map {GridPosition(row: 2, col: $0)},
            "tennis": (4...9).map {GridPosition(row: $0, col: 6)},
            "badminton": (1...9).map {GridPosition(row: 6, col: $0)},
    ]
)
