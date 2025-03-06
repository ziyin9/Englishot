//
//  Vocabulary.swift
//  coreMLtext
//
//  Created by 陳姿縈 on 1/20/25.
//






import Foundation
import SwiftUI


struct Vocabulary: Identifiable {
    var id = UUID()
    var category: String
    var E_word: String
    var C_word: String
    var exSentence: String
    var audioURL: String
    var shotImage: UIImage?
    var unlock: Bool = false
}


class GameState: ObservableObject {
    @Published var showingCamera: Bool = false
    
    @Published var ForkFound: Bool = false
    @Published var KnifeFound: Bool = false
    @Published var PlateFound: Bool = false
    @Published var SpoonFound: Bool = false
    
    @Published var CombFound: Bool = false
    @Published var ToothbrushFound: Bool = false
    @Published var ToiletFound: Bool = false
    @Published var SoapFound: Bool = false
    @Published var TowelFound: Bool = false
    
    
}

var vocabularyList: [Vocabulary] = [
    
// MARK: - Home
    //kitchen
    Vocabulary(
        //0
        category: "Kitchen",E_word: "spoon",C_word: "湯匙",
        exSentence: "I use a spoon to eat my cereal.",
        audioURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/s/spo/spoon/spoon.mp3"
    ),
    Vocabulary(
        //1
        category: "Kitchen",E_word: "fork",C_word: "叉子",
        exSentence: "She eats pasta with a fork.",
        audioURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/f/for/fork_/fork.mp3"
    ),
    Vocabulary(
        //2
        category: "Kitchen",E_word: "plate",C_word: "盤子",
        exSentence: "Put the cake on the plate.",
        audioURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/p/pla/plate/plate.mp3"
    ),
    Vocabulary(
        //3
        category: "Kitchen",E_word: "knife",C_word: "刀",
        exSentence: "I used a knife to cut the vegetable.",
        audioURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/k/kni/knife/knife.mp3"
    ),
    
    
    //batchroom
    Vocabulary(
        //4
        category: "Bathroom",E_word: "toothbrush",C_word: "牙刷",
        exSentence: "I use my toothbrush to clean my teeth.",
        audioURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/u/ust/uston/ustones010.mp3"
    ),
    Vocabulary(
        //5
        category: "Bathroom",E_word: "towel",C_word: "毛巾",
        exSentence: "I dry my hands with a towel.",
        audioURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/t/tow/towel/towel.mp3"
    ),
    Vocabulary(
        //6
        category: "Bathroom",E_word: "toilet",C_word: "馬桶",
        exSentence: "I always clean the toilet to keep it fresh.",
        audioURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/t/toi/toile/toilet.mp3"
    ),
    Vocabulary(
        //7
        category: "Bathroom",E_word: "cup",C_word: "杯子",
        exSentence: "cup",
        audioURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/c/cup/cup__/cup.mp3"
    ),
    
    
    //Livingroom
    Vocabulary(
        //8
        category: "Livingroom",E_word: "key",C_word: "鑰匙",
        exSentence: "key.",
        audioURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/k/key/key__/key.mp3"
    ),
    Vocabulary(
        //9
        category: "Livingroom",E_word: "television",C_word: "電視",
        exSentence: "television.",
        audioURL: ""
    ),
    Vocabulary(
        //10
        category: "Livingroom",E_word: "sofa",C_word: "沙發",
        exSentence: "sofa.",
        audioURL: ""
    ),
    Vocabulary(
        //11
        category: "Livingroom",E_word: "fan",C_word: "電風扇",
        exSentence: "fan",
        audioURL: ""
    ),
    
    
    
    //Garage
    Vocabulary(
        //12
        category: "Garage",E_word: "tire",C_word: "輪胎",
        exSentence: "tire",
        audioURL: ""
    ),
    Vocabulary(
        //13
        category: "Garage",E_word: "scooter",C_word: "機車",
        exSentence: "scooter.",
        audioURL: ""
    ),
    Vocabulary(
        //14
        category: "Garage",E_word: "carton",C_word: "紙箱",
        exSentence: "carton",
        audioURL: ""
    ),
    Vocabulary(
        //15
        category: "Garage",E_word: "car",C_word: "汽車",
        exSentence: "car.",
        audioURL: ""
    ),
    
    
    
    
    
    
    // MARK: - School
    //Classroom1
    Vocabulary(
        //16
        category: "School",E_word: "scissors",C_word: "剪刀",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //17
        category: "School",E_word: "stapler",C_word: "訂書機",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //18
        category: "School",E_word: "pencil",C_word: "鉛筆",
        exSentence: "car.",
        audioURL: ""
    ),
    
    //Classroom2
    Vocabulary(
        //19
        category: "Classroom2",E_word: "calculator",C_word: "計算機",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //20
        category: "Classroom2",E_word: "broom",C_word: "掃把",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //21
        category: "Classroom2",E_word: "mop",C_word: "拖把",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //22
        category: "Classroom2",E_word: "clock",C_word: "時鐘",
        exSentence: "car.",
        audioURL: ""
    ),
    
    
    //Music
    Vocabulary(
        //23
        category: "Music",E_word: "drum",C_word: "鼓",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //24
        category: "Music",E_word: "piano",C_word: "鋼琴",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //25
        category: "Music",E_word: "recorder",C_word: "直笛",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //26
        category: "Music",E_word: "note",C_word: "音符",
        exSentence: "car.",
        audioURL: ""
    ),
    
    
    //Playground
    Vocabulary(
        //27
        category: "Playground",E_word: "slide",C_word: "溜滑梯",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //28
        category: "Playground",E_word: "swing",C_word: "盪鞦韆",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //29
        category: "Playground",E_word: "seesaw",C_word: "翹翹板",
        exSentence: "car.",
        audioURL: ""
    ),
    
    //Sports
    Vocabulary(
        //30
        category: "Sports",E_word: "basketball",C_word: "籃球",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //31
        category: "Sports",E_word: "soccer",C_word: "足球",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //32
        category: "Sports",E_word: "tennis",C_word: "網球",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //33
        category: "Sports",E_word: "badminton",C_word: "羽毛球",
        exSentence: "car.",
        audioURL: ""
    ),
    
    // MARK: - Mall
    
    //Food
    Vocabulary(
        //34
        category: "Food",E_word: "pizza",C_word: "披薩",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //35
        category: "Food",E_word: "pasta",C_word: "義大利麵",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //36
        category: "Food",E_word: "dumpling",C_word: "水餃",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //37
        category: "Food",E_word: "hamburger",C_word: "漢堡",
        exSentence: "car.",
        audioURL: ""
    ),
    
    //ElectronicsStore
    Vocabulary(
        //38
        category: "ElectronicsStore",E_word: "badminton",C_word: "羽毛球",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //39
        category: "ElectronicsStore",E_word: "badminton",C_word: "羽毛球",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //40
        category: "ElectronicsStore",E_word: "badminton",C_word: "羽毛球",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //41
        category: "ElectronicsStore",E_word: "badminton",C_word: "羽毛球",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //42
        category: "ElectronicsStore",E_word: "badminton",C_word: "羽毛球",
        exSentence: "car.",
        audioURL: ""
    ),
    
    //ClothingStore
    Vocabulary(
        //43
        category: "ClothingStore",E_word: "badminton",C_word: "羽毛球",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //44
        category: "ClothingStore",E_word: "badminton",C_word: "羽毛球",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //45
        category: "ClothingStore",E_word: "badminton",C_word: "羽毛球",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //46
        category: "ClothingStore",E_word: "badminton",C_word: "羽毛球",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //47
        category: "ClothingStore",E_word: "badminton",C_word: "羽毛球",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //48
        category: "ClothingStore",E_word: "badminton",C_word: "羽毛球",
        exSentence: "car.",
        audioURL: ""
    ),
    
    // MARK: - Market

    //Fruit
    Vocabulary(
        //49
        category: "Fruit",E_word: "durian",C_word: "榴蓮",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //50
        category: "Fruit",E_word: "kiwi",C_word: "奇異果",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //51
        category: "Fruit",E_word: "grape",C_word: "葡萄",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //52
        category: "Fruit",E_word: "banana",C_word: "香蕉",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //53
        category: "Fruit",E_word: "apple",C_word: "蘋果",
        exSentence: "car.",
        audioURL: ""
    ),
    
    
    //Vegetable
    Vocabulary(
        //54
        category: "Vegetable",E_word: "pumpkin",C_word: "南瓜",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //55
        category: "Vegetable",E_word: "broccoli",C_word: "花椰菜",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //56
        category: "Vegetable",E_word: "cabbage",C_word: "高麗菜",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //57
        category: "Vegetable",E_word: "cucumber",C_word: "小黃瓜",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //58
        category: "Vegetable",E_word: "carrot",C_word: "紅蘿蔔",
        exSentence: "car.",
        audioURL: ""
    ),
    
    
    
    //Spice
    Vocabulary(
        //59
        category: "Spice",E_word: "chili",C_word: "辣椒",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //60
        category: "Spice",E_word: "garlic",C_word: "蒜頭",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //61
        category: "Spice",E_word: "ginger",C_word: "薑",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //62
        category: "Spice",E_word: "onion",C_word: "洋蔥",
        exSentence: "car.",
        audioURL: ""
    ),
    
    //MARK: -Zoo
    
    //Mammals1
    Vocabulary(
        //63
        category: "Mammals1",E_word: "lion",C_word: "獅子",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //64
        category: "Mammals1",E_word: "tiger",C_word: "老虎",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //65
        category: "Mammals1",E_word: "elephant",C_word: "大象",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //66
        category: "Mammals1",E_word: "giraffe",C_word: "長頸鹿",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //67
        category: "Mammals1",E_word: "zebra",C_word: "斑馬",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //68
        category: "Mammals1",E_word: "monkey",C_word: "猴子",
        exSentence: "car.",
        audioURL: ""
    ),
    
    
    
    //Mammals2
    Vocabulary(
        //69
        category: "Mammals2",E_word: "koala",C_word: "無尾熊",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //70
        category: "Mammals2",E_word: "squirrel",C_word: "松鼠",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //71
        category: "Mammals2",E_word: "sloth",C_word: "樹懶",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //72
        category: "Mammals2",E_word: "bear",C_word: "熊",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //73
        category: "Mammals2",E_word: "panda",C_word: "熊貓",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //74
        category: "Mammals2",E_word: "kangaroo",C_word: "袋鼠",
        exSentence: "car.",
        audioURL: ""
    ),
    
    
    
    //Mammals3
    Vocabulary(
        //75
        category: "Mammals3",E_word: "camel",C_word: "駱駝",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //76
        category: "Mammals3",E_word: "buffalo",C_word: "水牛",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //77
        category: "Mammals3",E_word: "deer",C_word: "鹿",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //78
        category: "Mammals3",E_word: "wolf",C_word: "狼",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //79
        category: "Mammals3",E_word: "fox",C_word: "狐狸",
        exSentence: "car.",
        audioURL: ""
    ),
    
    
    
    
    //MarineAnimal
    Vocabulary(
        //80
        category: "MarineAnimal",E_word: "dolphin",C_word: "海豚",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //81
        category: "MarineAnimal",E_word: "shark",C_word: "鯊魚",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //82
        category: "MarineAnimal",E_word: "jellyfish",C_word: "水母",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //83
        category: "MarineAnimal",E_word: "seahorse",C_word: "海馬",
        exSentence: "car.",
        audioURL: ""
    ),
    
    
    //Birds
    Vocabulary(
        //84
        category: "Birds",E_word: "parrot",C_word: "鸚鵡",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //85
        category: "Birds",E_word: "owl",C_word: "貓頭鷹",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //86
        category: "Birds",E_word: "penguin",C_word: "企鵝",
        exSentence: "car.",
        audioURL: ""
    ),
    Vocabulary(
        //87
        category: "Birds",E_word: "ostrich",C_word: "鴕鳥",
        exSentence: "car.",
        audioURL: ""
    ),
    
    
    
    
]

