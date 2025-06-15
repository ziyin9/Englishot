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
    var rarity: String // Common, Rare, Epic, Legendary
    var imageName: String
    var timesDrawn: Int16 = 0
    var dateCollected: Date?
    var descriptionText: String
    var voiceLine: String
    
    // Helper computed properties
    var rarityColor: Color {
        switch rarity {
        case "Common": return .gray
        case "Rare": return .blue
        case "Epic": return .purple
        case "Legendary": return .orange
        default: return .gray
        }
    }
    
    var drawCost: Int {
        switch rarity {
        case "Common": return 50
        case "Rare": return 100
        case "Epic": return 200
        case "Legendary": return 500
        default: return 50
        }
    }
}


class GachaSystem: ObservableObject {
    @Published var availableCards: [PenguinCard] = []
    @Published var collectedCards: [PenguinCard] = []
    @Published var showGashaResult = false
    @Published var lastDrawnCard: PenguinCard?
    
    // Draw rates
    private let commonRate: Double = 0.6    // 60%
    private let rareRate: Double = 0.25     // 25%
    private let epicRate: Double = 0.12     // 12%
    private let legendaryRate: Double = 0.03 // 3%
    
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
                rarity: "Common",
                imageName: "penguin_happy",
                descriptionText: "A joyful penguin with a bright smile!",
                voiceLine: "I'm so happy!"
            ),
            PenguinCard(
                cardName: "Angry Penguin",
                englishWord: "angry",
                chineseWord: "生氣",
                pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/a/ang/angry/angry.mp3",
                emotionType: "angry",
                rarity: "Common",
                imageName: "penguin_angry",
                descriptionText: "A grumpy penguin having a bad day!",
                voiceLine: "I'm very angry!"
            ),
            PenguinCard(
                cardName: "Sad Penguin",
                englishWord: "sad",
                chineseWord: "難過",
                pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/s/sad/sad__/sad.mp3",
                emotionType: "sad",
                rarity: "Common",
                imageName: "penguin_sad",
                descriptionText: "A melancholy penguin feeling blue.",
                voiceLine: "I feel so sad..."
            ),
            PenguinCard(
                cardName: "Excited Penguin",
                englishWord: "excited",
                chineseWord: "興奮",
                pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/e/exc/excit/excited.mp3",
                emotionType: "excited",
                rarity: "Rare",
                imageName: "penguin_excited",
                descriptionText: "An energetic penguin full of enthusiasm!",
                voiceLine: "I'm so excited!"
            ),
            PenguinCard(
                cardName: "Surprised Penguin",
                englishWord: "surprised",
                chineseWord: "驚訝",
                pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/s/sur/surpr/surprised.mp3",
                emotionType: "surprised",
                rarity: "Rare",
                imageName: "penguin_surprised",
                descriptionText: "A penguin caught off guard!",
                voiceLine: "Oh my! I'm surprised!"
            ),
            
            // Profession Cards
            PenguinCard(
                cardName: "Teacher Penguin",
                englishWord: "teacher",
                chineseWord: "老師",
                pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/t/tea/teach/teacher.mp3",
                emotionType: "professional",
                rarity: "Epic",
                imageName: "penguin_teacher",
                descriptionText: "A wise penguin educating young minds.",
                voiceLine: "Let's learn together!"
            ),
            PenguinCard(
                cardName: "Police Penguin",
                englishWord: "police",
                chineseWord: "警察",
                pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/p/pol/polic/police.mp3",
                emotionType: "professional",
                rarity: "Epic",
                imageName: "penguin_police",
                descriptionText: "A brave penguin keeping everyone safe.",
                voiceLine: "Stop right there!"
            ),
            PenguinCard(
                cardName: "Student Penguin",
                englishWord: "student",
                chineseWord: "學生",
                pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/s/stu/stude/student.mp3",
                emotionType: "professional",
                rarity: "Common",
                imageName: "penguin_student",
                descriptionText: "A curious penguin ready to learn!",
                voiceLine: "I love studying!"
            ),
//            PenguinCard(
//                cardName: "Farmer Penguin",
//                englishWord: "farmer",
//                chineseWord: "農夫",
//                pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/f/far/farme/farmer.mp3",
//                emotionType: "professional",
//                rarity: "Rare",
//                imageName: "penguin_farmer",
//                descriptionText: "A hardworking penguin growing crops.",
//                voiceLine: "Fresh fish for everyone!"
//            ),
//            PenguinCard(
//                cardName: "Chef Penguin",
//                englishWord: "chef",
//                chineseWord: "廚師",
//                pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/c/che/chef_/chef.mp3",
//                emotionType: "professional",
//                rarity: "Epic",
//                imageName: "penguin_chef",
//                descriptionText: "A culinary master penguin!",
//                voiceLine: "Bon appétit!"
//            ),
//            PenguinCard(
//                cardName: "Doctor Penguin",
//                englishWord: "doctor",
//                chineseWord: "醫生",
//                pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/d/doc/docto/doctor.mp3",
//                emotionType: "professional",
//                rarity: "Legendary",
//                imageName: "penguin_doctor",
//                descriptionText: "A healing penguin helping others!",
//                voiceLine: "Take care of yourself!"
//            ),
//            PenguinCard(
//                cardName: "Artist Penguin",
//                englishWord: "artist",
//                chineseWord: "藝術家",
//                pronunciationURL: "https://dictionary.cambridge.org/zht/media/英語-漢語-繁體/us_pron/a/art/artis/artist.mp3",
//                emotionType: "professional",
//                rarity: "Legendary",
//                imageName: "penguin_artist",
//                descriptionText: "A creative penguin making beautiful art!",
//                voiceLine: "Art is life!"
//            )
        ]
    }
    
    // Draw a card using coins
    func drawCard(gameState: GameState) -> Bool {
        let drawCost = 100 // Basic draw cost
        
        deductCoin(by:100)
        
        let randomValue = Double.random(in: 0...1)
        let selectedRarity: String
        
        if randomValue <= legendaryRate {
            selectedRarity = "Legendary"
        } else if randomValue <= legendaryRate + epicRate {
            selectedRarity = "Epic"
        } else if randomValue <= legendaryRate + epicRate + rareRate {
            selectedRarity = "Rare"
        } else {
            selectedRarity = "Common"
        }
        
        // Filter cards by rarity
        let cardsOfRarity = availableCards.filter { $0.rarity == selectedRarity }
        guard let drawnCard = cardsOfRarity.randomElement() else { return false }
        
        // Update card data
        var updatedCard = drawnCard
        updatedCard.timesDrawn += 1
        updatedCard.unlocked = true
        
        if !updatedCard.collected {
            updatedCard.collected = true
            updatedCard.dateCollected = Date()
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
