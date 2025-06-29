import SwiftUI
import CoreData

struct GotCardView: View {
    let card: PenguinCard
    let isDuplicate: Bool
    let refundAmount: Int64
    @Binding var isPresented: Bool
    @State private var showContent = false
    @State private var isNew = false
    
    var body: some View {
        ZStack {
            
            // Semi-transparent background
            Color.black.opacity(0.7)
                .ignoresSafeArea(.all)
                .onTapGesture {
                    withAnimation {
                        isPresented = false
                    }
                }
            
            // Card content
            VStack(spacing: 20) {
                // Card image with effects
                ZStack {
                    // Background glow
                    Circle()
                        .fill(card.rarityGradient)
                        .frame(width: 200, height: 220)
                        .blur(radius: 20)
                        .opacity(0.5)
                    
                    // Card image
                    Image(card.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [.white, card.rarityColor],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 3
                                )
                        )
                        .shadow(color: card.rarityColor.opacity(0.5), radius: 10)
                    
                    // New badge if it's a new card
                    if isNew && !isDuplicate {
                        VStack {
                            HStack {
                                Spacer()
                                ZStack {
                                    // Badge background with glow effect
                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 60, height: 60)
                                        .shadow(color: .red.opacity(0.7), radius: 8)
                                    
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: [.red, .pink],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 60, height: 60)
                                    
                                    // NEW text
                                    Text("NEW")
                                        .font(.system(size: 14, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                        .shadow(color: .black.opacity(0.5), radius: 2)
                                }
                                .offset(x: 15, y: -15)
                            }
                            Spacer()
                        }
                        .frame(width: 200, height: 200)
                    }
                }
                .scaleEffect(showContent ? 1 : 0.5)
                .opacity(showContent ? 1 : 0)
                
                // Card information
                VStack(spacing: 15) {
                    // English word
                    Text(card.englishWord)
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    // Chinese translation
                    Text(card.chineseWord)
                        .font(.system(size: 24, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                    
                    // Rarity badge
                    HStack(spacing: 5) {
                        Text(card.rarityIcon)
                        Text(card.rarity)
                    }
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(card.rarityColor)
                    )
                    
                    // Duplicate card message
                    if isDuplicate {
                        VStack(spacing: 8) {
                            Text("你已經擁有這張卡片！")
                                .font(.system(size: 18, weight: .medium, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text("退回 \(refundAmount) 金幣作為補償！")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(.yellow)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.1))
                        )
                    }
                }
                .offset(y: showContent ? 0 : 50)
                .opacity(showContent ? 1 : 0)
                
                // Confirm button
                Button(action: {
                    withAnimation {
                        isPresented = false
                        SoundPlayer.shared.playSound(named: "pop")

                    }
                }) {
                    Text("確認")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 12)
                        .background(
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [.blue, .purple],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                }
                .offset(y: showContent ? 0 : 30)
                .opacity(showContent ? 1 : 0)
            }
            .frame(width: 350, height: 500)
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color(#colorLiteral(red: 0.1, green: 0.15, blue: 0.3, alpha: 1)))
            )
            .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear)
        .onAppear {
            checkIfWordIsNew()
            // 播放显示卡片音效
            SoundPlayer.shared.playSound(named: "showcard")
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                showContent = true
            }
        }
    }
    
    private func checkIfWordIsNew() {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<PenguinCardWord> = PenguinCardWord.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "penguinword == %@", card.englishWord)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let penguinCardWord = results.first {
                isNew = penguinCardWord.isNew
            } else {
                isNew = false
            }
        } catch {
            print("Failed to check if word is new: \(error)")
            isNew = false
        }
    }
} 
