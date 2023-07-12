import UIKit

final class PlaceCarouselCollectionViewCell: UICollectionViewCell {
	
	//MARK: - Properties
	
	static let reuseIdentifier = String(describing: PlaceCarouselCollectionViewCell.self)
	
	//MARK: - Views
	
	var imageView: UIImageView = {
		let view = UIImageView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.contentMode = .scaleAspectFill
		return view
	}()
	
	//MARK: - Life Cylce
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		addSubview(imageView)
		
		NSLayoutConstraint.activate([
			imageView.topAnchor.constraint(equalTo: self.topAnchor),
			imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
			imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
		])
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func prepareForReuse() {}
}
