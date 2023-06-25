import UIKit

import Kingfisher

final class TodayDatePlaceCollectionViewCell: UICollectionViewCell {
	
	//MARK: - Properties
	
	var datePlaceModel: DatePlaceModel? {
		didSet { datePlaceModelBinding() }
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
	private lazy var allContentStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical
		stackView.spacing = 2
		return stackView
	}()
	
	//MARK: - Life Cycle
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		addSubview(allContentStackView)
		allContentStackView.addArrangedSubview(datePlaceImageView)
		allContentStackView.addArrangedSubview(placeName)
		allContentStackView.addArrangedSubview(placeShortAddress)
		
		allContentStackView.setCustomSpacing(15, after: datePlaceImageView)
		
		NSLayoutConstraint.activate([
			datePlaceImageView.widthAnchor.constraint(equalToConstant: CommonSize.coupleCellImageSize),
			datePlaceImageView.heightAnchor.constraint(equalToConstant: CommonSize.coupleCellImageSize),
			
			allContentStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			allContentStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
		])
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

private extension TodayDatePlaceCollectionViewCell {
	
	//MARK: - Functions
	
	func datePlaceModelBinding() {
		placeName.text = datePlaceModel?.placeName
		placeShortAddress.text = datePlaceModel?.shortAddress
		datePlaceImageView.setImage(with: (datePlaceModel?.imageUrl.first)!)
	}
}