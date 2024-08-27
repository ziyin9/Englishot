//
//  MarketView.swift
//  coreMLtext
//
//  Created by 陳姿縈 on 12/3/24.
//
import SwiftUI

struct MarketView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var uiState: UIState
    
    // Animation states
    @State private var isLoaded = false
    @State private var selectedLevel: Int?
    @State private var snowflakes: [Snowflake] = (0..<50).map { _ in Snowflake() }
 
    
    // Level data
    private let levels: [(name: String, icon: String, view: AnyView)] = [
        ("Fruit", "applelogo", AnyView(HomeGame1().navigationBarBackButtonHidden(true))),
        ("Vegetable", "carrot.fill", AnyView(HomeGame2().navigationBarBackButtonHidden(true))),
        ("Spices", "flame.fill", AnyView(HomeGame3().navigationBarBackButtonHidden(true)))
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.blue.opacity(0.1),
                        Color.white.opacity(0.3),
                        Color.blue.opacity(0.2)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                

                ForEach(snowflakes) { snowflake in
                    Snowflake_View(snowflake: snowflake)
                }
                VStack {

                    VStack{
                        HStack {
                            Text("       Market")
                                .font(.system(size: 60, weight: .bold, design: .serif))
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .offset(x: isLoaded ? 0 : -100)
                    }
                    VStack(spacing: 25) {
                        Image("Marketimage")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 300)
                            .shadow(color: .blue.opacity(0.3), radius: 10)
                            .scaleEffect(isLoaded ? 1 : 0.5)
                        
                        // Level buttons grid
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 20) {
                            ForEach(Array(levels.enumerated()), id: \.offset) { index, level in
                                LevelButton(
                                    index: index,
                                    icon: level.icon,
                                    name: level.name,
                                    destination: level.view,
                                    isSelected: selectedLevel == index
                                )
                                .offset(y: isLoaded ? 0 : 200)
                                .animation(.spring(response: 0.6, dampingFraction: 0.7)
                                    .delay(Double(index) * 0.1), value: isLoaded)
                            }
                        }
                        .padding(.horizontal)
                    }
                    Spacer()
                }
//                .padding(.top,-150)
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    BackButton{
                        dismiss()
                        }
                }
            })
            .onAppear {
                uiState.isNavBarVisible = false
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    isLoaded = true
                }
            }
        }
    }
}

#Preview {
    MarketView()
        .environmentObject(UIState())
}
