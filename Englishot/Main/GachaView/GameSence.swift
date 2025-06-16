//
//  GameSence.swift
//  Englishot
//
//  Created by 李庭宇 on 2025/6/15.
//

import SpriteKit
import UIKit
import AudioToolbox

class GameScene: SKScene {
    
    var backgroundNode: SKSpriteNode!
    var eggNode: SKSpriteNode!
    var penguinNode: SKSpriteNode!
    var lightEffectNode: SKEffectNode!
    var eggBroken3Node: SKSpriteNode!
    var continueLabel: SKLabelNode!
    
    var tapCount: Int = 0
    var isPenguinAnimationFinished = false
    var clickLabel: SKLabelNode!
    var onContinue: (() -> Void)? = nil

    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        backgroundNode = SKSpriteNode(imageNamed: "snow_background")
        backgroundNode.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        backgroundNode.zPosition = -10
        backgroundNode.size = size
        addChild(backgroundNode)
        
        clickLabel = SKLabelNode(text: "Click!")
        clickLabel.fontSize = 20
        clickLabel.fontColor = .black
//        clickLabel.fontName = "Helvetica-Bold"
        clickLabel.position = CGPoint(x: size.width * 0.5, y: size.height * 0.35)
        addChild(clickLabel)

        let eggPosition = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        
        eggNode = SKSpriteNode(imageNamed: "egg")
        eggNode.position = eggPosition
        eggNode.setScale(0.2)
        addChild(eggNode)
        
        penguinNode = SKSpriteNode(imageNamed: "penguin")
        penguinNode.position = eggPosition
        penguinNode.setScale(0.0)
        addChild(penguinNode)
        
        lightEffectNode = createGlowNode(position: eggPosition, radius: 60, blurAmount: 20)
        addChild(lightEffectNode)
        
        eggBroken3Node = SKSpriteNode(imageNamed: "egg_broken3")
        eggBroken3Node.position = eggPosition
        eggBroken3Node.zPosition = 0
        eggBroken3Node.alpha = 0
        eggBroken3Node.setScale(0.2)
        addChild(eggBroken3Node)
        
        continueLabel = SKLabelNode(text: "click to continue")
        continueLabel.fontSize = 15
        continueLabel.fontColor = .black
        continueLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.1)
        continueLabel.alpha = 0
        addChild(continueLabel)
    }
    
    func createGlowNode(position: CGPoint, radius: CGFloat, blurAmount: CGFloat) -> SKEffectNode {
        let shape = SKShapeNode(circleOfRadius: radius)
        shape.fillColor = UIColor.white
        shape.strokeColor = .clear
        
        let effect = SKEffectNode()
        effect.shouldRasterize = true
        effect.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius": blurAmount])
        effect.addChild(shape)
        effect.position = position
        effect.zPosition = -1
        effect.alpha = 0
        effect.setScale(0.1)
        effect.blendMode = .screen
        return effect
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isPenguinAnimationFinished {
            onContinue?()
            return
        }
        
        if tapCount < 3 {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }
        
        tapCount += 1
        
        if tapCount == 1 {
            showBroken1()
        } else if tapCount == 2 {
            showBroken2()
        } else if tapCount == 3 {
            hatchEgg()
        }
    }
    
    func showBroken1() {
        eggNode.texture = SKTexture(imageNamed: "egg_broken1")
        playShake()
    }
    
    func showBroken2() {
        let shakeAction = playShakeAction()
        let changeTexture = SKAction.run { [weak self] in
            self?.eggNode.texture = SKTexture(imageNamed: "egg_broken2")
        }
        let sequence = SKAction.sequence([shakeAction, changeTexture])
        eggNode.run(sequence)
        let hideClickLabel = SKAction.fadeOut(withDuration: 0.3)
        clickLabel.run(hideClickLabel)
    }

    func hatchEgg() {
        let disappear = SKAction.run { [weak self] in
            self?.eggNode.alpha = 0
        }

        let showBroken3 = SKAction.run { [weak self] in
            self?.eggBroken3Node.alpha = 1.0
        }
        
        let wait = SKAction.wait(forDuration: 0.5)
        let startLight = SKAction.run { [weak self] in self?.showLightEffect() }
        
        let sequence = SKAction.sequence([disappear, showBroken3, wait, startLight])
        eggNode.run(sequence)
    }
    
    func playShake() {
        eggNode.run(playShakeAction())
    }
    
    func playShakeAction() -> SKAction {
        let shakeLeft = SKAction.rotate(byAngle: .pi/16, duration: 0.1)
        let shakeRight = SKAction.rotate(byAngle: -.pi/16, duration: 0.1)
        return SKAction.sequence([shakeLeft, shakeRight, shakeLeft, shakeRight])
    }
    
    func showLightEffect() {
        penguinNode.alpha = 0
        eggBroken3Node.run(SKAction.fadeOut(withDuration: 0.5))
        
        let lightFadeIn = SKAction.fadeIn(withDuration: 1.0)
        let initialScale = SKAction.scale(to: 0.8, duration: 1.0)
        let fadeInAndInitialScale = SKAction.group([lightFadeIn, initialScale])
        let expand = SKAction.scale(to: 5.0, duration: 1.5)
        
        let sequence = SKAction.sequence([
            fadeInAndInitialScale,
            expand,
            SKAction.run { [weak self] in
                self?.showPenguin()
            }
        ])
        
        lightEffectNode.run(sequence)
    }

    func showPenguin() {
        penguinNode.zPosition = -0.5
        penguinNode.setScale(0.3)
        penguinNode.alpha = 1.0

        var penguinFrames: [SKTexture] = []
        for i in 1...16 {
            let textureName = String(format: "penguin_frame_%02d", i)
            let texture = SKTexture(imageNamed: textureName)
            penguinFrames.append(texture)
        }

        let animation = SKAction.animate(with: penguinFrames, timePerFrame: 2.0 / 16.0)
        let repeatAnimation = SKAction.repeatForever(animation)
        penguinNode.run(repeatAnimation)
        
        let wait = SKAction.wait(forDuration: 2.0)
        let enableContinue = SKAction.run { [weak self] in
            self?.isPenguinAnimationFinished = true
            self?.continueLabel.run(SKAction.fadeIn(withDuration: 0.5))
        }
        run(SKAction.sequence([wait, enableContinue]))
    }
    
    func restartScene() {
        tapCount = 0
        isPenguinAnimationFinished = false
        
        eggNode.alpha = 1
        eggNode.texture = SKTexture(imageNamed: "egg")
        
        eggBroken3Node.alpha = 0
        penguinNode.removeAllActions()
        penguinNode.setScale(0)
        penguinNode.alpha = 0
        
        lightEffectNode.removeAllActions()
        lightEffectNode.alpha = 0
        lightEffectNode.setScale(0.1)
        
        continueLabel.alpha = 0
    }
}
