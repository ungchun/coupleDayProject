import UIKit

import SnapKit

class DatePlaceCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    //
    var datePlaceModel: DatePlaceModel? {
        didSet { datePlaceModelBinding() }
    }
    static let reuseIdentifier = String(describing: DatePlaceCollectionViewCell.self)
    
    // MARK: Views
    //
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
    private lazy var allContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
    // MARK: Life Cycle
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(allContentStackView)
        allContentStackView.addArrangedSubview(datePlaceImageView)
        allContentStackView.addArrangedSubview(placeName)
        allContentStackView.addArrangedSubview(placeShortAddress)
        
        NSLayoutConstraint.activate([
            datePlaceImageView.widthAnchor.constraint(
                equalToConstant: UIScreen.main.bounds.size.width / 2
            ),
            datePlaceImageView.heightAnchor.constraint(
                equalToConstant: UIScreen.main.bounds.size.width / 2
            ),
        ])
        
        allContentStackView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(0)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Functions
    //
    private func datePlaceModelBinding() {
        placeName.text = datePlaceModel?.placeName
        placeShortAddress.text = datePlaceModel?.shortAddress
        datePlaceImageView.setImage(with: (datePlaceModel?.imageUrl.first)!)
    }
}
