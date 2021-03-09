import Foundation
import SpriteKit

public class ViewController: UIViewController {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = SKView()
        let scene = SummerScene(fileNamed: "Summer")!
        scene.scaleMode = .aspectFit
        view.presentScene(scene)
        self.view = view
    }
}
