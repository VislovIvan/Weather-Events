import UIKit

class FogView: UIView {
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFogLayer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFogLayer()
    }
    
    // MARK: - Setup Methods
    
    private func setupFogLayer() {
        backgroundColor = .clear
        
        let fogLayer = CAEmitterLayer()
        fogLayer.emitterShape = .line
        fogLayer.emitterPosition = CGPoint(x: bounds.width / 2, y: -450)
        fogLayer.emitterSize = CGSize(width: bounds.width, height: 1)
        fogLayer.emitterCells = [createFogCell()]
        layer.addSublayer(fogLayer)
    }
    
    // MARK: - Helper Methods
    
    private func createFogCell() -> CAEmitterCell {
        let fogCell = CAEmitterCell()
        fogCell.contents = UIImage(named: "fog")?.cgImage
        fogCell.scale = 0.2
        fogCell.scaleRange = 0.2
        fogCell.birthRate = 70
        fogCell.lifetime = 50
        fogCell.velocity = 30
        fogCell.velocityRange = 20
        fogCell.yAcceleration = 2
        fogCell.alphaSpeed = -0.05
        fogCell.emissionRange = .pi
        return fogCell
    }
}
