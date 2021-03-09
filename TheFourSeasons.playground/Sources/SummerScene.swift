import Foundation
import SpriteKit

public class SummerScene: GameScene {
    
    var crabs: [Crab] = []
    
    public override func didMove(to view: SKView) {
        ostName = "Glitter Blast"
        super.didMove(to: view)
        
        nextScene = {
            let scene = AutumnScene(fileNamed: "Autumn")!
            scene.scaleMode = .aspectFit
            self.view!.presentScene(scene)
            self.removeFromParent()
        }
        
        setupCrabs()
        setupSea()
    }
    
    func setupCrabs() {
        for i in 1...7 {
            let placeholder = childNode(withName: "crab\(i)") as! SKLabelNode
            let crab = Crab(position: placeholder.position, fontSize: placeholder.fontSize)
            placeholder.removeFromParent()
            scene!.addChild(crab)
            crabs.append(crab)
        }
    }
    
    func setupSea() {
        let displacement: CGFloat = 30
        let down = SKAction.move(by: CGVector(dx: 0, dy: -displacement), duration: 5)
        down.timingMode = .easeInEaseOut
        let up = SKAction.move(by: CGVector(dx: 0, dy: displacement), duration: 5)
        up.timingMode = .easeInEaseOut
        
        let sequence = SKAction.sequence([down, up])
        childNode(withName: "Sea")!.run(.repeatForever(sequence))
    }
    
    override func startPuzzle() {
        super.startPuzzle()
        
        crabs.forEach({
            $0.isUserInteractionEnabled = true
            $0.walk()
        })
    }
    
    public override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if !puzzleCompleted {
            var completed = true
            crabs.forEach({
                if !$0.isCaptured {
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
