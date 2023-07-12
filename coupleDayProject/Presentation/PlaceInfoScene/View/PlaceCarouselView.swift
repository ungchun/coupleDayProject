import UIKit

final class PlaceCarouselView: BaseView {
	
	//MARK: - Properties
	
	var progress: Progress?
	var imageUrlArray: Array<String>?
	
	//MARK: - Views
	
	let placeCarouselCollectionView = PlaceCarouselCollectionView()
	
	private lazy var carouselProgressView: UIProgressView = {
		let progressView = UIProgressView()
		progressView.translatesAutoresizingMaskIntoConstraints = false
		progressView.trackTintColor = .gray
		progressView.progressTintColor = .white
		return progressView
	}()
	
	//MARK: - Life Cycle
	
	init(imageUrlArray: Array<String>){
		self.imageUrlArray = imageUrlArray
		self.imageUrlArray!.shuffle()
		imageUrlArray.forEach { value in
			DispatchQueue.global().async {
				CacheImageManger().downloadImageAndCache(urlString: value)
			}
		}
		super.init(frame: CGRect.zero)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//MARK: - Functions
	
	override func setupLayout() {
		self.addSubview(placeCarouselCollectionView)
		self.addSubview(carouselProgressView)
		
		NSLayoutConstraint.activate([
			placeCarouselCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
			placeCarouselCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
			placeCarouselCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			placeCarouselCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
		])
		
		NSLayoutConstraint.activate([
			carouselProgressView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			carouselProgressView.bottomAnchor.constraint(equalTo: placeCarouselCollectionView.bottomAnchor, constant: -20),
			carouselProgressView.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.size.width - 40) * 0.6)
		])
	}
	
	override func setupView() {
		placeCarouselCollectionView._delegate = self
		placeCarouselCollectionView.imageUrlArray = self.imageUrlArray
		placeCarouselCollectionView.reloadData()
		
		configureProgressView()
	}
}

private extension PlaceCarouselView {
	func configureProgressView() {
		guard let imageUrlArray = imageUrlArray else { return }
		carouselProgressView.progress = 0.0
		progress = Progress(totalUnitCount: Int64(imageUrlArray.count))
		progress?.completedUnitCount = 1
		carouselProgressView.setProgress(Float(progress!.fractionCompleted), animated: false)
	}
}

extension PlaceCarouselView: PlaceCarouselCollectionViewDelegate {
	func didProgressViewSetProgress(unitCount: Int) {
		progress?.completedUnitCount = Int64(unitCount)
		carouselProgressView.setProgress(Float(progress!.fractionCompleted), animated: false)
	}
}
