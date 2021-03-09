import Foundation
import SpriteKit

public class Apple: SKSpriteNode {
    
    var isFallen = false
    
    init(labelNode: SKLabelNode) {
        super.init(texture: .none, color: .clear, size: labelNode.frame.size)
        self.position = CGPoint(x: labelNode.position.x, y: labelNode.position.y + size.width / 2)
        zPosition = 10
        
        labelNode.removeFromParent()
        labelNode.position = CGPoint(x: 0, y: -size.width / 2 + 12)
        addChild(labelNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        fall()
    }
    
    func fall() {
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2 - 5)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.run(.fadeOut(withDuration: 0.5)) {
                self.removeFromParent()
            }
            self.isFallen = true
        }
    }
    
}
