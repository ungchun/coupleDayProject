import UIKit

final class PlaceCollectionViewCell: UICollectionViewCell {
	
	//MARK: - Properties
	
	var datePlaceModel: Place? {
		didSet { datePlaceModelBinding() }
	}
	static let reuseIdentifier = String(describing: PlaceCollectionViewCell.self)
	
	//MARK: - Views
	
	var placeImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFill
		imageView.layer.cornerRadius = 10
		imageView.clipsToBounds = true
		return imageView
	}()
	
	private var placeName: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont(name: "GangwonEduAllBold", size: 17)
		label.text = "장소"
		return label
	}()
	
	private var placeShortAddress: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont(name: "GangwonEduAllLight", size: 12)
		label.text = "위치"
		label.textColor = .gray
		return label
	}()
	
	private lazy var _contentView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical
		stackView.spacing = 0
		return stackView
	}()
	
	//MARK: - Life Cycle
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		addSubview(_contentView)
		_contentView.addArrangedSubview(placeImageView)
		_contentView.addArrangedSubview(placeName)
		_contentView.addArrangedSubview(placeShortAddress)
		
		NSLayoutConstraint.activate([
			placeImageView.widthAnchor.constraint(
				equalToConstant: UIScreen.main.bounds.size.width / 2
			),
			placeImageView.heightAnchor.constraint(
				equalToConstant: UIScreen.main.bounds.size.width / 2
			),
		])
		
		NSLayoutConstraint.activate([
			_contentView.topAnchor.constraint(equalTo: self.topAnchor),
			_contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
			_contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			_contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

private extension PlaceCollectionViewCell {
	
	//MARK: - Functions
	
	func datePlaceModelBinding() {
		placeName.text = datePlaceModel?.placeName
		placeShortAddress.text = datePlaceModel?.shortAddress
		guard let imageUrl = datePlaceModel?.imageUrl.first else { return }
		placeImageView.setImage(with: imageUrl)
	}
}
