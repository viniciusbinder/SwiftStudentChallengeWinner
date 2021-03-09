import Foundation
import SpriteKit

public class WinterScene: GameScene {
    
    var emitter: SKEmitterNode!
    var snowballs: [Snowball] = []
    
    public override func didMove(to view: SKView) {
        ostName = "Almost New"
        super.didMove(to: view)
        
        nextScene = {
            let scene = SpringScene(fileNamed: "Spring")!
            scene.scaleMode = .aspectFit
            self.view!.presentScene(scene)
            self.removeFromParent()
        }
        
        setupEmitter()
        
        setupSnowballs()
    }
    
    func setupEmitter() {
        emitter = SKEmitterNode(fileNamed: "Snow.sks")!
        emitter.zPosition = 1
        emitter.position = CGPoint(x: 0, y: size.height/2)
        emitter.targetNode = scene
        camera!.addChild(emitter)
    }
    
    func setupBallPair(radius: CGFloat, placeHeight: CGFloat, ballPosition: CGPoint) {
        
        let placeholder = SKShapeNode(circleOfRadius: radius)
        placeholder.strokeColor = .lightGray
        placeholder.lineWidth = 3
        placeholder.fillColor = .lightGray
        placeholder.position = CGPoint(x: 1570, y: placeHeight)
        placeholder.zPosition = 0
        addChild(placeholder)
        
        let ball = Snowball(circleOfRadius: radius)
        ball.fillColor = .white
        ball.position = ballPosition
        ball.zPosition = 2
        ball.placeholder = placeholder
        ball.radius = radius
        addChild(ball)
        
        snowballs.append(ball)
    }
    
    func setupSnowballs() {
        var radius: CGFloat = 50
        var y: CGFloat = -212 - radius * 1.5
        var ballPosition = CGPoint(x: 772, y: -332)
        setupBallPair(radius: radius, placeHeight: y, ballPosition: ballPosition)
        
        y += radius + 2
        radius -= 8
        ballPosition = CGPoint(x: 1394, y: -316)
        setupBallPair(radius: radius, placeHeight: y, ballPosition: ballPosition)
        
        y += radius + 2
        radius -= 8
        ballPosition = CGPoint(x: 1136, y: -326)
        setupBallPair(radius: radius, placeHeight: y, ballPosition: ballPosition)
    }
    
    override func startPuzzle() {
        super.startPuzzle()
        
        snowballs.forEach({ $0.isUserInteractionEnabled = true })
    }
    
    override func completePuzzle() {
        guard let head = snowballs.last else { return }
        
        snowballs.forEach({ $0.complete() })
        
        let nose = SKLabelNode(text: "🥕")
        nose.setScale(0)
        nose.zRotation = -45
        nose.position.x -= head.radius
        nose.position.y -= head.radius / 3.8
        
        let eyes = SKLabelNode(text: "🕶")
        eyes.setScale(0)
        eyes.position.x -= head.radius / 4
        eyes.position.y -= head.radius / 10
        
        let hat = SKLabelNode(text: "🎩")
        hat.setScale(0)
        hat.zRotation = -120
        hat.position.x += head.radius / 2
        hat.position.y += head.radius / 1.2
        
        head.addChild(hat)
        head.addChild(nose)
        head.addChild(eyes)
        
        nose.run(.scale(to: 1.5, duration: 0.3)) {
            eyes.run(.scale(to: 1.6, duration: 0.3)) {
                hat.run(.scale(to: 1.5, duration: 0.3)) {
                    super.completePuzzle()
                }
            }
        }
    }
    
    public override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if !puzzleCompleted {
            var completed = true
            snowballs.forEach({
                if !$0.isInPlace {
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
