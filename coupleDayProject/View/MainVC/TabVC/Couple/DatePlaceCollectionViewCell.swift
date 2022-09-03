import UIKit
import Kingfisher

final class DatePlaceCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    //
    var datePlaceModel: DatePlace? {
        didSet { bind() }
    }
    
    fileprivate func bind() {
        placeName.text = datePlaceModel?.placeName
        placeShortAddress.text = datePlaceModel?.shortAddress
        imageView.setImage(with: (datePlaceModel?.imageUrl.first)!)
    }
    
    // MARK: Views
    //
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.sizeToFit()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    private var emptyView: UIView = { // 프레임
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .green
        return view
    }()
    private var placeName: UILabel = { // 장소
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "GangwonEduAllLight", size: CommonSize.coupleCellTextBigSize)
        label.text = "장소"
        return label
    }()
    private var placeShortAddress: UILabel = { // 위치
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "GangwonEduAllLight", size: CommonSize.coupleCellTextSmallSize)
        label.text = "위치"
        label.textColor = .gray
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 2
        return stackView
    }()
    
    // MARK: Life Cycle
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(placeName)
        stackView.addArrangedSubview(placeShortAddress)
        
        stackView.setCustomSpacing(15, after: imageView)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: CommonSize.coupleCellImageSize),
            imageView.heightAnchor.constraint(equalToConstant: CommonSize.coupleCellImageSize),
            
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
