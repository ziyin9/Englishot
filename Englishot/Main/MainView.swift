import SwiftUI

struct MainView: View {
    @State private var selectedTab: Tab = .defaultTab
    @StateObject private var uiState = UIState()
    @StateObject private var gameState = GameState()
    @State private var isHovered: Tab?
    @FetchRequest(entity: Coin.entity(), sortDescriptors: []) var coinEntities: FetchedResults<Coin>

    
    private var currentCoins: Int64 {
        coinEntities.first?.amount ?? 0
    }
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
                if ((selectedTab != .setting)&&(uiState.isCoinVisible)){
                    CoinDisplayView(coins: currentCoins)
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
        case .gacha:
            GachaView(gachaSystem: GachaSystem())
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
                ForEach([Tab.map, .backpack, .minigame, .gacha, .setting], id: \.self) { tab in
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
                        .font(.system(size: 12))
                        .bold()
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
        case .map: return "地圖"//"Map"
        case .backpack: return "背包"//"Backpack"
        case .minigame: return "複習"//"Minigames"
        case .gacha: return "抽卡"//"Gacha"
        case .setting: return "設定"//"Settings"
        }
    }
    
    private func getIconName(for tab: Tab) -> String {
        switch tab {
        case .map: return "mapicon"
        case .backpack: return "bbpicon"
        case .minigame:return "minigame"
        case .gacha: return "gachaicon"
        case .setting: return "nutsetting"
        }
    }
}

enum Tab: Int {
    case map
    case backpack
    case minigame
    case gacha
    case setting
    
    static var defaultTab: Tab { .map }
}
