import SwiftUI


struct MainView: View {
    @State private var selectedTab: Tab = .defaultTab
    @StateObject private var uiState = UIState()
    @StateObject private var gameState = GameState()
    @State private var isHovered: Tab?
    
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Color(#colorLiteral(red: 0.937, green: 0.937, blue: 0.937, alpha: 1))
                    .ignoresSafeArea()
                
                TabContentView(selectedTab: $selectedTab)
                    .environmentObject(uiState)
                    .environmentObject(gameState)
                
                if uiState.isNavBarVisible {
                    TopNavBarView(selectedTab: $selectedTab, isHovered: $isHovered)
                }
            }
            .ignoresSafeArea(.keyboard)
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
        case .minigame:
            MiniGameView()
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
        VStack {
            Spacer()
            
            HStack(spacing: 0) {
//                .data
                ForEach([Tab.map, .backpack, .minigame , .setting], id: \.self) { tab in
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
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.1), radius: 10, y: -5)
            )
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

struct TopNavBarItem: View {
    let tab: Tab
    let isSelected: Bool
    let isHovered: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(getIconName(for: tab))
                    .resizable()
                    .scaledToFit()
                    .frame(width: isSelected ? 40 : 24, height: isSelected ? 40 : 24)

                if !isSelected{
                    Text(getTabTitle(for: tab))
                        .font(.caption2)
                        .fontWeight(.regular)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                ZStack {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.blue.opacity(0.2))
                    }
                }
            )
            .foregroundColor(isSelected ? .blue : .gray)
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isHovered ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isHovered)
    }
    
    private func getTabTitle(for tab: Tab) -> String {
        switch tab {
        case .map: return "Map"
        case .backpack: return "Backpack"
        case .minigame: return "Minigames"
        case .setting: return "Settings"
        }
    }
    
    private func getIconName(for tab: Tab) -> String {
        switch tab {
        case .map: return "mapicon"
        case .backpack: return "bbpicon"
        case .minigame:return "minigame"
        case .setting: return "nutsetting"
        }
    }
}

struct NamespaceWrapper {
    @Namespace static var namespace
}

enum Tab: Int {
    case map
    case backpack
    case minigame
    case setting
//    case data
    
    static var defaultTab: Tab { .map }
}


#Preview {
    MainView()
}
