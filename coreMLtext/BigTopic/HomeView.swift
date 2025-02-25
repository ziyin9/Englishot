






import SwiftUI

struct HomeView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var uiState: UIState
    
    // Animation states
    
    @State private var isLoaded = false
    @State private var selectedLevel: Int?
    @State private var snowflakes: [Snowflake] = (0..<50).map { _ in Snowflake() }
    // Level data
    private let levels: [(name: String, icon: String, view: AnyView, levelID: String)] = [
            ("Bathroom", "shower.fill", AnyView(HomeGame1().navigationBarBackButtonHidden(true)),"bathroom"),
            ("Kitchen", "fork.knife", AnyView(HomeGame2().navigationBarBackButtonHidden(true)),"kitchen"),
            ("Living Room", "sofa.fill", AnyView(HomeGame3().navigationBarBackButtonHidden(true)),"living_room"),
            ("Garage", "car.fill", AnyView(HomeGame4().navigationBarBackButtonHidden(true)),"garage"),
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
                    HStack {
//                        BackButton{
//                            dismiss()
//                            }
                        Text("        Home")
                        .font(.system(size: 60, weight: .bold, design: .serif))
                                                    .fontWeight(.bold)
                                                    .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .offset(x: isLoaded ? 0 : -100)
                    
                    // Main content
                    VStack(spacing: 25) {
                        Image("Homeimage")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
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
    HomeView()
        .environmentObject(UIState())
}
