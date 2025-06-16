//
//  GachaSystem.swift
//  Englishot
//
//  Created by 陳姿縈 on 6/13/25.
//
import SwiftUI

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
        default: return .gray
        }
    }
    
    var cardTypeIcon: String {
        switch cardType {
        case "Emotion": return "face.smiling"
        case "Profession": return "briefcase"
        case "Activity": return "figure.walk"
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
    
    // Draw rates
    private let snowflakeRate: Double = 0.6    // 60%
    private let iceCrystalRate: Double = 0.25  // 25%
    private let frozenStarRate: Double = 0.12  // 12%
    private let auroraRate: Double = 0.03      // 3%
    
    init() {
        setupInitialCards()
        loadCollectedCards()
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
                cardName: "Business Penguin",
                englishWord: "businessperson",
                chineseWord: "商人",
                pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/b/bus/busin/businessperson.mp3",
                emotionType: "professional",
                rarity: "Frozen Star",
                imageName: "penguin_business",
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
            )
        ]
    }
    
    // Draw a card using coins
    func drawCard(gameState: GameState) -> Bool {
        let drawCost = 100 // Basic draw cost
        
        deductCoin(by: (Int64(drawCost) ))
        
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
        
        // Filter cards by rarity
        let cardsOfRarity = availableCards.filter { $0.rarity == selectedRarity }
        guard let drawnCard = cardsOfRarity.randomElement() else { return false }
        
        // Update card data
        var updatedCard = drawnCard
        updatedCard.timesDrawn += 1
        updatedCard.unlocked = true
        
        // Check if card was already collected
        let wasCollected = updatedCard.collected
        
        if !updatedCard.collected {
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
    
    // Load collected cards from UserDefaults
    private func loadCollectedCards() {
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
}
