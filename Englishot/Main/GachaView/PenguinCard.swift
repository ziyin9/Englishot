//
//  GachaSystem.swift
//  Englishot
//
//  Created by 陳姿縈 on 6/13/25.
//
import SwiftUI
import CoreData

// Define gacha types enum
enum GachaType: String, CaseIterable {
    case normal = "normal"
    case emotion = "emotion"
    case profession = "profession"
    case activity = "activity"
    case festival = "festival"
    
    var title: String {
        switch self {
        case .normal: return "綜合抽卡"
        case .emotion: return "限定表情"
        case .profession: return "限定職業"
        case .activity: return "活動抽卡"
        case .festival: return "節日限定"
        }
    }
    
    var subtitle: String {
        switch self {
        case .normal: return "隨機抽取所有類型"
        case .emotion: return "只抽表情卡片"
        case .profession: return "只抽職業卡片"
        case .activity: return "只抽活動卡片"
        case .festival: return "只抽節日卡片"
        }
    }
    
    var cost: Int64 {
        switch self {
        case .normal: return 100
        case .emotion: return 150
        case .profession: return 170
        case .activity: return 180
        case .festival: return 200
        }
    }
    
    var icon: String {
        switch self {
        case .normal: return "Normal"
        case .emotion: return "Emotion"
        case .profession: return "Profession"
        case .activity: return "Activity"
        case .festival: return "Festival"
        }
    }
    
    var gradientColors: [Color] {
        switch self {
        case .normal: return [Color.blue.opacity(0.8), Color.cyan.opacity(0.6)]
        case .emotion: return [Color.pink.opacity(0.8), Color.purple.opacity(0.6)]
        case .profession: return [Color.green.opacity(0.8), Color.mint.opacity(0.6)]
        case .activity: return [Color.orange.opacity(0.8), Color.yellow.opacity(0.6)]
        case .festival: return [Color.red.opacity(0.8), Color.orange.opacity(0.6)]
        }
    }
    
    var allowedCardTypes: [String] {
        switch self {
        case .normal: return ["Emotion", "Profession", "Activity", "Festival"]
        case .emotion: return ["Emotion"]
        case .profession: return ["Profession"]
        case .activity: return ["Activity"]
        case .festival: return ["Festival"]
        }
    }
}

struct PenguinCard: Identifiable, Codable {
    var id = UUID()
    var cardName: String
    var englishWord: String
    var chineseWord: String
    var pronunciationURL: String
    var emotionType: String
    var unlocked: Bool = false
    var collected: Bool = false
    var rarity: String // Snowflake, Ice Crystal, Frozen Star, Aurora
    var imageName: String
    var timesDrawn: Int16 = 0
    var dateCollected: Date?
    var descriptionText: String
    var voiceLine: String
    var cardType: String // Emotion, Profession, Activity
    
    // Helper computed properties
    var rarityColor: Color {
        switch rarity {
        case "Snowflake": return Color(hex: "AEE9F3")
        case "Ice Crystal": return Color(hex: "72D0F4")
        case "Frozen Star": return Color(hex: "5A9EF8")
        case "Aurora": return Color(hex: "8EC6FF")
        default: return Color(hex: "AEE9F3")
        }
    }
    
