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
    var bigtopic: String
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
        bigtopic: "Home",
        category: "Kitchen",E_word: "spoon",C_word: "湯匙",
        exSentence: "I use a spoon to eat my cereal.",
        audioURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/s/spo/spoon/spoon.mp3"
    ),
    Vocabulary(
        //1
        bigtopic: "Home",
        category: "Kitchen",E_word: "fork",C_word: "叉子",
        exSentence: "She eats pasta with a fork.",
        audioURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/f/for/fork_/fork.mp3"
    ),
    Vocabulary(
        //2
        bigtopic: "Home",
        category: "Kitchen",E_word: "plate",C_word: "盤子",
        exSentence: "Put the cake on the plate.",
        audioURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/p/pla/plate/plate.mp3"
    ),
    Vocabulary(
        //3
        bigtopic: "Home",
        category: "Kitchen",E_word: "knife",C_word: "刀",
        exSentence: "I used a knife to cut the vegetable.",
        audioURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/k/kni/knife/knife.mp3"
    ),
    
    
    //batchroom
    Vocabulary(
        //4
        bigtopic: "Home",
        category: "Bathroom",E_word: "toothbrush",C_word: "牙刷",
        exSentence: "I use my toothbrush to clean my teeth.",
        audioURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/u/ust/uston/ustones010.mp3"
    ),
    Vocabulary(
        //5
        bigtopic: "Home",
        category: "Bathroom",E_word: "towel",C_word: "毛巾",
        exSentence: "I dry my hands with a towel.",
        audioURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/t/tow/towel/towel.mp3"
    ),
    Vocabulary(
        //6
        bigtopic: "Home",
        category: "Bathroom",E_word: "toilet",C_word: "馬桶",
        exSentence: "I always clean the toilet to keep it fresh.",
        audioURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/t/toi/toile/toilet.mp3"
    ),
    Vocabulary(
        //7
        bigtopic: "Home",
        category: "Bathroom",E_word: "cup",C_word: "杯子",
        exSentence: "cup",
        audioURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/c/cup/cup__/cup.mp3"
    ),
    
    
    //Livingroom
    Vocabulary(
        //8
        bigtopic: "Home",
        category: "Livingroom",E_word: "key",C_word: "鑰匙",
        exSentence: "key.",
        audioURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/k/key/key__/key.mp3"
    ),
    Vocabulary(
        //9
        bigtopic: "Home",
        category: "Livingroom",E_word: "television",C_word: "電視",
        exSentence: "television.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/t/tel/telev/television.mp3"
    ),
    Vocabulary(
        //10
        bigtopic: "Home",
        category: "Livingroom",E_word: "sofa",C_word: "沙發",
        exSentence: "sofa.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/s/sof/sofa_/sofa.mp3"
    ),
    Vocabulary(
        //11
        bigtopic: "Home",
        category: "Livingroom",E_word: "fan",C_word: "電風扇",
        exSentence: "fan",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/f/fan/fan__/fan.mp3"
    ),
    
    
    
    //Garage
    Vocabulary(
        //12
        bigtopic: "Home",
        category: "Garage",E_word: "tire",C_word: "輪胎",
        exSentence: "tire",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/t/tir/tire_/tire.mp3"
    ),
    Vocabulary(
        //13
        bigtopic: "Home",
        category: "Garage",E_word: "scooter",C_word: "機車",
        exSentence: "scooter.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/e/eus/eus74/eus74105.mp3"
    ),
    Vocabulary(
        //14
        bigtopic: "Home",
        category: "Garage",E_word: "carton",C_word: "紙箱",
        exSentence: "carton",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/c/car/carto/carton.mp3"
    ),
    Vocabulary(
        //15
        bigtopic: "Home",
        category: "Garage",E_word: "car",C_word: "汽車",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/c/car/car__/car.mp3"
    ),
    
    
    
    
    
    
    // MARK: - School
    //Classroom1
    Vocabulary(
        //16
        bigtopic: "School",
        category: "School",E_word: "scissors",C_word: "剪刀",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/s/sci/sciss/scissors.mp3"
    ),
    Vocabulary(
        //17
        bigtopic: "School",
        category: "School",E_word: "stapler",C_word: "訂書機",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/s/sta/stapl/stapler.mp3"
    ),
    Vocabulary(
        //18
        bigtopic: "School",
        category: "School",E_word: "pencil",C_word: "鉛筆",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/e/eus/eus73/eus73475.mp3"
    ),
    
    //Classroom2
    Vocabulary(
        //19
        bigtopic: "School",
        category: "Classroom2",E_word: "calculator",C_word: "計算機",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/c/cal/calcu/calculator.mp3"
    ),
    Vocabulary(
        //20
        bigtopic: "School",
        category: "Classroom2",E_word: "broom",C_word: "掃把",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/b/bro/broom/broom.mp3"
    ),
    Vocabulary(
        //21
        bigtopic: "School",
        category: "Classroom2",E_word: "mop",C_word: "拖把",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/m/mop/mop__/mop.mp3"
    ),
    Vocabulary(
        //22
        bigtopic: "School",
        category: "Classroom2",E_word: "clock",C_word: "時鐘",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/c/clo/clock/clock.mp3"
    ),
    
    
    //Music
    Vocabulary(
        //23
        bigtopic: "School",
        category: "Music",E_word: "drum",C_word: "鼓",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/d/dru/drum_/drum.mp3"
    ),
    Vocabulary(
        //24
        bigtopic: "School",
        category: "Music",E_word: "piano",C_word: "鋼琴",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/p/pia/piano/piano.mp3"
    ),
    Vocabulary(
        //25
        bigtopic: "School",
        category: "Music",E_word: "recorder",C_word: "直笛",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/r/rec/recor/recorder.mp3"
    ),
    Vocabulary(
        //26
        bigtopic: "School",
        category: "Music",E_word: "note",C_word: "音符",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/n/not/note_/note.mp3"
    ),
    
    
    //Playground
    Vocabulary(
        //27
        bigtopic: "School",
        category: "Playground",E_word: "slide",C_word: "溜滑梯",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/s/sli/slide/slide.mp3"
    ),
    Vocabulary(
        //28
        bigtopic: "School",
        category: "Playground",E_word: "swing",C_word: "盪鞦韆",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/s/swi/swing/swing.mp3"
    ),
    Vocabulary(
        //29
        bigtopic: "School",
        category: "Playground",E_word: "seesaw",C_word: "翹翹板",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/s/see/seesa/seesaw.mp3"
    ),
    
    //Sports
    Vocabulary(
        //30
        bigtopic: "School",
        category: "Sports",E_word: "basketball",C_word: "籃球",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/b/bas/baske/basketball.mp3"
    ),
    Vocabulary(
        //31
        bigtopic: "School",
        category: "Sports",E_word: "soccer",C_word: "足球",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/s/soc/socce/soccer.mp3"
    ),
    Vocabulary(
        //32
        bigtopic: "School",
        category: "Sports",E_word: "tennis",C_word: "網球",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/e/eus/eus74/eus74519.mp3"
    ),
    Vocabulary(
        //33
        bigtopic: "School",
        category: "Sports",E_word: "badminton",C_word: "羽毛球",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/b/bad/badmi/badminton.mp3"
    ),
    
    // MARK: - Mall
    
    //Food
    Vocabulary(
        //34
        bigtopic: "Mall",
        category: "Food",E_word: "pizza",C_word: "披薩",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/p/piz/pizza/pizza.mp3"
    ),
    Vocabulary(
        //35
        bigtopic: "Mall",
        category: "Food",E_word: "pasta",C_word: "義大利麵",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/p/pas/pasta/pasta.mp3"
    ),
    Vocabulary(
        //36
        bigtopic: "Mall",
        category: "Food",E_word: "dumpling",C_word: "水餃",
        exSentence: "car.",
        audioURL: "dumpling: https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/d/dum/dumpl/dumpling.mp3"
    ),
    Vocabulary(
        //37
        bigtopic: "Mall",
        category: "Food",E_word: "hamburger",C_word: "漢堡",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/h/ham/hambu/hamburger.mp3"
    ),
    
    //ElectronicsStore
    Vocabulary(
        //38
        bigtopic: "Mall",
        category: "ElectronicsStore",E_word: "watch",C_word: "手錶",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/w/wat/watch/watch.mp3"
    ),
    Vocabulary(
        //39
        bigtopic: "Mall",
        category: "ElectronicsStore",E_word: "camera",C_word: "相機",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/c/cam/camer/camera.mp3"
    ),
    Vocabulary(
        //40
        bigtopic: "Mall",
        category: "ElectronicsStore",E_word: "keyboard",C_word: "鍵盤",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/u/usk/uskee/uskeepn014.mp3"
    ),
    Vocabulary(
        //41
        bigtopic: "Mall",
        category: "ElectronicsStore",E_word: "smartphone",C_word: "智慧型手機",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/c/ca2/ca2us/ca2us093.mp3"
    ),
    Vocabulary(
        //42
        bigtopic: "Mall",
        category: "ElectronicsStore",E_word: "mouse",C_word: "滑鼠",
        exSentence: "car.",
        audioURL: "mouse: https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/m/mou/mouse/mouse.mp3"
    ),
    
    //ClothingStore
    Vocabulary(
        //43
        bigtopic: "Mall",
        category: "ClothingStore",E_word: "shirt",C_word: "襯衫",
        exSentence: "car.",
        audioURL: "shirt: https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/s/shi/shirt/shirt.mp3"
    ),
    Vocabulary(
        //44
        bigtopic: "Mall",
        category: "ClothingStore",E_word: "shorts",C_word: "短褲",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/s/sho/short/shorts.mp3"
    ),
    Vocabulary(
        //45
        bigtopic: "Mall",
        category: "ClothingStore",E_word: "cap",C_word: "帽子",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/c/cap/cap__/cap.mp3"
    ),
    Vocabulary(
        //46
        bigtopic: "Mall",
        category: "ClothingStore",E_word: "backpack",C_word: "背包",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/b/bac/backp/backpack.mp3"
    ),
    Vocabulary(
        //47
        bigtopic: "Mall",
        category: "ClothingStore",E_word: "glasses",C_word: "眼鏡",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E/us_pron/b/buz/buzz_/buzz.mp3"
    ),
    ////////////////////////////////////////////////////////////////////////先跳過找不到
    
    
    
    Vocabulary(
        //48
        bigtopic: "Mall",
        category: "ClothingStore",E_word: "shoes",C_word: "鞋子",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/s/sho/shoe_/shoe.mp3"
    ),
    
    // MARK: - Market

    //Fruit
    Vocabulary(
        //49
        bigtopic: "Market",
        category: "Fruit",E_word: "durian",C_word: "榴蓮",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/e/eus/eus09/eus09138.mp3"
    ),
    Vocabulary(
        //50
        bigtopic: "Market",
        category: "Fruit",E_word: "kiwi",C_word: "奇異果",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/u/usk/uskil/uskillj030.mp3"
    ),
    Vocabulary(
        //51
        bigtopic: "Market",
        category: "Fruit",E_word: "grape",C_word: "葡萄",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/g/gra/grape/grape.mp3"
    ),
    Vocabulary(
        //52
        bigtopic: "Market",
        category: "Fruit",E_word: "banana",C_word: "香蕉",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/b/ban/banan/banana.mp3"
    ),
    Vocabulary(
        //53
        bigtopic: "Market",
        category: "Fruit",E_word: "apple",C_word: "蘋果",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/a/app/apple/apple.mp3"
    ),
    
    
    //Vegetable
    Vocabulary(
        //54
        bigtopic: "Market",
        category: "Vegetable",E_word: "pumpkin",C_word: "南瓜",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/p/pum/pumpk/pumpkin.mp3"
    ),
    Vocabulary(
        //55
        bigtopic: "Market",
        category: "Vegetable",E_word: "broccoli",C_word: "花椰菜",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/b/bro/brocc/broccoli.mp3"
    ),
    Vocabulary(
        //56
        bigtopic: "Market",
        category: "Vegetable",E_word: "cabbage",C_word: "高麗菜",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/c/cab/cabba/cabbage.mp3"
    ),
    Vocabulary(
        //57
        bigtopic: "Market",
        category: "Vegetable",E_word: "cucumber",C_word: "小黃瓜",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/c/cuc/cucum/cucumber.mp3"
    ),
    Vocabulary(
        //58
        bigtopic: "Market",
        category: "Vegetable",E_word: "carrot",C_word: "紅蘿蔔",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/c/car/carat/carat.mp3"
    ),
    
    
    
    //Spice
    Vocabulary(
        //59
        bigtopic: "Market",
        category: "Spice",E_word: "chili",C_word: "辣椒",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/c/chi/chill/chilly.mp3"
    ),
    Vocabulary(
        //60
        bigtopic: "Market",
        category: "Spice",E_word: "garlic",C_word: "蒜頭",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/g/gar/garli/garlic.mp3"
    ),
    Vocabulary(
        //61
        bigtopic: "Market",
        category: "Spice",E_word: "ginger",C_word: "薑",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/g/gin/ginge/ginger.mp3"
    ),
    Vocabulary(
        //62
        bigtopic: "Market",
        category: "Spice",E_word: "onion",C_word: "洋蔥",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/e/eus/eus75/eus75215.mp3"
    ),
    
    //MARK: -Zoo
    
    //Mammals1
    Vocabulary(
        //63
        bigtopic: "Zoo",
        category: "Mammals1",E_word: "lion",C_word: "獅子",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/l/lio/lion_/lion.mp3"
    ),
    Vocabulary(
        //64
        bigtopic: "Zoo",
        category: "Mammals1",E_word: "tiger",C_word: "老虎",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/t/tig/tiger/tiger.mp3"
    ),
    Vocabulary(
        //65
        bigtopic: "Zoo",
        category: "Mammals1",E_word: "elephant",C_word: "大象",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/e/eus/eus75/eus75655.mp3"
    ),
    Vocabulary(
        //66
        bigtopic: "Zoo",
        category: "Mammals1",E_word: "giraffe",C_word: "長頸鹿",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/g/gir/giraf/giraffe.mp3"
    ),
    Vocabulary(
        //67
        bigtopic: "Zoo",
        category: "Mammals1",E_word: "zebra",C_word: "斑馬",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/z/zeb/zebra/zebra.mp3"
    ),
    Vocabulary(
        //68
        bigtopic: "Zoo",
        category: "Mammals1",E_word: "monkey",C_word: "猴子",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/e/eus/eus73/eus73071.mp3"
    ),
    
    
    
    //Mammals2
    Vocabulary(
        //69
        bigtopic: "Zoo",
        category: "Mammals2",E_word: "koala",C_word: "無尾熊",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/u/usk/uskkk/uskkk__029.mp3"
    ),
    Vocabulary(
        //70
        bigtopic: "Zoo",
        category: "Mammals2",E_word: "squirrel",C_word: "松鼠",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/s/squ/squir/squirrel.mp3"
    ),
    Vocabulary(
        //71
        bigtopic: "Zoo",
        category: "Mammals2",E_word: "sloth",C_word: "樹懶",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/s/slo/sloth/sloth.mp3"
    ),
    Vocabulary(
        //72
        bigtopic: "Zoo",
        category: "Mammals2",E_word: "bear",C_word: "熊",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/b/bar/bare_/bare.mp3"
    ),
    Vocabulary(
        //73
        bigtopic: "Zoo",
        category: "Mammals2",E_word: "panda",C_word: "熊貓",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/p/pan/panda/panda.mp3"
    ),
    Vocabulary(
        //74
        bigtopic: "Zoo",
        category: "Mammals2",E_word: "kangaroo",C_word: "袋鼠",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/k/kan/kanga/kangaroo.mp3"
    ),
    
    
    
    //Mammals3
    Vocabulary(
        //75
        bigtopic: "Zoo",
        category: "Mammals3",E_word: "camel",C_word: "駱駝",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/c/cam/camel/camel.mp3"
    ),
    Vocabulary(
        //76
        bigtopic: "Zoo",
        category: "Mammals3",E_word: "buffalo",C_word: "水牛",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/b/buf/buffa/buffalo.mp3"
    ),
    Vocabulary(
        //77
        bigtopic: "Zoo",
        category: "Mammals3",E_word: "deer",C_word: "鹿",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/d/dea/dear_/dear.mp3"
    ),
    Vocabulary(
        //78
        bigtopic: "Zoo",
        category: "Mammals3",E_word: "wolf",C_word: "狼",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/w/wol/wolf_/wolf.mp3"
    ),
    Vocabulary(
        //79
        bigtopic: "Zoo",
        category: "Mammals3",E_word: "fox",C_word: "狐狸",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/f/fox/fox__/fox.mp3"
    ),
    
    
    
    
    //MarineAnimal
    Vocabulary(
        //80
        bigtopic: "Zoo",
        category: "MarineAnimal",E_word: "dolphin",C_word: "海豚",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/e/eus/eus71/eus71360.mp3"
    ),
    Vocabulary(
        //81
        bigtopic: "Zoo",
        category: "MarineAnimal",E_word: "shark",C_word: "鯊魚",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/s/sha/shark/shark.mp3"
    ),
    Vocabulary(
        //82
        bigtopic: "Zoo",
        category: "MarineAnimal",E_word: "jellyfish",C_word: "水母",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/j/jel/jelly/jellyfish.mp3"
    ),
    Vocabulary(
        //83
        bigtopic: "Zoo",
        category: "MarineAnimal",E_word: "seahorse",C_word: "海馬",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/u/uss/usscr/usscrum028.mp3"
    ),
    
    
    //Birds
    Vocabulary(
        //84
        bigtopic: "Zoo",
        category: "Birds",E_word: "parrot",C_word: "鸚鵡",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/p/par/parro/parrot.mp3"
    ),
    Vocabulary(
        //85
        bigtopic: "Zoo",
        category: "Birds",E_word: "owl",C_word: "貓頭鷹",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/e/eus/eus75/eus75454.mp3"
    ),
    Vocabulary(
        //86
        bigtopic: "Zoo",
        category: "Birds",E_word: "penguin",C_word: "企鵝",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/p/pen/pengu/penguin.mp3"
    ),
    Vocabulary(
        //87
        bigtopic: "Zoo",
        category: "Birds",E_word: "ostrich",C_word: "鴕鳥",
        exSentence: "car.",
        audioURL: "https://dictionary.cambridge.org/zht/media/%E8%8B%B1%E8%AA%9E-%E6%BC%A2%E8%AA%9E-%E7%B9%81%E9%AB%94/us_pron/e/eus/eus75/eus75321.mp3"
    ),
    
    
    
    
]

