import Foundation
import SpriteKit

public class Clover: SKSpriteNode {
    
    var sprite: SKSpriteNode
    
    var isFound = false
    
    init(sprite: SKSpriteNode) {
        self.sprite = sprite
        
        super.init(texture: .none, color: .clear, size: sprite.size)
        
        zPosition = 10
        position = sprite.position
        sprite.scene!.addChild(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        find()
    }
    
    func find() {
        sprite.zPosition = 10
        sprite.run(.rotate(toAngle: 0, duration: 1))
        sprite.run(.move(to: scene!.camera!.position, duration: 1))
        sprite.run(.scale(by: 2.3, duration: 1)) {
            self.sprite.run(.fadeOut(withDuration: 0.3)) {
                self.sprite.removeFromParent()
                self.removeFromParent()
            }
            self.isFound = true
        }
    }
}
