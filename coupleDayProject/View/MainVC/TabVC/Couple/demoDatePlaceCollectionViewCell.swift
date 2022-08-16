import UIKit
import Kingfisher

class DemoDatePlaceCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    //
    var datePlaceModel: DatePlace? {
        didSet { bind() }
    }
    
    fileprivate func bind() {
        demoLabel_1.text = datePlaceModel?.placeName
        demoLabel_2.text = datePlaceModel?.shortAddress
        let url = URL(string: (datePlaceModel?.imageUrl.first)!)
        demoImageView.kf.setImage(with: url)
    }
    
    // MARK: Views
    //
    private var demoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.sizeToFit()
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
        label.font = UIFont(name: "GangwonEduAllLight", size: 17)
        label.text = "장소"
        return label
    }()
    private var demoLabel_2: UILabel = { // 위치
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "GangwonEduAllLight", size: 16)
        label.text = "위치"
        return label
    }()
    
    private lazy var demoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()
    
    // MARK: Life Cycle
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(demoStackView)
//        demoStackView.addArrangedSubview(emptyView)
        demoStackView.addArrangedSubview(demoImageView)
        demoStackView.addArrangedSubview(demoLabel_1)
        demoStackView.addArrangedSubview(demoLabel_2)
        
        NSLayoutConstraint.activate([
            demoImageView.widthAnchor.constraint(equalToConstant: 120),
            demoImageView.heightAnchor.constraint(equalToConstant: 120),
//            emptyView.widthAnchor.constraint(equalToConstant: 120),
//            emptyView.heightAnchor.constraint(equalToConstant: 120),
            
            demoStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            demoStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
