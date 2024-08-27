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
    var assetName: String?
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
    //kitchen
    Vocabulary(
        //0
        category: "Kitchen",E_word: "spoon",C_word: "湯匙",
        exSentence: "I use a spoon to eat my cereal.",
        audioURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/s/spo/spoon/spoon.mp3",
        assetName: "spoon"
    ),
    Vocabulary(
        //1
        category: "Kitchen",E_word: "fork",C_word: "叉子",
        exSentence: "She eats pasta with a fork.",
        audioURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/f/for/fork_/fork.mp3",
                assetName: "fork"
    ),
    Vocabulary(
        //2
        category: "Kitchen",E_word: "plate",C_word: "盤子",
        exSentence: "Put the cake on the plate.",
        audioURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/p/pla/plate/plate.mp3",
                assetName: "plate"
    ),
    Vocabulary(
        //3
        category: "Kitchen",E_word: "knife",C_word: "刀",
        exSentence: "I used a knife to cut the vegetable.",
        audioURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/k/kni/knife/knife.mp3",
                assetName: "knife"
    ),
    
    
    //batchroom
    Vocabulary(
        //4
        category: "Bathroom",E_word: "toothbrush",C_word: "牙刷",
        exSentence: "I use my toothbrush to clean my teeth.",
        audioURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/u/ust/uston/ustones010.mp3",
                assetName: "toothbrush"
    ),
    Vocabulary(
        //5
        category: "Bathroom",E_word: "comb",C_word: "梳子",
        exSentence: "I use a comb to style my hair every morning.",
        audioURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/c/com/comb_/comb.mp3",
                assetName: "comb"
    ),
    Vocabulary(
        //6
        category: "Bathroom",E_word: "towel",C_word: "毛巾",
        exSentence: "I dry my hands with a towel.",
        audioURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/t/tow/towel/towel.mp3",
                assetName: "towel"
    ),
    Vocabulary(
        //7
        category: "Bathroom",E_word: "soap",C_word: "肥皂",
        exSentence: "I wash my hands with soap.",
        audioURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/s/soa/soap_/soap.mp3",
                assetName: "soap"
    ),
    Vocabulary(
        //8
        category: "Bathroom",E_word: "toilet",C_word: "馬桶",
        exSentence: "I always clean the toilet to keep it fresh.",
        audioURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/t/toi/toile/toilet.mp3",
                assetName: "toilet"
    ),
    
    
    //////////////////////////////////////
    Vocabulary(
        //8
        category: "Livingroom",E_word: "toilet",C_word: "馬桶",
        exSentence: "I always clean the toilet to keep it fresh.",
        audioURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/t/toi/toile/toilet.mp3",
                assetName: "toilet"
    ),
    Vocabulary(
        //8
        category: "Livingroom",E_word: "toilet",C_word: "馬桶",
        exSentence: "I always clean the toilet to keep it fresh.",
        audioURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/t/toi/toile/toilet.mp3",
                assetName: "toilet"
    ),
    Vocabulary(
        //8
        category: "Livingroom",E_word: "toilet",C_word: "馬桶",
        exSentence: "I always clean the toilet to keep it fresh.",
        audioURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/t/toi/toile/toilet.mp3",
                assetName: "toilet"
    ),
    Vocabulary(
        //8
        category: "Livingroom",E_word: "toilet",C_word: "馬桶",
        exSentence: "I always clean the toilet to keep it fresh.",
        audioURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/t/toi/toile/toilet.mp3",
                assetName: "toilet"
    ),
    Vocabulary(
        //8
        category: "Bathroom",E_word: "toilet",C_word: "馬桶",
        exSentence: "I always clean the toilet to keep it fresh.",
        audioURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/t/toi/toile/toilet.mp3",
                assetName: "toilet"
    ),
    Vocabulary(
        //8
        category: "Bathroom",E_word: "toilet",C_word: "馬桶",
        exSentence: "I always clean the toilet to keep it fresh.",
        audioURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/t/toi/toile/toilet.mp3",
                assetName: "toilet"
    ),
    Vocabulary(
        //8
        category: "Bathroom",E_word: "toilet",C_word: "馬桶",
        exSentence: "I always clean the toilet to keep it fresh.",
        audioURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/t/toi/toile/toilet.mp3",
                assetName: "toilet"
    ),

]

