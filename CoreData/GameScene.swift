//
//  GameScene.swift
//  Englishot
//
//  Created by 陳姿縈 on 6/11/25.
//

import SwiftUI
import SpriteKit

// 定義遊戲場景
class GameScene: SKScene {
    override func didMove(to view: SKView) {
        // 建立角色節點
        let character = SKSpriteNode(imageNamed: "character")
        character.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(character)
        
        // 定義移動動作
        let moveAction = SKAction.move(to: CGPoint(x: 400, y: 400), duration: 2.0)
        character.run(moveAction)
    }
}

// SwiftUI 介面
struct GGameView: View {
    var scene: SKScene {
        let scene = GameScene(size: CGSize(width: 600, height: 300))
        scene.scaleMode = .fill
        return scene
    }

    var body: some View {
        SpriteView(scene: scene)
            .frame(width: 600, height: 900)
    }
}

// Xcode Preview
struct GGameView_Previews: PreviewProvider {
    static var previews: some View {
        GGameView()
    }
}
