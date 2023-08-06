import UIKit

import Kingfisher

final class TodayPlaceCollectionViewCell: UICollectionViewCell {
	
	//MARK: - Properties
	
	var placeModel: Place? {
		didSet { placeModelBinding() }
	}
	
	//MARK: - Views
	
	var datePlaceImageView: UIImageView = {
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
		label.font = UIFont(name: "GangwonEduAllLight", size: CommonSize.coupleCellTextBigSize)
		label.text = "장소"
		return label
	}()
	
	private var placeShortAddress: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont(name: "GangwonEduAllLight", size: CommonSize.coupleCellTextSmallSize)
		label.text = "위치"
		label.textColor = .gray
		return label
	}()
	
	private lazy var _contentView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical
		stackView.spacing = 2
		return stackView
	}()
	
	//MARK: - Life Cycle
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		addSubview(_contentView)
		
		_contentView.addArrangedSubview(datePlaceImageView)
		_contentView.addArrangedSubview(placeName)
		_contentView.addArrangedSubview(placeShortAddress)
		
		_contentView.setCustomSpacing(15, after: datePlaceImageView)
		
		NSLayoutConstraint.activate([
			datePlaceImageView.widthAnchor.constraint(equalToConstant: CommonSize.coupleCellImageSize),
			datePlaceImageView.heightAnchor.constraint(equalToConstant: CommonSize.coupleCellImageSize),
			
			_contentView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			_contentView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

private extension TodayPlaceCollectionViewCell {
	
	//MARK: - Functions
	
	func placeModelBinding() {
		placeName.text = placeModel?.placeName
		placeShortAddress.text = placeModel?.shortAddress
		guard let imageUrl = placeModel?.imageUrl.first else { return }
		datePlaceImageView.setImage(with: imageUrl)
	}
}
