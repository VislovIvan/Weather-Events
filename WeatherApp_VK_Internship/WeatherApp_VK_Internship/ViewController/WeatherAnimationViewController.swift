import UIKit

class WeatherAnimationViewController: UIViewController {
    
    // MARK: - Properties
    
    var imageView: UIImageView?
    
    var gradientLayer: CAGradientLayer?
    
    var weatherType: WeatherType
    
    var fogView: FogView?
    
    var snowView: SnowView?
    
    var rainView: RainView?
    
    var currentWeatherView: UIView?
    
    // MARK: - Initializers
    
    init(weatherType: WeatherType) {
        self.weatherType = weatherType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWeatherAnimationView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupShape()
    }
    
    // MARK: - Setup Methods
    
    func setupWeatherAnimationView() {
        switch weatherType.viewType {
        case .fog:
            setupFogView()
        case .snow:
            setupSnowView()
        case .rain:
            setupRainView()
        default:
            break
        }
    }
    
    private func setupFogView() {
        let fog = FogView(frame: view.bounds)
        fog.alpha = 0
        view.addSubview(fog)
        UIView.animate(withDuration: 2.0, delay: 0.2, options: [], animations: {
            fog.alpha = 1.0
        }, completion: nil)
        fogView = fog
    }
    
    private func setupSnowView() {
        let snow = SnowView(frame: view.bounds)
        snow.alpha = 0
        view.addSubview(snow)
        UIView.animate(withDuration: 2.0, delay: 0.2, options: [], animations: {
            snow.alpha = 1.0
        }, completion: nil)
        snowView = snow
    }
    
    private func setupRainView() {
        let rain = RainView(frame: view.bounds)
        rain.alpha = 0
        view.addSubview(rain)
        UIView.animate(withDuration: 0.8, delay: 0.02, options: [], animations: {
            rain.alpha = 1.0
        }, completion: nil)
        rainView = rain
    }
    
    private func setupShape() {
        gradientLayer?.removeFromSuperlayer()
        
        let layer = CAGradientLayer()
        layer.colors = weatherType.shapeColors.map { $0.cgColor }
        layer.frame = CGRect(x: (view.bounds.width - 220) / 2, y: (view.bounds.height - 220) / 2, width: 220, height: 220)
        
        if let currentView = currentWeatherView {
            view.layer.insertSublayer(layer, above: currentView.layer)
        } else {
            view.layer.addSublayer(layer)
        }
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = layer.bounds
        
        switch weatherType.shapeStyle {
        case .circle:
            shapeLayer.path = UIBezierPath(ovalIn: shapeLayer.bounds).cgPath
        case .square:
            shapeLayer.path = UIBezierPath(rect: shapeLayer.bounds).cgPath
        case .triangle:
            shapeLayer.path = createTrianglePath(in: shapeLayer.bounds)
        case .polygon:
            shapeLayer.path = createPolygonPath(sides: 6, in: shapeLayer.bounds)
        case .none:
            break
        }
        
        layer.mask = shapeLayer
        gradientLayer = layer
    }
    
    // MARK: - Helper Methods
    
    private func createTrianglePath(in bounds: CGRect) -> CGPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.midX, y: bounds.minY))
        path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
        path.addLine(to: CGPoint(x: bounds.minX, y: bounds.maxY))
        path.close()
        return path.cgPath
    }
    
    private func createPolygonPath(sides: Int, in bounds: CGRect) -> CGPath {
        let path = UIBezierPath()
        let radius = bounds.width / 2
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        for i in 0..<sides {
            let angle = CGFloat(i) * (2 * .pi / CGFloat(sides)) - .pi / 2
            let point = CGPoint(x: center.x + radius * cos(angle), y: center.y + radius * sin(angle))
            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.close()
        return path.cgPath
    }
}
