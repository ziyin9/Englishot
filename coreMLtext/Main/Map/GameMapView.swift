import SwiftUI
import UIKit

struct GameMapView: View {
    @State private var mapOffset: CGSize = .zero
    @State private var currentDragOffset: CGSize = .zero
    @State private var selectedLocation: String? = nil
    @State private var floatOffset: CGSize = .zero
    @State private var showTutorial: Bool = false
    @State private var angle: Double = 0
    @State private var rotateForward = true
    @EnvironmentObject var uiState: UIState
    
    let mapSize = CGSize(width: 640, height: 1904)

    var body: some View {
        ZStack {
            NavigationView {
                ZStack {
                    // 地圖背景
                    Image("map99")
                        .resizable()
                        .frame(width: mapSize.width, height: mapSize.height)
                        .offset(x: mapOffset.width + (currentDragOffset.width),
                                y: mapOffset.height + (currentDragOffset.height))
                        .gesture(
                            
                            DragGesture()
                                .onChanged { value in
                                    //  靈敏
                                    let scaledTranslation = CGSize(
                                        width: value.translation.width * 0.75,
                                        height: value.translation.height * 0.75
                                    )
                                    
                                    let proposedOffsetX = mapOffset.width + scaledTranslation.width
                                    let proposedOffsetY = mapOffset.height + scaledTranslation.height
                                    
                                    // 限
                                    currentDragOffset.width = max(min(proposedOffsetX, maxOffsetX()), minOffsetX()) - mapOffset.width
                                    currentDragOffset.height = max(min(proposedOffsetY, maxOffsetY()), minOffsetY()) - mapOffset.height
                                }
                                .onEnded { _ in
                                    // 更
                                    withAnimation {
                                        mapOffset.width += currentDragOffset.width
                                        mapOffset.height += currentDragOffset.height
                                        currentDragOffset = .zero
                                    }
                                }
                        )
                    
                    MapButton(iconName: "Homeimage", label: "Home", position: CGPoint(x: 370, y: 990), mapOffset: $mapOffset, currentDragOffset: $currentDragOffset,floatOffset: $floatOffset) {
                            selectedLocation = "Home"
                            triggerImpactFeedback(style: .light)
                        }
                        
                    MapButton(iconName: "Schoolimage", label: "School", position: CGPoint(x: 270, y: 1200), mapOffset: $mapOffset, currentDragOffset: $currentDragOffset,floatOffset: $floatOffset) {
                        selectedLocation = "School"
                        triggerImpactFeedback(style: .light)
                    }
                        
                    MapButton(iconName: "Mallimage", label: "Mall", position: CGPoint(x: 220, y: 580), mapOffset: $mapOffset, currentDragOffset: $currentDragOffset,floatOffset: $floatOffset) {
                        selectedLocation = "Mall"
                        triggerImpactFeedback(style: .light)
                    }
                    MapButton(iconName: "Marketimage", label: "Market", position: CGPoint(x: 420, y: 710), mapOffset: $mapOffset, currentDragOffset: $currentDragOffset,floatOffset: $floatOffset) {
                        selectedLocation = "Market"
                        triggerImpactFeedback(style: .light)
                    }
                    MapButton(iconName: "Zooimage", label: "Zoo", position: CGPoint(x: 200, y: 860), mapOffset: $mapOffset, currentDragOffset: $currentDragOffset,floatOffset: $floatOffset) {
                        selectedLocation = "Zoo"
                        triggerImpactFeedback(style: .light)
                    }
                    
                    
                    // Reset button
                    Button(action: {
                        withAnimation {
                            mapOffset = .zero // 重置偏移量
                        }
                        triggerImpactFeedback(style: .light)
                    }) {
                        Image("compass2")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.blue)
                            .padding(3)
                            .background(Circle().fill(Color.white.opacity(0.9)).shadow(radius: 4))
                    }
                    .position(x: 470, y: 1250)
                    
                    Button(action: {
                        withAnimation {
                            showTutorial = true
                            uiState.isNavBarVisible = false
                        }
                        triggerImpactFeedback(style: .light)
                    }) {
                        Image("QQ")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.blue)
                            .padding(3)
                    }
                    .rotationEffect(.degrees(angle))
                    .position(x: 470, y: 1190)
                    .onAppear {
                               startSwinging()
                           }
                    
                    // NavigationLink for location
                    NavigationLink(destination: destinationView(), tag: "Home", selection: $selectedLocation) { EmptyView() }
                    NavigationLink(destination: destinationView(), tag: "School", selection: $selectedLocation) { EmptyView() }
                    NavigationLink(destination: destinationView(), tag: "Mall", selection: $selectedLocation) { EmptyView() }
                    NavigationLink(destination: destinationView(), tag: "Market", selection: $selectedLocation) { EmptyView() }
                    NavigationLink(destination: destinationView(), tag: "Zoo", selection: $selectedLocation) { EmptyView() }
                }
                .ignoresSafeArea()
                .navigationBarHidden(true)
            }
            
