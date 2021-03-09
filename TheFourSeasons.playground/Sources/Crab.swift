import Foundation
import SpriteKit

public class Crab: SKLabelNode {
    
    var isCaptured = false
    
    init(position: CGPoint, fontSize: CGFloat) {
        super.init()
        self.position = position
        self.fontSize = fontSize
        self.text = "🦀"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func walk() {
        let displacement = CGFloat.random(in: 110...150)
        let left = SKAction.move(by: CGVector(dx: -displacement, dy: 0), duration: TimeInterval.random(in: 0.5...1.5))
        let right = SKAction.move(by: CGVector(dx: displacement, dy: 0), duration: TimeInterval.random(in: 0.5...1.5))
        run(.repeatForever(.sequence([left, right])))
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        capture()
    }
    
    func capture() {
        removeAllActions()
        run(.sequence([
            .move(by: CGVector(dx: 0, dy: 20), duration: 0.2),
            .move(by: CGVector(dx: 0, dy: -20), duration: 0.4),
            .fadeOut(withDuration: 0.3)
        ])) {
            self.isCaptured = true
            self.removeFromParent()
        }
    }
    
}
