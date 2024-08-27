import SwiftUI


struct MainView: View {
    @State private var selectedTab: Tab = .map
    @StateObject private var uiState = UIState()
    @StateObject private var gameState = GameState()
    @State private var isHovered: Tab?
    
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .topTrailing) {
                Color(#colorLiteral(red: 0.937, green: 0.937, blue: 0.937, alpha: 1))
                    .ignoresSafeArea()
                
                TabContentView(selectedTab: $selectedTab)
                    .environmentObject(uiState)
                    .environmentObject(gameState)
                
                if uiState.isNavBarVisible {

                    TopNavBarView(selectedTab: $selectedTab, isHovered: $isHovered)
                        .padding(.top, 50)
                        .padding(.trailing, 20)
                }
            }
            .ignoresSafeArea()
            .navigationBarHidden(true)
        }
    }

}

struct TabContentView: View {
    @Binding var selectedTab: Tab
    @EnvironmentObject var gameState: GameState
    
    var body: some View {
        switch selectedTab {
        case .map:
            GameMapView()
            
        case .backpack:
            BackpackView()
            .environmentObject(gameState)
        case .setting:
            SettingView()
        }
    }
}


func triggerImpactFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
    let generator = UIImpactFeedbackGenerator(style: style)
    generator.impactOccurred()
}



struct TopNavBarView: View {
    @Binding var selectedTab: Tab
    @Binding var isHovered: Tab?
    
    var body: some View {
        VStack(spacing: 15) {
            ForEach([Tab.map, .backpack, .setting], id: \.self) { tab in
                TopNavBarItem(
                    tab: tab,
                    isSelected: selectedTab == tab,
                    isHovered: isHovered == tab,
                    action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedTab = tab
                            triggerImpactFeedback(style: .light)
                        }
                    }
                )
                .onHover { hovering in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isHovered = hovering ? tab : nil
                    }
                }
            }
        }
//        .background(
//            RoundedRectangle(cornerRadius: 25)
//                .fill(.ultraThinMaterial)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 25)
//                        .stroke(
//                            LinearGradient(
//                                colors: [.blue.opacity(0.3), .white.opacity(0.5)],
//                                startPoint: .topLeading,
//                                endPoint: .bottomTrailing
//                            ),
//                            lineWidth: 1
//                        )
//                )
//                .shadow(color: .blue.opacity(0.1), radius: 10)
//        )
//        .padding(8)
    }
}

struct TopNavBarItem: View {
    let tab: Tab
    let isSelected: Bool
    let isHovered: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // Ice crystal background
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                .white.opacity(isSelected ? 0.9 : 0.6),
                                .blue.opacity(isSelected ? 0.3 : 0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        .white.opacity(0.8),
                                        .blue.opacity(0.3)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .shadow(color: isSelected ? .blue.opacity(0.3) : .clear, radius: 5)
                
                // Icon
                Image(getIconName(for: tab))
                    .resizable()
//                    .renderingMode(.template)
                    .foregroundColor(isSelected ? .blue : .gray)
                    .frame(width: 45, height: 45)
                
                // Snow particles effect when selected
                if isSelected {
                    ForEach(0..<4) { i in
                        Circle()
                            .fill(.white.opacity(0.5))
                            .frame(width: 3, height: 3)
                            .offset(x: CGFloat.random(in: -20...20),
                                    y: CGFloat.random(in: -20...20))
                            .animation(
                                Animation.easeInOut(duration: 1)
                                    .repeatForever()
                                    .delay(Double(i) * 0.2),
                                value: isSelected
                            )
                    }
                }
            }
            .scaleEffect(isHovered ? 1.1 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isHovered)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func getIconName(for tab: Tab) -> String {
        switch tab {
        case .map: return "mapicon"
        case .backpack: return "bbpicon"
        case .setting: return "nutsetting"
        }
    }
}

enum Tab {
    case map
    case backpack
    case setting
}


#Preview {
    MainView()
}
