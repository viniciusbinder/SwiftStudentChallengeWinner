import Foundation
import SpriteKit

public class Snowball: SKShapeNode {
    
    var placeholder: SKShapeNode!
    var radius: CGFloat!
    
    var isInPlace = false
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, !isInPlace else { return }
        
        position = touch.location(in: scene!)
        
        if placeholder.contains(position) {
            lockInPlace()
        }
    }
    
    private func lockInPlace() {
        isInPlace = true
        position = placeholder.position
        isUserInteractionEnabled = false
    }
    
    func complete() {
        zPosition = -1
        placeholder.zPosition = -2
    }
}
