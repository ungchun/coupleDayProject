import UIKit
import SnapKit

class CarouselCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    //
    static let reuseIdentifier = String(describing: CarouselCollectionViewCell.self)
    
    // MARK: Views
    //
    var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    // MARK: Life Cylce
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(0)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        
    }
}
