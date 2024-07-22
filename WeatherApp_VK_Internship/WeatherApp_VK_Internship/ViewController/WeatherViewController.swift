import UIKit

class WeatherViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Properties
    
    var collectionView: UICollectionView?
    
    let viewModel = WeatherViewModel()
    
    private var lastSelectedIndexPath: IndexPath?
    
    private var currentWeatherController: WeatherAnimationViewController?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        setupCollectionView()
        selectRandomWeatherEvent()
    }
    
    // MARK: - Setup Methods
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 100)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = .clear
        collectionView?.register(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: WeatherCollectionViewCell.identifier)
        collectionView?.showsHorizontalScrollIndicator = false
        
        if let collectionView = collectionView {
            view.addSubview(collectionView)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
                collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
                collectionView.heightAnchor.constraint(equalToConstant: 100)
            ])
        }
    }
    
    private func selectRandomWeatherEvent() {
        if let index = viewModel.weatherTypes.indices.randomElement() {
            let randomWeatherType = viewModel.weatherTypes[index]
            showWeatherAnimationScene(for: randomWeatherType)
            setupGradientBackground(withColors: randomWeatherType.backgroundColors, for: randomWeatherType.name)
            
            lastSelectedIndexPath = IndexPath(item: index, section: 0)
            collectionView?.selectItem(at: lastSelectedIndexPath, animated: true, scrollPosition: .centeredHorizontally)
            collectionView?.reloadData()
        }
    }
    
    // MARK: - CollectionView DataSource & Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfWeatherTypes()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.identifier, for: indexPath) as? WeatherCollectionViewCell,
              let weatherType = viewModel.weatherType(at: indexPath.row) else {
            return UICollectionViewCell()
        }
        let isSelected = indexPath == lastSelectedIndexPath
        cell.configure(with: weatherType, isSelected: isSelected)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath == lastSelectedIndexPath {
            return
        }
        
        if let weather = viewModel.weatherType(at: indexPath.row) {
            showWeatherAnimationScene(for: weather)
            setupGradientBackground(withColors: weather.backgroundColors, for: weather.name)
        }
        
        if let lastIndexPath = lastSelectedIndexPath, lastIndexPath != indexPath,
           let lastCell = collectionView.cellForItem(at: lastIndexPath) as? WeatherCollectionViewCell,
           let lastWeatherType = viewModel.weatherType(at: lastIndexPath.row) {
            lastCell.configure(with: lastWeatherType, isSelected: false)
        }
        
        if let selectedCell = collectionView.cellForItem(at: indexPath) as? WeatherCollectionViewCell,
           let weatherType = viewModel.weatherType(at: indexPath.row) {
            selectedCell.configure(with: weatherType, isSelected: true)
        }
        
        lastSelectedIndexPath = indexPath
    }
    
    // MARK: - Background Setup
    
    private func setupGradientBackground(withColors colors: [UIColor]?, for weatherTypeName: String) {
        removeGradientBackground()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        let gradientColors = colors ?? [UIColor.black, UIColor.black]
        gradientLayer.colors = gradientColors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        let fadeInAnimation = CABasicAnimation(keyPath: "opacity")
        fadeInAnimation.fromValue = 0
        fadeInAnimation.toValue = 1
        fadeInAnimation.duration = 2.0
        fadeInAnimation.fillMode = .forwards
        fadeInAnimation.isRemovedOnCompletion = false
        gradientLayer.add(fadeInAnimation, forKey: "fadeIn")
    }
    
    private func removeGradientBackground() {
        if let gradientLayer = view.layer.sublayers?.first(where: { $0 is CAGradientLayer }) {
            gradientLayer.removeFromSuperlayer()
        }
    }
    
    // MARK: - Weather Animation
    
    func showWeatherAnimationScene(for weather: WeatherType) {
        if currentWeatherController?.weatherType.name == weather.name {
            return
        }
        
        currentWeatherController?.willMove(toParent: nil)
        currentWeatherController?.view.removeFromSuperview()
        currentWeatherController?.removeFromParent()
        
        let weatherAnimationController = WeatherAnimationViewController(weatherType: weather)
        addChild(weatherAnimationController)
        view.addSubview(weatherAnimationController.view)
        view.sendSubviewToBack(weatherAnimationController.view)
        
        weatherAnimationController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weatherAnimationController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherAnimationController.view.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        weatherAnimationController.view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        weatherAnimationController.view.alpha = 0
        
        UIView.animate(withDuration: 0.3, animations: {
            weatherAnimationController.view.transform = CGAffineTransform.identity
            weatherAnimationController.view.alpha = 1
        })
        
        weatherAnimationController.didMove(toParent: self)
        currentWeatherController = weatherAnimationController
    }
}
