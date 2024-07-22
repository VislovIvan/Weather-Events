import UIKit

class RainView: UIView {
    
    // MARK: - Layer Class Override
    
    override class var layerClass: AnyClass {
        return CAEmitterLayer.self
    }
    
    // MARK: - Properties
    
    var rainEmitter: CAEmitterLayer? {
        return layer as? CAEmitterLayer
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupRain()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupRain()
    }
    
    // MARK: - Setup Methods
    
    func setupRain() {
        guard let rainEmitter = rainEmitter else {
            print("Initialization of CAEmitterLayer failed")
            return
        }
        
        rainEmitter.emitterShape = .line
        rainEmitter.emitterPosition = CGPoint(x: bounds.midX, y: -440)
        rainEmitter.emitterSize = CGSize(width: bounds.size.width, height: 1)
        
        let raindrop = CAEmitterCell()
        
        if let image = UIImage(named: "raindrop")?.cgImage {
            raindrop.contents = image
        } else {
            print("Failed to load 'raindrop' image")
        }
        
        raindrop.scale = 0.12
        raindrop.scaleRange = 0.02
        raindrop.emissionRange = 0.5
        raindrop.lifetime = 5.0
        raindrop.birthRate = 20
        raindrop.velocity = 300
        raindrop.velocityRange = 50
        raindrop.yAcceleration = 500
        
        rainEmitter.emitterCells = [raindrop]
    }
}
