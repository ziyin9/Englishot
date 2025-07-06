import SwiftUI
import CoreData

struct CollectionInfoView: View {
    @Binding var isPresented: Bool
    let gachaSystem: GachaSystem
    @FetchRequest(entity: PenguinCardWord.entity(), sortDescriptors: []) var collectedCards: FetchedResults<PenguinCardWord>
    
    private let rarities = ["Snowflake", "Ice Crystal", "Frozen Star", "Aurora"]
    private let categories = ["Emotion", "Profession", "Activity", "Festival"]
    
    private var rarityColors: [String: [Color]] {
        [
            "Snowflake": [Color(hex: "AEE9F3"), Color(hex: "87CEEB")],
            "Ice Crystal": [Color(hex: "72D0F4"), Color(hex: "4682B4")],
            "Frozen Star": [Color(hex: "5A9EF8"), Color(hex: "1E90FF")],
            "Aurora": [Color(hex: "8EC6FF"), Color(hex: "D1BFFF"), Color(hex: "A3F2E5")]
        ]
    }
    
    private var rarityIcons: [String: String] {
        [
            "Snowflake": "snowflake",
            "Ice Crystal": "sparkles",
            "Frozen Star": "star.fill",
            "Aurora": "sparkles.rectangle.stack"
        ]
    }
    
    private var gachaRates: [String: Double] {
        [
            "Snowflake": 50.0,
            "Ice Crystal": 30.0,
            "Frozen Star": 15.0,
            "Aurora": 5.0
        ]
    }
    
    var body: some View {
        ZStack {
            // Background overlay
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isPresented = false
                    }
                }
            
            // Main content
            VStack(spacing: 0) {
                // Header
                headerView
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Collection Overview
                        collectionOverviewView
                        
                        // Rarity Information
                        rarityInfoView
                        
                        // Category Information
                        categoryInfoView
                        
                        // Gacha Rates
                        gachaRatesView
                    }
                    .padding()
                }
            }
            .frame(maxWidth: 350, maxHeight: 600)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(#colorLiteral(red: 0.1, green: 0.15, blue: 0.3, alpha: 0.95)),
                                Color(#colorLiteral(red: 0.2, green: 0.25, blue: 0.4, alpha: 0.95))
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.3), Color.blue.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
            )
            .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
        }
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isPresented)
    }
    
    private var headerView: some View {
        ZStack {
            HStack {
                Image("gachaicon")
                    .resizable()
                    .frame(width: 24, height: 24)
                
                Text("收集冊資訊")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isPresented = false
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .padding()
        }
        .background(
            LinearGradient(
                colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.2)],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
    }
    
    private var collectionOverviewView: some View {
        VStack(spacing: 12) {
            Text("收集進度")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
            
            let totalCards = gachaSystem.availableCards.count
            let collectedCount = collectedCards.count
            let progress = totalCards > 0 ? Double(collectedCount) / Double(totalCards) : 0.0
            
            VStack(spacing: 8) {
                HStack {
                    Text("\(collectedCount)")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.green)
                    
                    Text("/")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                    
                    Text("\(totalCards)")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("\(Int(progress * 100))%")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(.blue)
                }
                
                ProgressView(value: progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    .scaleEffect(y: 2)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.1))
            )
        }
    }
    
    private var rarityInfoView: some View {
        VStack(spacing: 12) {
            Text("稀有度")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 10) {
                ForEach(rarities, id: \.self) { rarity in
                    let rarityCards = gachaSystem.availableCards.filter { $0.rarity == rarity }
                    let collectedCount = collectedCards.filter { card in
                        rarityCards.contains { $0.englishWord == card.penguinword }
                    }.count
                    
                    VStack(spacing: 6) {
                        HStack {
                            Image(systemName: rarityIcons[rarity] ?? "star")
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                            
                            Text(getRarityTitle(rarity))
                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                .foregroundColor(.white)
                        }
                        
                        Text("\(collectedCount)/\(rarityCards.count)")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    colors: rarityColors[rarity] ?? [.gray],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                .opacity(0.3)
                            )
                    )
                }
            }
        }
    }
    
    private var categoryInfoView: some View {
        VStack(spacing: 12) {
            Text("類別")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
            
            ForEach(categories, id: \.self) { category in
                let categoryCards = gachaSystem.availableCards.filter { $0.cardType == category }
                let collectedCount = collectedCards.filter { card in
                    categoryCards.contains { $0.englishWord == card.penguinword }
                }.count
                
                HStack {
                    Image(getCategoryIcon(category))
                        .resizable()
                        .frame(width: 20, height: 20)
                    
                    Text(getCategoryTitle(category))
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("\(collectedCount)/\(categoryCards.count)")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(getCategoryColor(category))
                    
                    ProgressView(value: categoryCards.count > 0 ? Double(collectedCount) / Double(categoryCards.count) : 0)
                        .progressViewStyle(LinearProgressViewStyle(tint: getCategoryColor(category)))
                        .frame(width: 60)
                        .scaleEffect(y: 1.5)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white.opacity(0.1))
                )
            }
        }
    }
    
    private var gachaRatesView: some View {
        VStack(spacing: 12) {
            Text("抽獎機率")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
            
            VStack(spacing: 8) {
                ForEach(rarities, id: \.self) { rarity in
                    HStack {
                        Image(systemName: rarityIcons[rarity] ?? "star")
                            .font(.system(size: 12))
                            .foregroundColor(.white)
                        
                        Text(getRarityTitle(rarity))
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("\(Int(gachaRates[rarity] ?? 0))%")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(rarityColors[rarity]?.first ?? .white)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white.opacity(0.05))
                    )
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.1))
            )
        }
    }
    
    private func getRarityTitle(_ rarity: String) -> String {
        switch rarity {
        case "Snowflake": return "雪花"
        case "Ice Crystal": return "冰晶"
        case "Frozen Star": return "冰星"
        case "Aurora": return "極光"
        default: return rarity
        }
    }
    
    private func getCategoryIcon(_ category: String) -> String {
        switch category {
        case "Emotion": return "Emotion"
        case "Profession": return "Profession"
        case "Activity": return "Activity"
        case "Festival": return "Festival"
        default: return "questionmark"
        }
    }
    
    private func getCategoryTitle(_ category: String) -> String {
        switch category {
        case "Emotion": return "表情"
        case "Profession": return "職業"
        case "Activity": return "活動"
        case "Festival": return "節日"
        default: return category
        }
    }
    
    private func getCategoryColor(_ category: String) -> Color {
        switch category {
        case "Emotion": return .pink
        case "Profession": return .green
        case "Activity": return .orange
        case "Festival": return .purple
        default: return .gray
        }
    }
}

// Color extension for hex support (if not already defined)
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    CollectionInfoView(isPresented: .constant(true), gachaSystem: GachaSystem())
} 