            // Tutorial overlay (完全放在最外層 ZStack，不放在 NavigationView 內)
            if showTutorial {
                TutorialOverlayView(isShowing: $showTutorial)
                    .transition(.opacity)
                    .zIndex(999) // 確保在最頂層
                    .onAppear {
                        triggerImpactFeedback(style: .medium)
                    }
                    .onDisappear {
                        uiState.isNavBarVisible = true
                    }
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.75), value: showTutorial)
        .onAppear(){
            uiState.isNavBarVisible = true
        }
    }

    // Define the destination view based on the selected location
    @ViewBuilder
    private func destinationView() -> some View {
        switch selectedLocation {
        case "Home":
            HomeView()
                .navigationBarBackButtonHidden(true)

        case "School":
            SchoolView()
                .navigationBarBackButtonHidden(true)

        case "Mall":
            MallView()
                .navigationBarBackButtonHidden(true)

        case "Market":
            MarketView()
                .navigationBarBackButtonHidden(true)
            
        case "Zoo":
            ZooView()
                .navigationBarBackButtonHidden(true)

        default:
            EmptyView()
        }
    }
    
    private let constrainFactor: CGFloat = 0.9

//L
    private func minOffsetX() -> CGFloat {
        return min(0, (UIScreen.main.bounds.width - mapSize.width) * 0.85) / 2
    }
//R
    private func maxOffsetX() -> CGFloat {
        return max(0, (mapSize.width - UIScreen.main.bounds.width) * 0.85) / 2
    }
//Up
    private func minOffsetY() -> CGFloat {
        return min(0, (UIScreen.main.bounds.height - mapSize.height) * constrainFactor) / 2
    }
//Down
    private func maxOffsetY() -> CGFloat {
        return max(0, (mapSize.height - UIScreen.main.bounds.height) * constrainFactor) / 2
    }
    func startSwinging() {
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                withAnimation(.easeInOut(duration: 0.5)) {
                    angle = rotateForward ? 5 : -5
                    rotateForward.toggle()
                }
            }
        }
//    private func startFloatingAnimation() {
//            withAnimation(
//                Animation.easeInOut(duration: 2.5)
//                    .repeatForever(autoreverses: true)
//            ) {
//                floatOffset = CGSize(
//                    width: CGFloat.random(in: -10...10),
//                    height: CGFloat.random(in: -10...10)
//                )
//            }
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
//                startFloatingAnimation()
//            }
//        }
}

struct MapButton: View {
    let iconName: String
    let label: String
    let position: CGPoint
//    let BmapOffset: CGSize?
    
    
    @Binding var mapOffset: CGSize  //
    @Binding var currentDragOffset: CGSize  //
    @Binding var floatOffset : CGSize

    let action: () -> Void
    
    @State private var isLongPressed = false
    @State private var isAnimating = false
    @State private var ButtonOffset = CGSize.zero

    var body: some View {
        VStack {
            Image(iconName)
                .resizable()
                .frame(width: 260, height: 260)
            Text(label)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.black)
//                .background(Color.white.opacity(0.78))
        }
//        .position(
//                    x: position.x + mapOffset.width + currentDragOffset.width + floatOffset.width,
//                    y: position.y + mapOffset.height + currentDragOffset.height + floatOffset.height
//                )
        
        .position(x: position.x + mapOffset.width + currentDragOffset.width ,
                  y: position.y + mapOffset.height + currentDragOffset.height)
        .gesture(
            LongPressGesture(minimumDuration: 1) // longpress
                .onChanged { _ in
                    isLongPressed = true
                }
                .onEnded { _ in
                    print("Long-pressed")
                    isLongPressed = false
                }
        )
        .simultaneousGesture(
            DragGesture()
                .onChanged { value in
                    if !isLongPressed {

                        let scaledTranslation = CGSize(
                            width: value.translation.width * 0.75,  // 設定拖動速度
                            height: value.translation.height * 0.75
                        )
                        

                        let proposedOffsetX = mapOffset.width + scaledTranslation.width
                        let proposedOffsetY = mapOffset.height + scaledTranslation.height
                        
                        // 限制
                        currentDragOffset.width = max(min(proposedOffsetX, maxOffsetX()), minOffsetX()) - mapOffset.width
                        currentDragOffset.height = max(min(proposedOffsetY, maxOffsetY()), minOffsetY()) - mapOffset.height
                        

                        print("Dragging: \(scaledTranslation), Current Offset: \(currentDragOffset)")
                    }
                }
                .onEnded { _ in
                    if !isLongPressed {
                        // end renew
                        withAnimation {
                            mapOffset.width += (currentDragOffset.width)
                            mapOffset.height += (currentDragOffset.height)
                            currentDragOffset = .zero
                        }
                    }
                }
        )
//        .onAppear {
//                    startFloatingAnimation()
//                }
        
        .onTapGesture {
            if !isLongPressed {
                action()
            }
        }
        
    }
    
    private let constrainFactor: CGFloat = 0.9
    // 限制偏移
    private func minOffsetX() -> CGFloat {
        return min(0, (UIScreen.main.bounds.width - 640) * 0.85) / 2
    }

    private func maxOffsetX() -> CGFloat {
        return max(0, (640 - UIScreen.main.bounds.width) * 0.85) / 2
    }

    private func minOffsetY() -> CGFloat {
        return min(0, (UIScreen.main.bounds.height - 1904) * constrainFactor) / 2
    }

    private func maxOffsetY() -> CGFloat {
        return max(0, (1904 - UIScreen.main.bounds.height) * constrainFactor) / 2
    }
}
// Example views for navigation


#Preview {
    let uiState = UIState()
    
    return GameMapView()
        .environmentObject(uiState)
}