    var rarityGradient: LinearGradient {
        switch rarity {
        case "Aurora":
            return LinearGradient(
                colors: [
                    Color(hex: "8EC6FF"),
                    Color(hex: "D1BFFF"),
                    Color(hex: "A3F2E5")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        default:
            return LinearGradient(
                colors: [rarityColor, rarityColor.opacity(0.8)],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
    
    var rarityIcon: String {
        switch rarity {
        case "Snowflake": return "❄️"
        case "Ice Crystal": return "💎"
        case "Frozen Star": return "✨"
        case "Aurora": return "🌌"
        default: return "❄️"
        }
    }
    
    var drawCost: Int64 {
        switch rarity {
        case "Snowflake": return 100
        case "Ice Crystal": return 100
        case "Frozen Star": return 100
        case "Aurora": return 100
        default: return 100
        }
    }
    
    var duplicateRefund: Int64 {
        switch rarity {
        case "Snowflake": return 30
        case "Ice Crystal": return 50
        case "Frozen Star": return 70
        case "Aurora": return 90
        default: return 30
        }
    }
    
    var cardTypeColor: Color {
        switch cardType {
        case "Emotion": return .pink
        case "Profession": return .green
        case "Activity": return .orange
        case "Festival": return .purple
        default: return .gray
        }
    }
    
    var cardTypeIcon: String {
        switch cardType {
        case "Emotion": return "face.smiling"
        case "Profession": return "briefcase"
        case "Activity": return "figure.walk"
        case "Festival": return "gift.fill"
        default: return "questionmark"
        }
    }
}

// Color extension for hex support
//extension Color {
//    init(hex: String) {
//        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
//        var int: UInt64 = 0
//        Scanner(string: hex).scanHexInt64(&int)
//        let a, r, g, b: UInt64
//        switch hex.count {
//        case 3: // RGB (12-bit)
//            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
//        case 6: // RGB (24-bit)
//            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
//        case 8: // ARGB (32-bit)
//            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
//        default:
//            (a, r, g, b) = (1, 1, 1, 0)
//        }
//        self.init(
//            .sRGB,
//            red: Double(r) / 255,
//            green: Double(g) / 255,
//            blue:  Double(b) / 255,
//            opacity: Double(a) / 255
//        )
//    }
//}

class GachaSystem: ObservableObject {
    @Published var availableCards: [PenguinCard] = []//
    @Published var collectedCards: [PenguinCard] = []//
    @Published var showGashaResult = false
    @Published var lastDrawnCard: PenguinCard?
    @Published var lastDrawWasDuplicate = false
    
    // Draw rates
    private let snowflakeRate: Double = 0.6  // 60%
    private let iceCrystalRate: Double = 0.25  // 25%
    private let frozenStarRate: Double = 0.12  // 12%
    private let auroraRate: Double = 0.03      // 3%
    
    init() {
        setupInitialCards()
        loadCollectedCards()
        // Ensure cards are synced with Core Data on app start
        syncCardsWithCoreData()
    }
    
    // Setup initial card data
    private func setupInitialCards() {
        availableCards = [
            // Emotion Cards
            PenguinCard(
                cardName: "Happy Penguin",
                englishWord: "happy",
                chineseWord: "開心",
                pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/h/hap/happy/happy.mp3",
                emotionType: "happy",
                rarity: "Snowflake",
                imageName: "penguin_happy",
                descriptionText: "A joyful penguin with a bright smile!",
                voiceLine: "I'm so happy!",
                cardType: "Emotion"
            ),
            PenguinCard(
                cardName: "Angry Penguin",
                englishWord: "angry",
                chineseWord: "生氣",
                pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/a/ang/angry/angry.mp3",
                emotionType: "angry",
                rarity: "Snowflake",
                imageName: "penguin_angry",
                descriptionText: "A grumpy penguin having a bad day!",
                voiceLine: "I'm very angry!",
                cardType: "Emotion"
            ),
            PenguinCard(
                cardName: "Sad Penguin",
                englishWord: "sad",
                chineseWord: "難過",
                pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/s/sad/sad__/sad.mp3",
                emotionType: "sad",
                rarity: "Snowflake",
                imageName: "penguin_sad",
                descriptionText: "A melancholy penguin feeling blue.",
                voiceLine: "I feel so sad...",
                cardType: "Emotion"
            ),
            PenguinCard(
                cardName: "Excited Penguin",
                englishWord: "excited",
                chineseWord: "興奮",
                pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/e/exc/excit/excited.mp3",
                emotionType: "excited",
                rarity: "Ice Crystal",
                imageName: "penguin_excited",
                descriptionText: "An energetic penguin full of enthusiasm!",
                voiceLine: "I'm so excited!",
                cardType: "Emotion"
            ),
            PenguinCard(
                cardName: "Surprised Penguin",
                englishWord: "surprised",
                chineseWord: "驚訝",
                pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/s/sur/surpr/surprised.mp3",
                emotionType: "surprised",
                rarity: "Ice Crystal",
                imageName: "penguin_surprised",
                descriptionText: "A penguin caught off guard!",
                voiceLine: "Oh my! I'm surprised!",
                cardType: "Emotion"
            ),
            PenguinCard(
                cardName: "Shy Penguin",
                englishWord: "shy",
                chineseWord: "害羞",
                pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/s/shy/shy__/shy.mp3",
                emotionType: "shy",
                rarity: "Snowflake",
                imageName: "penguin_shy",
                descriptionText: "A bashful penguin hiding behind its flippers.",
                voiceLine: "I'm a bit shy...",
                cardType: "Emotion"
            ),
            PenguinCard(
                cardName: "Confused Penguin",
                englishWord: "confused",
                chineseWord: "困惑",
                pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/c/con/confu/confused.mp3",
                emotionType: "confused",
                rarity: "Ice Crystal",
                imageName: "penguin_confused",
                descriptionText: "A puzzled penguin scratching its head.",
                voiceLine: "I'm so confused!",
                cardType: "Emotion"
            ),
            PenguinCard(
                cardName: "Sleepy Penguin",
                englishWord: "sleepy",
                chineseWord: "想睡",
                pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/s/sle/sleep/sleepy.mp3",
                emotionType: "sleepy",
                rarity: "Snowflake",
                imageName: "penguin_sleepy",
                descriptionText: "A drowsy penguin ready for a nap.",
                voiceLine: "I'm so sleepy...",
                cardType: "Emotion"
            ),
            PenguinCard(
                cardName: "Blue Penguin",
                englishWord: "blue",
                chineseWord: "憂鬱",
                pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/b/blu/blue_/blue.mp3",
                emotionType: "blue",
                rarity: "Ice Crystal",
                imageName: "penguin_blue",
                descriptionText: "A melancholic penguin feeling down.",
                voiceLine: "I'm feeling blue today...",
                cardType: "Emotion"
            ),
            PenguinCard(
                cardName: "Tired Penguin",
                englishWord: "tired",
                chineseWord: "疲累",
                pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/t/tir/tired/tired.mp3",
                emotionType: "tired",
                rarity: "Snowflake",
                imageName: "penguin_tired",
                descriptionText: "An exhausted penguin needing rest.",
                voiceLine: "I'm so tired...",
                cardType: "Emotion"
            ),
            PenguinCard(
                cardName: "Nervous Penguin",
                englishWord: "nervous",
                chineseWord: "緊張",
                pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/n/ner/nervo/nervous.mp3",
                emotionType: "nervous",
                rarity: "Ice Crystal",
                imageName: "penguin_nervous",
                descriptionText: "An anxious penguin fidgeting with its flippers.",
                voiceLine: "I'm feeling nervous!",
                cardType: "Emotion"
            ),
            PenguinCard(
                cardName: "Bored Penguin",
                englishWord: "bored",
                chineseWord: "無聊",
                pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/b/bor/bored/bored.mp3",
                emotionType: "bored",
                rarity: "Snowflake",
                imageName: "penguin_bored",
                descriptionText: "A penguin looking for something to do.",
                voiceLine: "I'm so bored...",
                cardType: "Emotion"
            ),
            PenguinCard(
                cardName: "Scared Penguin",
                englishWord: "scared",
                chineseWord: "害怕",
                pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/s/sca/scare/scared.mp3",
                emotionType: "scared",
                rarity: "Ice Crystal",
                imageName: "penguin_scared",
                descriptionText: "A frightened penguin hiding behind an iceberg.",
                voiceLine: "I'm scared!",
                cardType: "Emotion"
            ),
            
            
            
            
            
            
            
            
            
            
            
            
            
            // Profession Cards
            PenguinCard(
                cardName: "Teacher Penguin",
                englishWord: "teacher",
                chineseWord: "老師",
                pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/t/tea/teach/teacher.mp3",
                emotionType: "professional",
                rarity: "Frozen Star",
                imageName: "penguin_teacher",
                descriptionText: "A wise penguin educating young minds.",
                voiceLine: "Let's learn together!",
                cardType: "Profession"
            ),
            PenguinCard(
                cardName: "Police Penguin",
                englishWord: "police",
                chineseWord: "警察",
                pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/p/pol/polic/police.mp3",
                emotionType: "professional",
                rarity: "Frozen Star",
                imageName: "penguin_police",
                descriptionText: "A brave penguin keeping everyone safe.",
                voiceLine: "Stop right there!",
                cardType: "Profession"
            ),
            PenguinCard(
                cardName: "Student Penguin",
                englishWord: "student",
                chineseWord: "學生",
                pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/s/stu/stude/student.mp3",
                emotionType: "professional",
                rarity: "Snowflake",
                imageName: "penguin_student",
                descriptionText: "A curious penguin ready to learn!",
                voiceLine: "I love studying!",
                cardType: "Profession"
            ),
            PenguinCard(
                cardName: "Doctor Penguin",
                englishWord: "doctor",
                chineseWord: "醫生",
                pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/d/doc/docto/doctor.mp3",
                emotionType: "professional",
                rarity: "Frozen Star",
                imageName: "penguin_doctor",
                descriptionText: "A caring penguin healing others.",
                voiceLine: "Let me check your temperature!",
                cardType: "Profession"
            ),
            PenguinCard(
                cardName: "Farmer Penguin",
                englishWord: "farmer",
                chineseWord: "農夫",
                pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/f/far/farme/farmer.mp3",
                emotionType: "professional",
                rarity: "Ice Crystal",
                imageName: "penguin_farmer",
                descriptionText: "A hardworking penguin growing crops.",
                voiceLine: "Time to harvest!",
                cardType: "Profession"
            ),
            PenguinCard(
                cardName: "Chef Penguin",
                englishWord: "chef",
                chineseWord: "廚師",
                pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/c/che/chef_/chef.mp3",
                emotionType: "professional",
                rarity: "Ice Crystal",
                imageName: "penguin_chef",
                descriptionText: "A talented penguin creating delicious meals.",
                voiceLine: "Bon appétit!",
                cardType: "Profession"
            ),
            PenguinCard(
                cardName: "Artist Penguin",
                englishWord: "artist",
                chineseWord: "藝術家",
                pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/a/art/artis/artist.mp3",
                emotionType: "professional",
                rarity: "Ice Crystal",
                imageName: "penguin_artist",
                descriptionText: "A creative penguin painting masterpieces.",
                voiceLine: "Let me paint your portrait!",
                cardType: "Profession"
            ),
            PenguinCard(
                cardName: "Firefighter Penguin",
                englishWord: "firefighter",
                chineseWord: "消防員",
                pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/f/fir/firef/firefighter.mp3",
                emotionType: "professional",
                rarity: "Frozen Star",
                imageName: "penguin_firefighter",
                descriptionText: "A brave penguin saving lives.",
                voiceLine: "Emergency!",
                cardType: "Profession"
            ),
            PenguinCard(
                cardName: "Scientist Penguin",
                englishWord: "scientist",
                chineseWord: "科學家",
                pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/s/sci/scien/scientist.mp3",
                emotionType: "professional",
                rarity: "Frozen Star",
                imageName: "penguin_scientist",
                descriptionText: "A brilliant penguin making discoveries.",
                voiceLine: "Eureka!",
                cardType: "Profession"
            ),
            PenguinCard(
                cardName: "Astronaut Penguin",
                englishWord: "astronaut",
                chineseWord: "太空人",
                pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/a/ast/astro/astronaut.mp3",
                emotionType: "professional",
                rarity: "Aurora",
                imageName: "penguin_astronaut",
                descriptionText: "A daring penguin exploring space.",
                voiceLine: "To infinity and beyond!",
                cardType: "Profession"
            ),
            PenguinCard(
                cardName: "Delivery Penguin",
                englishWord: "delivery",
                chineseWord: "快遞員",
                pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/d/del/deliv/delivery.mp3",
                emotionType: "professional",
                rarity: "Ice Crystal",
                imageName: "penguin_delivery",
                descriptionText: "A speedy penguin delivering packages.",
                voiceLine: "Special delivery!",
                cardType: "Profession"
            ),
            PenguinCard(
                cardName: "Nurse Penguin",
                englishWord: "nurse",
                chineseWord: "護士",
                pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/n/nur/nurse/nurse.mp3",
                emotionType: "professional",
                rarity: "Frozen Star",
                imageName: "penguin_nurse",
                descriptionText: "A caring penguin helping patients.",
                voiceLine: "How are you feeling today?",
                cardType: "Profession"
            ),
            PenguinCard(
                cardName: "Driver Penguin",
                englishWord: "driver",
                chineseWord: "司機",
                pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/d/dri/drive/driver.mp3",
                emotionType: "professional",
                rarity: "Ice Crystal",
                imageName: "penguin_driver",
                descriptionText: "A skilled penguin behind the wheel.",
                voiceLine: "Next stop!",
                cardType: "Profession"
            ),
            PenguinCard(
                cardName: "Lawyer Penguin",
                englishWord: "lawyer",
                chineseWord: "律師",
                pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/l/law/lawye/lawyer.mp3",
                emotionType: "professional",
                rarity: "Frozen Star",
                imageName: "penguin_lawyer",
                descriptionText: "A wise penguin defending justice.",
                voiceLine: "Objection!",
                cardType: "Profession"
            ),
            PenguinCard(
                cardName: "Merchant Penguin",
                englishWord: "merchant",
                chineseWord: "商人",
                pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/m/mer/merch/merchant.mp3",
                emotionType: "professional",
                rarity: "Frozen Star",
                imageName: "penguin_merchant",
                descriptionText: "A successful penguin making deals.",
                voiceLine: "Let's make a deal!",
                cardType: "Profession"
            ),
            PenguinCard(
                cardName: "Builder Penguin",
                englishWord: "builder",
                chineseWord: "建築師",
                pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/b/bui/build/builder.mp3",
                emotionType: "professional",
                rarity: "Ice Crystal",
                imageName: "penguin_builder",
                descriptionText: "A strong penguin constructing buildings.",
                voiceLine: "Time to build!",
                cardType: "Profession"
            ),
            PenguinCard(
                cardName: "Athlete Penguin",
                englishWord: "athlete",
                chineseWord: "運動員",
                pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/a/ath/athle/athlete.mp3",
                emotionType: "professional",
                rarity: "Ice Crystal",
                imageName: "penguin_athlete",
                descriptionText: "A fit penguin winning competitions.",
                voiceLine: "Ready, set, go!",
                cardType: "Profession"
            ),
            PenguinCard(
                cardName: "Dancer Penguin",
                englishWord: "dancer",
                chineseWord: "舞者",
                pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/d/dan/dance/dancer.mp3",
                emotionType: "professional",
                rarity: "Ice Crystal",
                imageName: "penguin_dancer",
                descriptionText: "A graceful penguin performing moves.",
                voiceLine: "Let's dance!",
                cardType: "Profession"
            ),
            PenguinCard(
                cardName: "Waiter Penguin",
                englishWord: "waiter",
                chineseWord: "服務生",
                pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/w/wai/waite/waiter.mp3",
                emotionType: "professional",
                rarity: "Snowflake",
                imageName: "penguin_waiter",
                descriptionText: "A polite penguin serving customers.",
                voiceLine: "May I take your order?",
                cardType: "Profession"
            ),
            PenguinCard(
                cardName: "Postman Penguin",
                englishWord: "postman",
                chineseWord: "郵差",
                pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/p/pos/postm/postman.mp3",
                emotionType: "professional",
                rarity: "Snowflake",
                imageName: "penguin_postman",
                descriptionText: "A reliable penguin delivering mail.",
                voiceLine: "Special delivery!",
                cardType: "Profession"
            ),
            PenguinCard(
                cardName: "Soldier Penguin",
                englishWord: "soldier",
                chineseWord: "軍人",
                pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/s/sol/soldi/soldier.mp3",
                emotionType: "professional",
                rarity: "Frozen Star",
                imageName: "penguin_soldier",
                descriptionText: "A brave penguin protecting the country.",
                voiceLine: "At attention!",
                cardType: "Profession"
            ),
            PenguinCard(
                cardName: "Photographer Penguin",
                englishWord: "photographer",
                chineseWord: "攝影師",
                pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/p/pho/photo/photographer.mp3",
                emotionType: "professional",
                rarity: "Ice Crystal",
                imageName: "penguin_photographer",
                descriptionText: "A creative penguin capturing moments.",
                voiceLine: "Say cheese!",
                cardType: "Profession"
            ),
            PenguinCard(
                cardName: "Musician Penguin",
                englishWord: "musician",
                chineseWord: "音樂家",
                pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/m/mus/music/musician.mp3",
                emotionType: "professional",
                rarity: "Ice Crystal",
                imageName: "penguin_musician",
                descriptionText: "A talented penguin playing music.",
                voiceLine: "Let's make some music!",
                cardType: "Profession"
            ),
            PenguinCard(
                cardName: "Engineer Penguin",
                englishWord: "engineer",
                chineseWord: "工程師",
                pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/e/eng/engineer.mp3",
                emotionType: "professional",
                rarity: "Aurora",
                imageName: "penguin_engineer",
                descriptionText: "A brilliant penguin who designs and builds amazing machines.",
                voiceLine: "Let's build something incredible!",
                cardType: "Profession"
            ),
            
    // Activity Cards
                PenguinCard(
                    cardName: "Jogging Penguin",
                    englishWord: "jogging",
                    chineseWord: "慢跑",
                    pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/j/jog/jogging/jogging.mp3",
                    emotionType: "active",
                    rarity: "Aurora",
                    imageName: "penguin_jogging",
                    descriptionText: "A penguin enjoys jogging every morning, staying fit and healthy.",
                    voiceLine: "Let's go for a run!",
                    cardType: "Activity"
                ),

                PenguinCard(
                    cardName: "Camping Penguin",
                    englishWord: "camping",
                    chineseWord: "露營",
                    pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/c/cam/camping/camping.mp3",
                    emotionType: "active",
                    rarity: "Ice Crystal",
                    imageName: "penguin_camping",
                    descriptionText: "A penguin loves camping under the stars.",
                    voiceLine: "Time to set up camp!",
                    cardType: "Activity"
                ),

                PenguinCard(
                    cardName: "Fishing Penguin",
                    englishWord: "fishing",
                    chineseWord: "釣魚",
                    pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/f/fis/fishing/fishing.mp3",
                    emotionType: "active",
                    rarity: "Ice Crystal",
                    imageName: "penguin_fishing",
                    descriptionText: "A penguin enjoys fishing by the lakeside.",
                    voiceLine: "Catch of the day!",
                    cardType: "Activity"
                ),

                PenguinCard(
                    cardName: "Hiking Penguin",
                    englishWord: "hiking",
                    chineseWord: "健行",
                    pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/h/hik/hiking/hiking.mp3",
                    emotionType: "active",
                    rarity: "Snowflake",
                    imageName: "penguin_hiking",
                    descriptionText: "A penguin loves hiking up mountains to enjoy the view.",
                    voiceLine: "Let's climb higher!",
                    cardType: "Activity"
                ),

                PenguinCard(
                    cardName: "Shopping Penguin",
                    englishWord: "shopping",
                    chineseWord: "購物",
                    pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/s/sho/shopping/shopping.mp3",
                    emotionType: "active",
                    rarity: "Snowflake",
                    imageName: "penguin_shopping",
                    descriptionText: "A penguin enjoys shopping for the latest trends.",
                    voiceLine: "Time for some retail therapy!",
                    cardType: "Activity"
                ),

                PenguinCard(
                    cardName: "Skiing Penguin",
                    englishWord: "skiing",
                    chineseWord: "滑雪",
                    pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/s/ski/skiing/skiing.mp3",
                    emotionType: "active",
                    rarity: "Aurora",
                    imageName: "penguin_skiing",
                    descriptionText: "A penguin loves skiing down snowy slopes.",
                    voiceLine: "Woo-hoo! Let's ski!",
                    cardType: "Activity"
                ),

                PenguinCard(
                    cardName: "Surfing Penguin",
                    englishWord: "surfing",
                    chineseWord: "衝浪",
                    pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/s/sur/surfing/surfing.mp3",
                    emotionType: "active",
                    rarity: "Frozen Star",
                    imageName: "penguin_surfing",
                    descriptionText: "A penguin catches waves on a surfboard.",
                    voiceLine: "Hang ten, dude!",
                    cardType: "Activity"
                ),

                PenguinCard(
                    cardName: "Swimming Penguin",
                    englishWord: "swimming",
                    chineseWord: "游泳",
                    pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/s/swi/swimming/swimming.mp3",
                    emotionType: "active",
                    rarity: "Snowflake",
                    imageName: "penguin_swimming",
                    descriptionText: "A penguin gracefully swims through the water.",
                    voiceLine: "Let's dive in!",
                    cardType: "Activity"
                ),
            
    // Festival Cards
                PenguinCard(
                    cardName: "Christmas Penguin",
                    englishWord: "Christmas",
                    chineseWord: "聖誕節",
                    pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/c/hri/chris/christmas.mp3",
                    emotionType: "Festival",
                    rarity: "Snowflake",
                    imageName: "penguin_christmas",
                    descriptionText: "Every year on December 25th, this penguin decorates the tree, sings carols, and waits for Santa's arrival.",
                    voiceLine: "Jingle bells, jingle bells, Merry Christmas!",
                    cardType: "Festival"
                ),
                PenguinCard(
                    cardName: "Dragon Boat Penguin",
                    englishWord: "Dragon Boat Festival",
                    chineseWord: "端午節",
                    pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/d/dra/dragon-boat-festival.mp3",
                    emotionType: "Festival",
                    rarity: "Snowflake",
                    imageName: "penguin_dragonboatfestival",
                    descriptionText: "Every year on the fifth day of the fifth lunar month, this penguin joins dragon boat races and eats rice dumplings.",
                    voiceLine: "Row fast! Eat zongzi!",
                    cardType: "Festival"
                ),
                PenguinCard(
                    cardName: "Halloween Penguin",
                    englishWord: "Halloween",
                    chineseWord: "萬聖節",
                    pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/h/hal/hallo/halloween.mp3",
                    emotionType: "Festival",
                    rarity: "Aurora",
                    imageName: "penguin_halloween",
                    descriptionText: "On October 31st, this penguin wears costumes, carves pumpkins, and collects candies.",
                    voiceLine: "Trick or treat!",
                    cardType: "Festival"
                ),
                PenguinCard(
                    cardName: "Lantern Festival Penguin",
                    englishWord: "Lantern Festival",
                    chineseWord: "元宵節",
                    pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/l/lan/lantern-festival.mp3",
                    emotionType: "Festival",
                    rarity: "Snowflake",
                    imageName: "penguin_lanternfestival",
                    descriptionText: "On the fifteenth day of the lunar new year, this penguin lights lanterns and enjoys sweet rice balls.",
                    voiceLine: "Let's light up the night!",
                    cardType: "Festival"
                ),
                PenguinCard(
                    cardName: "Moon Festival Penguin",
                    englishWord: "Moon Festival",
                    chineseWord: "中秋節",
                    pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/m/moo/moon-festival.mp3",
                    emotionType: "Festival",
                    rarity: "Ice Crystal",
                    imageName: "penguin_moonfestival",
                    descriptionText: "On the fifteenth day of the eighth lunar month, this penguin admires the full moon and shares mooncakes with friends.",
                    voiceLine: "Happy Moon Festival!",
                    cardType: "Festival"
                ),
                PenguinCard(
                    cardName: "Valentine Penguin",
                    englishWord: "Valentine's Day",
                    chineseWord: "情人節",
                    pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/v/val/valentine's-day.mp3",
                    emotionType: "Festival",
                    rarity: "Ice Crystal",
                    imageName: "penguin_valentine'sday",
                    descriptionText: "Every year on February 14th, this penguin prepares lovely gifts and shares sweet moments with loved ones.",
                    voiceLine: "Be my Valentine!",
                    cardType: "Festival"
                ),
            
            
        ]
    }
    
    // Draw a card using coins
    func drawCard(gameState: GameState, gachaType: GachaType = .normal) -> Bool {
        let drawCost = gachaType.cost
        
        deductCoin(by: Int64(drawCost))
        
        let randomValue = Double.random(in: 0...1)
        let selectedRarity: String
        
        if randomValue <= auroraRate {
            selectedRarity = "Aurora"
        } else if randomValue <= auroraRate + frozenStarRate {
            selectedRarity = "Frozen Star"
        } else if randomValue <= auroraRate + frozenStarRate + iceCrystalRate {
            selectedRarity = "Ice Crystal"
        } else {
            selectedRarity = "Snowflake"
        }
        
        // Filter cards by rarity and card type based on gacha type
        let cardsOfRarity = availableCards.filter { card in
            card.rarity == selectedRarity && gachaType.allowedCardTypes.contains(card.cardType)
        }
        
        guard let drawnCard = cardsOfRarity.randomElement() else { 
            // If no cards found for the specific type and rarity, try all rarities for the type
            let cardsOfType = availableCards.filter { card in
                gachaType.allowedCardTypes.contains(card.cardType)
            }
            guard let fallbackCard = cardsOfType.randomElement() else { 
                return false 
            }
            return processDrawnCard(fallbackCard)
        }
        
        return processDrawnCard(drawnCard)
    }
    
    // Helper function to process the drawn card
    private func processDrawnCard(_ drawnCard: PenguinCard) -> Bool {
        // Update card data
        var updatedCard = drawnCard
        updatedCard.timesDrawn += 1
        updatedCard.unlocked = true
        
        // Check if card was already collected from Core Data
        let wasCollected = isWordCollectedInCoreData(word: updatedCard.englishWord)
        lastDrawWasDuplicate = wasCollected
        
        if !wasCollected {
            updatedCard.collected = true
            updatedCard.dateCollected = Date()
            // Add word to PenguinCardWord if it's a new card
            addPenguinWord(word: updatedCard.englishWord)
        } else {
            // Refund coins for duplicate
            addCoin(by: updatedCard.duplicateRefund)
        }
        
        // Update in available cards
        if let index = availableCards.firstIndex(where: { $0.id == drawnCard.id }) {
            availableCards[index] = updatedCard
        }
        
        // Add to collected if not already there
        if !collectedCards.contains(where: { $0.id == drawnCard.id }) {
            collectedCards.append(updatedCard)
        } else {
            // Update existing collected card
            if let collectedIndex = collectedCards.firstIndex(where: { $0.id == drawnCard.id }) {
                collectedCards[collectedIndex] = updatedCard
            }
        }
        
        lastDrawnCard = updatedCard
        showGashaResult = true
        saveCollectedCards()
        
        return true
    }
    
    // Save collected cards to UserDefaults
    private func saveCollectedCards() {
        if let encoded = try? JSONEncoder().encode(collectedCards) {
            UserDefaults.standard.set(encoded, forKey: "CollectedPenguinCards")
        }
    }
    
    // Load collected cards from UserDefaults and sync with Core Data
    private func loadCollectedCards() {
        // First sync availableCards with Core Data to ensure correct collected status
        syncCardsWithCoreData()
        
        if let data = UserDefaults.standard.data(forKey: "CollectedPenguinCards"),
           let decoded = try? JSONDecoder().decode([PenguinCard].self, from: data) {
            collectedCards = decoded
            
            // Update availableCards based on collected cards
            for collectedCard in collectedCards {
                if let index = availableCards.firstIndex(where: { $0.id == collectedCard.id }) {
                    availableCards[index] = collectedCard
                }
            }
        }
    }
    
    // Sync cards with Core Data to ensure correct collected status
    private func syncCardsWithCoreData() {
        for index in availableCards.indices {
            let isCollectedInCoreData = isWordCollectedInCoreData(word: availableCards[index].englishWord)
            availableCards[index].collected = isCollectedInCoreData
            
            // Update collectedCards array based on Core Data
            if isCollectedInCoreData {
                if !collectedCards.contains(where: { $0.id == availableCards[index].id }) {
                    collectedCards.append(availableCards[index])
                }
            } else {
                collectedCards.removeAll { $0.id == availableCards[index].id }
            }
        }
    }
    
    // Check if word is collected in Core Data
    private func isWordCollectedInCoreData(word: String) -> Bool {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<PenguinCardWord> = PenguinCardWord.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "penguinword == %@", word)
        
        do {
            let results = try context.fetch(fetchRequest)
            return !results.isEmpty
        } catch {
            print("Failed to check if word is collected in Core Data: \(error)")
            return false
        }
    }
    
    // Mark card as viewed (now handled by CoreData)
    func markCardAsViewed(cardId: UUID) {
        // Find the card to get its English word
        if let card = collectedCards.first(where: { $0.id == cardId }) {
            TurnIsNewTofalse(wordString: card.englishWord)
        }
        saveCollectedCards()
    }
}
