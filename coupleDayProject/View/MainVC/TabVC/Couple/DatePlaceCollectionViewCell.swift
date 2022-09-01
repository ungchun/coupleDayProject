import UIKit
import Kingfisher

final class DatePlaceCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    //
    var datePlaceModel: DatePlace? {
        didSet { bind() }
    }
    
    fileprivate func bind() {
        demoLabel_1.text = datePlaceModel?.placeName
        demoLabel_2.text = datePlaceModel?.shortAddress
        let url = URL(string: (datePlaceModel?.imageUrl.first)!)
        imageView.kf.setImage(with: url)
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
    private var demoLabel_1: UILabel = { // 장소
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "GangwonEduAllLight", size: CommonSize.coupleCellTextBigSize)
        label.text = "장소"
        return label
    }()
    private var demoLabel_2: UILabel = { // 위치
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "GangwonEduAllLight", size: CommonSize.coupleCellTextSmallSize)
        label.text = "위치"
        return label
    }()
    
    private lazy var demoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 6
        return stackView
    }()
    
    // MARK: Life Cycle
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(demoStackView)
        demoStackView.addArrangedSubview(imageView)
        demoStackView.addArrangedSubview(demoLabel_1)
        demoStackView.addArrangedSubview(demoLabel_2)
        
        demoStackView.setCustomSpacing(15, after: imageView)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: CommonSize.coupleCellImageSize),
            imageView.heightAnchor.constraint(equalToConstant: CommonSize.coupleCellImageSize),
            
            demoStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            demoStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
