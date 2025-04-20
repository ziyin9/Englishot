//import SwiftUI
//import ARKit
//import RealityKit
//import Combine
//import AVFoundation
//
//// AR Memory Card representation
//struct ARMemoryCard: Identifiable {
//    let id = UUID()
//    let word: String
//    let image: Data?
//    var isFaceUp = false
//    var isMatched = false
//    var isShowingWord = false  // Whether to show English word
//    var modelEntity: ModelEntity?
//    var position: SIMD3<Float>  // 3D position
//}
//
//// Main AR Memory Game View
//struct ARMemoryGameView: View {
//    @Environment(\.dismiss) var dismiss
//    @EnvironmentObject var gameState: GameState
//    @EnvironmentObject var uiState: UIState
//    @FetchRequest(entity: Word.entity(), sortDescriptors: []) var wordEntities: FetchedResults<Word>
//    
//    // Game state
//    @State private var cards: [ARMemoryCard] = []
//    @State private var selectedCards: [ARMemoryCard] = []
//    @State private var isProcessing = false
//    @State private var matchedPairs = 0
//    @State private var showGameOver = false
//    @State private var showLeaveGameView = false
//    @State private var arViewCreated = false
//    
//    // AR View handling
//    @State private var arView: ARView?
//    @State private var planeDetected = false
//    @State private var anchors: [AnchorEntity] = []
//    
//    var body: some View {
//        ZStack {
//            // AR view container
//            ARViewContainer(
//                arViewCreated: $arViewCreated,
//                planeDetected: $planeDetected,
//                cards: $cards,
//                selectedCards: $selectedCards,
//                isProcessing: $isProcessing,
//                handleCardTap: handleCardTap
//            )
//            .edgesIgnoringSafeArea(.all)
//            
//            // Instruction overlay when plane not detected
//            if !planeDetected {
//                VStack {
//                    Spacer()
//                    Text("Point your device at a flat surface")
//                        .font(.title3)
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(Color.black.opacity(0.7))
//                        .cornerRadius(10)
//                        .padding(.bottom, 50)
//                }
//            }
//            
//            // Game status overlay
//            VStack {
//                HStack {
//                    Button(action: {
//                        showLeaveGameView = true
//                    }) {
//                        Image(systemName: "arrow.left")
//                            .font(.title2)
//                            .foregroundColor(.white)
//                            .padding(12)
//                            .background(Color.blue.opacity(0.8))
//                            .cornerRadius(15)
//                    }
//                    .padding(.leading, 20)
//                    
//                    Spacer()
//                    
//                    Text("Matched: \(matchedPairs)/6")
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .padding(8)
//                        .background(Color.blue.opacity(0.8))
//                        .cornerRadius(10)
//                        .padding(.trailing, 20)
//                }
//                .padding(.top, 20)
//                
//                Spacer()
//            }
//            
//            // Game over overlay
//            if showGameOver {
//                LeaveGameView(
//                    showLeaveGameView: $showGameOver, 
//                    message: "Good Job!", 
//                    button1Title: "Exit", 
//                    button1Action: { dismiss() }, 
//                    button2Title: "Play Again", 
//                    button2Action: { setupGame() }
//                )
//                .transition(.opacity)
//                .zIndex(1)
//            }
//            
//            // Leave game confirmation
//            if showLeaveGameView {
//                LeaveGameView(
//                    showLeaveGameView: $showLeaveGameView,
//                    message: "Are you sure you want to leave?",
//                    button1Title: "Leave Game",
//                    button1Action: {
//                        dismiss()
//                    },
//                    button2Title: "Continue",
//                    button2Action: {
//                        showLeaveGameView = false
//                    }
//                )
//                .transition(.opacity)
//                .zIndex(1)
//            }
//        }
//        .onAppear {
//            setupGame()
//        }
//    }
//    
//    // Initialize the game
//    private func setupGame() {
//        // Randomly select 6 words
//        let randomWords = Array(wordEntities.shuffled().prefix(6))
//        
//        // Create card pairs (word and image)
//        var tempCards: [ARMemoryCard] = []
//        
//        // Calculate positions in a 4x3 grid on a horizontal plane
//        let rowCount = 3
//        let columnCount = 4
//        let spacing: Float = 0.15  // Space between cards
//        let startX: Float = -0.225  // Starting X position
//        let startZ: Float = -0.225  // Starting Z position
//        
//        var index = 0
//        for wordEntity in randomWords {
//            // Add word card
//            let wordPos = SIMD3<Float>(
//                startX + Float(index % columnCount) * spacing,
//                0,
//                startZ + Float(index / columnCount) * spacing
//            )
//            
//            tempCards.append(
//                ARMemoryCard(
//                    word: wordEntity.word ?? "",
//                    image: wordEntity.itemimage,
//                    isShowingWord: true,
//                    position: wordPos
//                )
//            )
//            
//            index += 1
//            
//            // Add image card
//            let imagePos = SIMD3<Float>(
//                startX + Float(index % columnCount) * spacing,
//                0,
//                startZ + Float(index / columnCount) * spacing
//            )
//            
//            tempCards.append(
//                ARMemoryCard(
//                    word: wordEntity.word ?? "",
//                    image: wordEntity.itemimage,
//                    isShowingWord: false,
//                    position: imagePos
//                )
//            )
//            
//            index += 1
//        }
//        
//        // Shuffle the cards
//        cards = tempCards.shuffled()
//        matchedPairs = 0
//        selectedCards = []
//        isProcessing = false
//        showGameOver = false
//    }
//    
//    // Handle card tap
//    private func handleCardTap(_ card: ARMemoryCard) {
//        guard !isProcessing && !card.isMatched && !card.isFaceUp else { return }
//        
//        // Flip the card
//        if let index = cards.firstIndex(where: { $0.id == card.id }) {
//            cards[index].isFaceUp = true
//            selectedCards.append(cards[index])
//            
//            // Provide haptic feedback
//            let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
//            feedbackGenerator.impactOccurred()
//        }
//        
//        // Check if two cards are selected
//        if selectedCards.count == 2 {
//            isProcessing = true
//            checkForMatch()
//        }
//    }
//    
//    // Check if selected cards match
//    private func checkForMatch() {
//        let card1 = selectedCards[0]
//        let card2 = selectedCards[1]
//        
//        if card1.word == card2.word {
//            // Match successful
//            if let index1 = cards.firstIndex(where: { $0.id == card1.id }),
//               let index2 = cards.firstIndex(where: { $0.id == card2.id }) {
//                // Success haptic feedback
//                let generator = UINotificationFeedbackGenerator()
//                generator.notificationOccurred(.success)
//                
//                // Play success sound
//                playSound(filename: "match_success")
//                
//                // Mark cards as matched
//                cards[index1].isMatched = true
//                cards[index2].isMatched = true
//                matchedPairs += 1
//                
//                // Check for game completion
//                if matchedPairs == 6 {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                        // Play celebration sound
//                        playSound(filename: "game_complete")
//                        showGameOver = true
//                    }
//                }
//            }
//        } else {
//            // No match - flip cards back after delay
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                if let index1 = cards.firstIndex(where: { $0.id == card1.id }),
//                   let index2 = cards.firstIndex(where: { $0.id == card2.id }) {
//                    // Error haptic feedback
//                    let generator = UINotificationFeedbackGenerator()
//                    generator.notificationOccurred(.error)
//                    
//                    // Flip cards back
//                    cards[index1].isFaceUp = false
//                    cards[index2].isFaceUp = false
//                }
//            }
//        }
//        
//        // Reset selection state after delay
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            selectedCards = []
//            isProcessing = false
//        }
//    }
//    
//    // Play sound effect
//    private func playSound(filename: String) {
//        guard let url = Bundle.main.url(forResource: filename, withExtension: "mp3") else {
//            print("Could not find sound file: \(filename)")
//            return
//        }
//        
//        do {
//            let player = try AVAudioPlayer(contentsOf: url)
//            player.play()
//        } catch {
//            print("Could not play sound: \(error.localizedDescription)")
//        }
//    }
//}
//
//// AR View Container that bridges SwiftUI and ARKit/RealityKit
//struct ARViewContainer: UIViewRepresentable {
//    @Binding var arViewCreated: Bool
//    @Binding var planeDetected: Bool
//    @Binding var cards: [ARMemoryCard]
//    @Binding var selectedCards: [ARMemoryCard]
//    @Binding var isProcessing: Bool
//    var handleCardTap: (ARMemoryCard) -> Void
//    
//    func makeUIView(context: Context) -> ARView {
//        let arView = ARView(frame: .zero)
//        
//        // Configure AR session
//        let configuration = ARWorldTrackingConfiguration()
//        configuration.planeDetection = [.horizontal]
//        arView.session.run(configuration)
//        
//        // Set up AR session delegate
//        context.coordinator.arView = arView
//        arView.session.delegate = context.coordinator
//        
//        // Add tap gesture recognizer
//        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
//        arView.addGestureRecognizer(tapGesture)
//        
//        return arView
//    }
//    
//    func updateUIView(_ uiView: ARView, context: Context) {
//        if !arViewCreated {
//            arViewCreated = true
//        }
//        
//        // Update card entities when cards change
//        context.coordinator.updateCardEntities(cards: cards)
//    }
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//    
//    // Coordinator to handle AR session events and gestures
//    class Coordinator: NSObject, ARSessionDelegate {
//        var parent: ARViewContainer
//        var arView: ARView?
//        var cardEntities: [UUID: Entity] = [:]
//        var planeAnchor: AnchorEntity?
//        
//        init(_ parent: ARViewContainer) {
//            self.parent = parent
//            super.init()
//        }
//        
//        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
//            for anchor in anchors {
//                if let planeAnchor = anchor as? ARPlaneAnchor, planeAnchor.alignment == .horizontal {
//                    // Horizontal plane detected
//                    DispatchQueue.main.async {
//                        // Create anchor entity for the detected plane
//                        if self.planeAnchor == nil {
//                            self.planeAnchor = AnchorEntity(world: planeAnchor.transform)
//                            self.arView?.scene.addAnchor(self.planeAnchor!)
//                            
//                            // Update planeDetected state
//                            self.parent.planeDetected = true
//                            
//                            // Create card entities once plane is detected
//                            self.updateCardEntities(cards: self.parent.cards)
//                        }
//                    }
//                }
//            }
//        }
//        
//        // Update card entities based on current card state
//        func updateCardEntities(cards: [ARMemoryCard]) {
//            guard let planeAnchor = planeAnchor, let arView = arView else { return }
//            
//            // Remove existing cards that need to be updated
//            for card in cards {
//                if let existingEntity = cardEntities[card.id] {
//                    if card.isFaceUp || card.isMatched {
//                        // Only update if state has changed
//                        existingEntity.removeFromParent()
//                        cardEntities.removeValue(forKey: card.id)
//                    }
//                }
//            }
//            
//            // Add/update cards
//            for card in cards {
//                if cardEntities[card.id] == nil {
//                    // Create new card entity
//                    let cardEntity = createCardEntity(for: card)
//                    planeAnchor.addChild(cardEntity)
//                    cardEntities[card.id] = cardEntity
//                }
//            }
//        }
//        
//        // Create a 3D entity for a card
//        func createCardEntity(for card: ARMemoryCard) -> Entity {
//            // Card dimensions
//            let width: Float = 0.1
//            let height: Float = 0.15
//            let thickness: Float = 0.005
//            
//            // Create parent entity for the card
//            let cardEntity = Entity()
//            
//            // Create card material based on state
//            var material = SimpleMaterial()
//            
//            if card.isFaceUp {
//                // Face-up card shows content
//                if card.isShowingWord {
//                    // Word card - create text
//                    material.color = .init(tint: .white)
//                    
//                    // Add text for word
//                    let textMesh = MeshResource.generateText(
//                        card.word,
//                        extrusionDepth: 0.001,
//                        font: .systemFont(ofSize: 0.03),
//                        containerFrame: CGRect(x: -Double(width/2), y: -Double(height/4), width: Double(width), height: Double(height/2)),
//                        alignment: .center,
//                        lineBreakMode: .byWordWrapping
//                    )
//                    
//                    let textEntity = ModelEntity(mesh: textMesh, materials: [SimpleMaterial(color: .blue, isMetallic: false)])
//                    textEntity.position = [0, 0, thickness/2 + 0.001]
//                    cardEntity.addChild(textEntity)
//                    
//                    // Add ice-themed border
//                    let borderMaterial = SimpleMaterial(color: .init(red: 0.8, green: 0.9, blue: 1.0, alpha: 1.0), isMetallic: true)
//                    let borderMesh = MeshResource.generatePlane(width: width + 0.01, height: height + 0.01, cornerRadius: 0.01)
//                    let borderEntity = ModelEntity(mesh: borderMesh, materials: [borderMaterial])
//                    borderEntity.position = [0, 0, thickness/2 - 0.001]
//                    cardEntity.addChild(borderEntity)
//                    
//                } else if let imageData = card.image, let uiImage = UIImage(data: imageData) {
//                    // Image card - create texture
//                    material.color = .init(tint: .white)
//                    material.tintColor = .white
//                    
//                    // Use a simple plane with material
//                    let cardFaceMesh = MeshResource.generatePlane(width: width - 0.01, height: height - 0.01)
//                    let cardFaceEntity = ModelEntity(mesh: cardFaceMesh, materials: [SimpleMaterial(color: .white, isMetallic: false)])
//                    cardFaceEntity.position = [0, 0, thickness/2 + 0.0005]
//                    
//                    // Create a material descriptor for the image
//                    var materialParams = PhysicallyBasedMaterial()
//                    materialParams.baseColor = PhysicallyBasedMaterial.BaseColor(tint: .white)
//                    
//                    // Add the entity to display the card face
//                    cardEntity.addChild(cardFaceEntity)
//                    
//                    // Add a text label for debugging
//                    let labelMesh = MeshResource.generateText(
//                        "Image Card",
//                        extrusionDepth: 0.001,
//                        font: .systemFont(ofSize: 0.01),
//                        containerFrame: CGRect(x: -Double(width/2), y: Double(height/4) - 0.02, width: Double(width), height: 0.02),
//                        alignment: .center,
//                        lineBreakMode: .byWordWrapping
//                    )
//                    let labelEntity = ModelEntity(mesh: labelMesh, materials: [SimpleMaterial(color: .black, isMetallic: false)])
//                    labelEntity.position = [0, 0, thickness/2 + 0.002]
//                    cardEntity.addChild(labelEntity)
//                }
//            } else {
//                // Face-down card shows back design
//                material.color = .init(tint: .blue)
//                
//                // Add snowflake design to back
//                let snowflakeMaterial = SimpleMaterial(color: .white.withAlphaComponent(0.5), isMetallic: false)
//                let snowflakeMesh = MeshResource.generateText(
//                    "❄",
//                    extrusionDepth: 0.001,
//                    font: .systemFont(ofSize: 0.05),
//                    containerFrame: CGRect(x: -Double(width/2), y: -Double(height/4), width: Double(width), height: Double(height/2)),
//                    alignment: .center,
//                    lineBreakMode: .byWordWrapping
//                )
//                
//                let snowflakeEntity = ModelEntity(mesh: snowflakeMesh, materials: [snowflakeMaterial])
//                snowflakeEntity.position = [0, 0, thickness/2 + 0.001]
//                cardEntity.addChild(snowflakeEntity)
//            }
//            
//            // Highlight matched cards
//            if card.isMatched {
//                material.color = .init(tint: .green.withAlphaComponent(0.3))
//            }
//            
//            // Create card mesh and add to entity
//            let cardMesh = MeshResource.generateBox(width: width, height: height, depth: thickness, cornerRadius: 0.005)
//            let cardModelEntity = ModelEntity(mesh: cardMesh, materials: [material])
//            cardEntity.addChild(cardModelEntity)
//            
//            // Position the card
//            cardEntity.position = card.position
//            
//            return cardEntity
//        }
//        
//        // Handle tap gestures
//        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
//            guard let arView = arView, !parent.isProcessing else { return }
//            
//            // Get tap location
//            let tapLocation = gesture.location(in: arView)
//            
//            // Perform hit test
//            if let hitEntity = arView.entity(at: tapLocation) {
//                // Find if the hit entity matches or is a child of any of our card entities
//                for (cardID, cardEntity) in cardEntities {
//                    if hitEntity == cardEntity || isEntityPartOfCardEntity(hitEntity: hitEntity, cardEntity: cardEntity) {
//                        if let card = parent.cards.first(where: { $0.id == cardID }) {
//                            // Call the parent's tap handler
//                            parent.handleCardTap(card)
//                            break
//                        }
//                    }
//                }
//            }
//        }
//        
//        // Helper method to check if an entity is part of a card entity
//        private func isEntityPartOfCardEntity(hitEntity: Entity, cardEntity: Entity) -> Bool {
//            // Check if hit entity is a child of the card entity
//            var currentParent = hitEntity.parent
//            while let parent = currentParent {
//                if parent == cardEntity {
//                    return true
//                }
//                currentParent = parent.parent
//            }
//            
//            // Check if card entity is a parent/ancestor of the hit entity
//            func isParentOf(parent: Entity, potentialChild: Entity) -> Bool {
//                for child in parent.children {
//                    if child == potentialChild {
//                        return true
//                    }
//                    if isParentOf(parent: child, potentialChild: potentialChild) {
//                        return true
//                    }
//                }
//                return false
//            }
//            
//            return isParentOf(parent: cardEntity, potentialChild: hitEntity)
//        }
//    }
//}
//
//// Preview
//#Preview {
//    ARMemoryGameView()
//        .environmentObject(GameState())
//        .environmentObject(UIState())
//} 
