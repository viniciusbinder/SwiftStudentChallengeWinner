import Foundation
import SpriteKit

public class SpringScene: GameScene {
    
    var endLabel: SKNode!
    
    var clovers: [Clover] = []
    
    public override func didMove(to view: SKView) {
        ostName = "Teddy Bear Waltz"
        super.didMove(to: view)
        
        endLabel = camera!.childNode(withName: "EndLabel")
        endLabel.alpha = 0
        endLabel.zPosition = 21
        nextScene = {
            self.endLabel.run(.fadeIn(withDuration: 1))
        }
        
        setupClovers()
    }
    
    func setupClovers() {
        for i in 1...4 {
            let clover = Clover(sprite: childNode(withName: "clover\(i)") as! SKSpriteNode)
            clovers.append(clover)
        }
    }
    
    override func startPuzzle() {
        super.startPuzzle()
        
        clovers.forEach({ $0.isUserInteractionEnabled = true })
    }
    
    public override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if !puzzleCompleted {
            var completed = true
            clovers.forEach({
                if !$0.isFound {
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
