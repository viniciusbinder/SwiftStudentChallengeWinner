import Foundation
import SpriteKit

public class AutumnScene: GameScene {
    
    var emitter: SKEmitterNode!
    var pie: SKLabelNode!
    
    var apples: [Apple] = []
    
    public override func didMove(to view: SKView) {
        ostName = "Angel Share"
        super.didMove(to: view)
        
        nextScene = {
            let scene = WinterScene(fileNamed: "Winter")!
            scene.scaleMode = .aspectFit
            self.view!.presentScene(scene)
            self.removeFromParent()
        }
        
        setupApples()
        setupEmitter()
    }
    
    func setupApples() {
        for i in 1...14 {
            let labelNode = childNode(withName: "apple\(i)") as! SKLabelNode
            let apple = Apple(labelNode: labelNode)
            scene!.addChild(apple)
            apples.append(apple)
        }
    }
    
    func setupEmitter() {
        emitter = SKEmitterNode(fileNamed: "Leaves.sks")!
        emitter.zPosition = 1
        emitter.position = CGPoint(x: size.width/2 + 10, y: size.height/2)
        emitter.targetNode = scene
        camera!.addChild(emitter)
    }
    
    override func startPuzzle() {
        super.startPuzzle()
        
        apples.forEach({ $0.isUserInteractionEnabled = true })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.player?.physicsBody?.isDynamic = false
        }
    }
    
    override func completePuzzle() {
        pie = SKLabelNode(text: "🥧")
        pie.fontSize = 140
        pie.position = .zero
        pie.alpha = 0
        camera!.addChild(pie)
        pie.run(.fadeIn(withDuration: 0.5))
        
        instructions.run(.fadeOut(withDuration: 0.5))
        continueLabel.run(.fadeIn(withDuration: 0.5)) {
            self.longPress.isEnabled = true
        }
        
        player?.physicsBody?.isDynamic = true
        puzzleCompleted = true
    }
    
    override func fadeToEnd() {
        super.fadeToEnd()
        pie.run(.fadeOut(withDuration: 0.5))
    }
    
    public override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if !puzzleCompleted {
            var completed = true
            apples.forEach({
                if !$0.isFallen {
                    completed = false
                }
            })
            if completed {
                puzzleCompleted = true
                completePuzzle()
            }
        }
    }
}
