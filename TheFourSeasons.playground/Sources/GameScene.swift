import Foundation
import SpriteKit
import AVFoundation

public class GameScene: SKScene, UIGestureRecognizerDelegate, SKPhysicsContactDelegate {
    
    let fadeDuration: TimeInterval = 2.5
    
    var player: Player!
    var instructions: SKNode!
    var continueLabel: SKNode!
    var longPress: UILongPressGestureRecognizer!
    var blackScreen: SKSpriteNode!
    var nextScene: (() -> Void)! = nil
    
    var puzzleStarted = false
    var puzzlePoint: CGFloat = 1240
    var puzzleCompleted = false
    var endStarted = false
    var endPoint: CGFloat = 1870
    
    var ostName: String?
    var musicPlayer: AVAudioPlayer!
    
    public override func didMove(to view: SKView) {
        let playerSprite = childNode(withName: "Player") as! SKSpriteNode
        player = Player(sprite: playerSprite, camera: camera!)
        setupControls()
        
        setupLabels()
        physicsWorld.contactDelegate = self
        
        playMusic()
        start()
    }
    
    func setupLabels() {
        let cfURL1 = Bundle.main.url(forResource: "SF-Pro-Rounded-Regular", withExtension: "otf")! as CFURL
        let cfURL2 = Bundle.main.url(forResource: "SF-Pro-Rounded-Semibold", withExtension: "otf")! as CFURL
        CTFontManagerRegisterFontsForURL(cfURL1, CTFontManagerScope.process, nil)
        CTFontManagerRegisterFontsForURL(cfURL2, CTFontManagerScope.process, nil)

        continueLabel = camera!.childNode(withName: "ContinueLabel")
        continueLabel.alpha = 0

        instructions = camera!.childNode(withName: "InstructionLabels")
        instructions.alpha = 0
    }
    
    func setupControls() {
        longPress = UILongPressGestureRecognizer()
        longPress.addTarget(self, action: #selector(walk))
        longPress.delegate = self
        longPress.minimumPressDuration = 0.01
        
        view!.addGestureRecognizer(longPress)
    }
    
    func start() {
        blackScreen = SKSpriteNode(color: .black, size: size)
        blackScreen.zPosition = 20
        camera!.addChild(blackScreen)
        blackScreen.run(.fadeOut(withDuration: fadeDuration))
    }
    
    @objc func walk(sender: UILongPressGestureRecognizer) {
        let touchPosition = sender.location(in: view!)
        
        if sender.state == .ended || sender.state == .cancelled {
            player?.stop()
            return
        }
        
        if touchPosition.x < self.view!.frame.width/2 {
            player?.leftPressed()
        } else {
            player?.rightPressed()
            if puzzleCompleted && continueLabel.alpha != 0 {
                fadeToEnd()
            }
        }
    }
    
    func fadeToEnd() {
        continueLabel.run(.fadeOut(withDuration: 0.3))
    }
    
    func startPuzzle() {
        puzzleStarted = true
        longPress.isEnabled = false
        
        instructions.run(.fadeIn(withDuration: 0.2))
    }
    
    func completePuzzle() {
        puzzleCompleted = true
        
        instructions.run(.fadeOut(withDuration: 0.5))
        continueLabel.run(.fadeIn(withDuration: 0.5)) {
            self.longPress.isEnabled = true
        }
    }
    
    func end() {
        endStarted = true
        longPress.isEnabled = false
        player?.rightPressed()
        musicPlayer.setVolume(0, fadeDuration: fadeDuration)
        blackScreen.run(.fadeIn(withDuration: fadeDuration)) {
            self.nextScene()
        }
    }
    
    func playMusic() {
        guard
            let name = ostName,
            let url = Bundle.main.url(forResource: name, withExtension: "mp3")
            else { return }
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: url)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error: Could not load sound file.")
        }
        
        musicPlayer.numberOfLoops = -1
        musicPlayer.volume = 0
        if musicPlayer.prepareToPlay() {
            musicPlayer.play()
        }
        musicPlayer.setVolume(1, fadeDuration: fadeDuration)
    }
    
    @objc public static override var supportsSecureCoding: Bool {
        // SKNode conforms to NSSecureCoding, so any subclass going
        // through the decoding process must support secure coding
        get {
            return true
        }
    }
    
    public override func update(_ currentTime: TimeInterval) {
        player?.update(currentTime)
        
        if !puzzleStarted && camera!.position.x >= puzzlePoint {
            startPuzzle()
        }
        
        if !endStarted && camera!.position.x >= endPoint {
            end()
        }
    }
}
