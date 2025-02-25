//
//  SchoolView.swift
//  coreMLtext
//
//  Created by 陳姿縈 on 12/3/24.
//
//
//  SchoolView.swift
//  coreMLtext
//
//  Created by 陳姿縈 on 12/3/24.
//
import SwiftUI

struct SchoolView: View {
    @Environment(\..dismiss) var dismiss
    @EnvironmentObject var uiState: UIState
    
    // Animation states
    @State private var isLoaded = false
    @State private var selectedLevel: Int?
    @State private var snowflakes: [Snowflake] = (0..<50).map { _ in Snowflake() }
  

    
    // Level data
    private let levels: [(name: String, icon: String, view: AnyView)] = [
        ("Classroom1", "book.fill", AnyView(HomeGame1().navigationBarBackButtonHidden(true))),
        ("Classroom2", "pencil", AnyView(HomeGame2().navigationBarBackButtonHidden(true))),
        ("Music", "music.note", AnyView(HomeGame3().navigationBarBackButtonHidden(true))),
        ("Playground", "sportscourt.fill", AnyView(HomeGame4().navigationBarBackButtonHidden(true))),

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
                
                // Animated snowfall
                ForEach(snowflakes) { snowflake in
                    Snowflake_View(snowflake: snowflake)
                }
                
                VStack(spacing: 30) {
                    // Header
                    HStack(alignment: .center) {
                       
                                            
                                            Text("       School")
                            .font(.system(size: 60, weight: .bold, design: .serif))
                                                        .fontWeight(.bold)
                                                        .foregroundColor(.black)
                                            
                                            Spacer()
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(.horizontal)
                                        .offset(x: isLoaded ? 0 : -100)
                    

                    VStack(spacing: 25) {
                        Image("Schoolimage")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .shadow(color: .blue.opacity(0.3), radius: 10)
                            .scaleEffect(isLoaded ? 1 : 0.5)
                        
                        // Level buttons
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
    SchoolView()
        .environmentObject(UIState())
}
