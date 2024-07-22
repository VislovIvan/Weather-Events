import UIKit

// MARK: - ShapeStyle

enum ShapeStyle {
    case circle
    case square
    case triangle
    case polygon
}

// MARK: - WeatherViewType

enum WeatherViewType {
    case clear
    case rain
    case fog
    case snow
}

// MARK: - WeatherType

struct WeatherType {
    var nameKey: String
    var shapeColors: [UIColor]
    var shapeStyle: ShapeStyle?
    var viewType: WeatherViewType
    var backgroundColors: [UIColor]?
    
    var name: String {
        NSLocalizedString(nameKey, comment: "")
    }
}
