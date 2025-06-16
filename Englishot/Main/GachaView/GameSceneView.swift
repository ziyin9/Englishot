import SwiftUI
import SpriteKit

struct GameSceneView: View {
    @Binding var isPresented: Bool
    var onAnimationComplete: () -> Void
    
    var scene: GameScene {
        let scene = GameScene()
        scene.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scene.scaleMode = .fill
        scene.onContinue = {
            isPresented = false
            onAnimationComplete()
        }
        return scene
    }
    
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()
        }
    }
}
