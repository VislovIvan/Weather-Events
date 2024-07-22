import Foundation
import UIKit

class WeatherViewModel {
    
    // MARK: - Properties
    
    private(set) var weatherTypes: [WeatherType] = []
    
    private var isGradientAnimationActive = false
    
    private var currentActiveWeatherType: String?
    
    // MARK: - Initializer
    
    init() {
        loadMockWeatherData()
    }
    
    // MARK: - Data Loading
    
    private func loadMockWeatherData() {
        weatherTypes = [
            WeatherType(nameKey: "Clear", shapeColors: [UIColor.orange, UIColor.yellow], shapeStyle: .circle, viewType: .clear, backgroundColors: [UIColor(named: "Sky_Blue") ?? .blue, UIColor(named: "Dodger_Blue") ?? .systemBlue]),
            WeatherType(nameKey: "Rain", shapeColors: [UIColor.blue, UIColor.cyan], viewType: .rain, backgroundColors: [UIColor.lightGray, UIColor.darkGray]),
            WeatherType(nameKey: "Fog", shapeColors: [UIColor.lightGray, UIColor.darkGray], viewType: .fog),
            WeatherType(nameKey: "Snow", shapeColors: [UIColor.cyan, UIColor.white], viewType: .snow),
        ]
    }
    
    // MARK: - Weather Types Access
    
    func numberOfWeatherTypes() -> Int {
        return weatherTypes.count
    }
    
    func weatherType(at index: Int) -> WeatherType? {
        guard index >= 0 && index < weatherTypes.count else { return nil }
        return weatherTypes[index]
    }
    
    // MARK: - Animation Handling
    
    func activateGradientAnimation(for type: String) {
        if isGradientAnimationActive && currentActiveWeatherType == type {
            return
        }
        currentActiveWeatherType = type
        isGradientAnimationActive = true
    }
    
    func deactivateGradientAnimation() {
        isGradientAnimationActive = false
    }
    
    func isAnimationActive(for type: String) -> Bool {
        return isGradientAnimationActive && currentActiveWeatherType == type
    }
}
