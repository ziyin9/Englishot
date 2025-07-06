//
//  CardGridItem.swift
//  Englishot
//
//  Created by 陳姿縈 on 6/16/25.
//
import SwiftUI
import CoreData

struct CardGridItem: View {
    let card: PenguinCard
    @State private var showDetail = false
    @State private var isCollected = false
    @State private var isNew = false
    @Binding var refreshTrigger: Bool
    @EnvironmentObject var gachaSystem: GachaSystem
    
    // Add rarity color definitions
    private var rarityColors: [String: [Color]] {
        [
            "Snowflake": [Color(hex: "AEE9F3")],
            "Ice Crystal": [Color(hex: "72D0F4")],
            "Frozen Star": [Color(hex: "5A9EF8")],
            "Aurora": [
                Color(hex: "8EC6FF"),
                Color(hex: "D1BFFF"),
                Color(hex: "A3F2E5")
            ]
        ]
    }
    
    private var rarityIcon: String {
        switch card.rarity {
        case "Snowflake": return "snowflake"
        case "Ice Crystal": return "sparkles"
        case "Frozen Star": return "star.fill"
        case "Aurora": return "sparkles.rectangle.stack"
        default: return "questionmark"
        }
    }
    
    var body: some View {
        Button(action: {
            if isCollected {
                // Mark as viewed when clicked
                if isNew {
                    TurnIsNewTofalse(wordString: card.englishWord)
                    isNew = false
                }
                SoundPlayer.shared.playSound(named: "pop")
                showDetail = true
                
            }
            
            if !showDetail {
                SoundPlayer.shared.playSound(named: "poplock")
            }
            
        }) {
            ZStack {
                // Card background
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: isCollected ?
                            (rarityColors[card.rarity] ?? [Color.gray]) :
                                [Color.gray.opacity(0.3), Color.gray.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                LinearGradient(
                                    colors: isCollected ?
                                    [Color.white.opacity(0.5), Color.white.opacity(0.3)] :
                                        [Color.gray.opacity(0.2), Color.gray.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                
                // Rarity effect overlay
                if isCollected {
                    ZStack {
                        // Snowflake pattern for Snowflake rarity
                        if card.rarity == "Snowflake" {
                            ForEach(0..<3) { i in
                                Image(systemName: "snowflake")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white.opacity(0.2))
                                    .rotationEffect(.degrees(Double(i) * 60))
                                    .offset(x: CGFloat.random(in: -20...20), y: CGFloat.random(in: -20...20))
                            }
                        }
                        
                        // Sparkle effect for Ice Crystal
                        if card.rarity == "Ice Crystal" {
                            ForEach(0..<5) { i in
                                Image(systemName: "sparkle")
                                    .font(.system(size: 15))
                                    .foregroundColor(.white.opacity(0.3))
                                    .offset(x: CGFloat.random(in: -25...25), y: CGFloat.random(in: -25...25))
                            }
                        }
                        
                        // Star effect for Frozen Star
                        if card.rarity == "Frozen Star" {
                            ForEach(0..<3) { i in
                                Image(systemName: "star.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(.white.opacity(0.3))
                                    .offset(x: CGFloat.random(in: -20...20), y: CGFloat.random(in: -20...20))
                            }
                        }
                        
                        // Aurora effect for Aurora rarity
                        if card.rarity == "Aurora" {
                            ForEach(0..<3) { i in
                                Image(systemName: "sparkles")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white.opacity(0.3))
                                    .offset(x: CGFloat.random(in: -25...25), y: CGFloat.random(in: -25...25))
                            }
                        }
                    }
                }
                ZStack{
                    VStack(spacing: 8) {
                        // Card image
                        if isCollected {
                            Image(card.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 70)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                                .shadow(color: (rarityColors[card.rarity]?.first ?? Color.gray).opacity(0.3), radius: 5)
                        } else {
                            // Locked card placeholder
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color.gray.opacity(0.3),
                                                Color.gray.opacity(0.1)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                
                                Image(systemName: "lock.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white.opacity(0.5))
                            }
                            .frame(height: 70)
                        }
                        //點進去才能看好了
                        // Card name
//                        Text(card.englishWord)
//                            .font(.s－ystem(size: 15, weight: .medium, design: .rounded))
//                            .foregroundColor(.white)
//                            .lineLimit(1)
                        
                        
                    }
                    .padding(8)
                    
                    // New badge
                    if isCollected && isNew {
                        VStack {
                            HStack {
                                Spacer()
                                Text("New")
                                    .font(.system(size: 10, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(
                                        Capsule()
                                            .fill(Color.red)
                                    )
                                    .padding(4)
                            }
                            Spacer()
                        }
                    }
                }
                // Rarity badge
                HStack{
                    VStack{
                        HStack(spacing: 4) {
                            Image(systemName: rarityIcon)
                                .font(.system(size: 10))
                            //              Text(card.rarity)
                            //                  .font(.system(size: 10, weight: .medium))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
//                        .background(
//                            Capsule()
//                                .fill((rarityColors[card.rarity]?.first ?? Color.gray).opacity(0.3))
//                        )
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showDetail) {
            // pop.mp3 sound
            CardDetailView(card: card)
                .environmentObject(gachaSystem)
                .onDisappear {
                    gachaSystem.markCardAsViewed(cardId: card.id)
                }

        }
        .onAppear {
            checkIfWordIsCollected()
        }
        .onChange(of: refreshTrigger) { _ in
            checkIfWordIsCollected()
        }
    }
    
    private func checkIfWordIsCollected() {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<PenguinCardWord> = PenguinCardWord.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "penguinword == %@", card.englishWord)
        
        do {
            let results = try context.fetch(fetchRequest)
            isCollected = !results.isEmpty
            // Check if the word is new
            if let penguinCardWord = results.first {
                isNew = penguinCardWord.isNew
            } else {
                isNew = false
            }
        } catch {
            print("Failed to check if word is collected: \(error)")
            isCollected = false
            isNew = false
        }
    }
}

