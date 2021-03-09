import Foundation
import SpriteKit

public class Player {
    
    private var sprite: SKSpriteNode!
    private var camera : SKCameraNode
    
    private var walkAnimation: SKAction!
    private var idleTexture: SKTexture!
    
    private var maxSpeed: CGFloat = 200
    private var movingLeft = false
    private var movingRight = false
    
    var physicsBody: SKPhysicsBody? {
        sprite.physicsBody
    }
    
    enum State {
        case Idle
        case Walking
    }
    
    private var state = State.Idle
    
    init(sprite: SKSpriteNode, camera: SKCameraNode) {
        self.sprite = sprite
        self.camera = camera
        
        setupBody()
        setupWalk()
        setupIdle()
    }
    
    private func setupBody() {
        let body = SKPhysicsBody(rectangleOf: sprite.size)
        body.restitution = 0
        body.mass = 0.1
        body.linearDamping = 3
        body.allowsRotation = false
        body.categoryBitMask = 1 << 0
        body.collisionBitMask = 1 << 0
        body.contactTestBitMask = 1 << 1
        sprite.physicsBody = body
    }
    
    private func setupWalk() {
        var frames: [SKTexture] = []
        
        for i in 1...11 {
            let number = String(format: "%02d", i)
            frames.append(SKTexture(imageNamed: "p1_walk\(number)"))
        }
        
        let animation = SKAction.animate(with: frames, timePerFrame: 0.06, resize: true, restore: true)
        walkAnimation = SKAction.repeatForever(animation)
    }
    
    private func setupIdle() {
        idleTexture = SKTexture(imageNamed: "p1_stand")
    }
    
    private func moveLeft() {
        sprite.xScale = -abs(sprite.xScale)
        if let physicsBody = sprite.physicsBody,
            physicsBody.velocity.dx > -maxSpeed {
            physicsBody.applyForce(CGVector(dx: -100, dy: 0))
        }
    }
    
    private func moveRight() {
        sprite.xScale = abs(sprite.xScale)
        if let physicsBody = sprite.physicsBody,
            physicsBody.velocity.dx < maxSpeed {
            physicsBody.applyForce(CGVector(dx: 100, dy: 0))
        }
    }
    
    private func moveCamera() {
        let target = sprite.position.x + CGFloat(300)
        camera.position.x = CGFloat.maximum(0, CGFloat.minimum(target, 8190))
    }
    
    private func setState(_ state: State) {
        guard self.state != state else {
            return
        }
        self.state = state
        
        if state == .Walking {
            sprite.run(walkAnimation)
        } else {
            sprite.removeAllActions()
            sprite.texture = idleTexture
            sprite.size = idleTexture.size()
        }
    }
    
    func update(_ currentTime: TimeInterval) {
        moveCamera()

        if -0.1...0.1 ~= sprite.physicsBody!.velocity.dx {
            setState(.Idle)
        } else {
            setState(.Walking)
        }
        
        if movingLeft {
            moveLeft()
        } else if movingRight {
            moveRight()
        }
    }
    
    func leftPressed() {
        movingLeft = true
    }
    
    func rightPressed() {
        movingRight = true
    }
    
    func stop() {
        movingLeft = false
        movingRight = false
    }
}
