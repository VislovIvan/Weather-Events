import UIKit

class SnowView: UIView {
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSnowLayer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSnowLayer()
    }
    
    // MARK: - Setup Methods
    
    private func setupSnowLayer() {
        backgroundColor = .clear
        
        let snowLayer = CAEmitterLayer()
        snowLayer.emitterShape = .line
        snowLayer.emitterPosition = CGPoint(x: 0, y: -500)
        snowLayer.emitterSize = CGSize(width: bounds.width, height: 1)
        snowLayer.emitterCells = [setupSnow()]
        layer.addSublayer(snowLayer)
    }
    
    // MARK: - Helper Methods
    
    func setupSnow() -> CAEmitterCell {
        let snowflake = CAEmitterCell()
        snowflake.contents = UIImage(named: "snowflake")?.cgImage
        snowflake.scale = 0.16
        snowflake.scaleRange = 0.3
        snowflake.emissionRange = .pi
        snowflake.lifetime = 10
        snowflake.birthRate = 20
        snowflake.velocity = -30
        snowflake.velocityRange = -20
        snowflake.yAcceleration = 30
        snowflake.xAcceleration = 5
        snowflake.spin = -0.2
        snowflake.spinRange = 0.5
        snowflake.alphaRange = 0.5
        snowflake.alphaSpeed = -0.05
        
        return snowflake
    }
}
