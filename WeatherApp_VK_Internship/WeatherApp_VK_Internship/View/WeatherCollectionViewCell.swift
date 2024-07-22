import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "WeatherCollectionViewCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper Methods
    
    private func applyShadow(_ shouldApply: Bool) {
        if shouldApply {
            nameLabel.layer.shadowColor = UIColor.black.cgColor
            nameLabel.layer.shadowOffset = CGSize(width: 0.7, height: 0.7)
            nameLabel.layer.shadowOpacity = 0.7
            nameLabel.layer.shadowRadius = 3
        } else {
            nameLabel.layer.shadowColor = nil
            nameLabel.layer.shadowOffset = CGSize.zero
            nameLabel.layer.shadowOpacity = 0
            nameLabel.layer.shadowRadius = 0
        }
    }
    
    // MARK: - Configuration
    
    func configure(with weather: WeatherType, isSelected: Bool) {
        nameLabel.text = weather.name
        nameLabel.textColor = isSelected ? .white : .gray
        applyShadow(isSelected)
    }
}
