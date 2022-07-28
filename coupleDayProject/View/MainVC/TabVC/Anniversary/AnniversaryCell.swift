import UIKit

class AnniversaryCell: UITableViewCell {
    
    // MARK: UI
    //
    private let demoTextA: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "너랑나랑"
        label.font = UIFont(name: "GangwonEduAllBold", size: 20)
        label.textColor = .white
        return label
    }()
    private let demoTextB: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "D-50"
        label.font = UIFont(name: "GangwonEduAllLight", size: 15)
        label.textColor = .white
        return label
    }()
    private let demoTextC: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2022.07.28"
        label.font = UIFont(name: "GangwonEduAllLight", size: 15)
        label.textColor = .white
        return label
    }()
    private let demoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "coupleImg")!
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    private lazy var rightStackView: UIStackView = { // d-day + date
        let stackView = UIStackView(arrangedSubviews: [demoTextB, demoTextC])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    private lazy var contentStackView: UIStackView = { // 기념일 + rightStackView
        let stackView = UIStackView(arrangedSubviews: [demoTextA, rightStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    // MARK: init
    //
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // UIImageView 그 위에 StackView 올리기
        //
        demoImageView.addSubview(contentStackView)
        contentView.addSubview(demoImageView)
        
        //        demoUIView.bringSubviewToFront(demoImageView)
        
        NSLayoutConstraint.activate([
            demoImageView.heightAnchor.constraint(equalToConstant: 100),
            
            demoImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30),
            demoImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30),
            demoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            demoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            contentStackView.leftAnchor.constraint(equalTo: demoImageView.leftAnchor, constant: 30),
            contentStackView.rightAnchor.constraint(equalTo: demoImageView.rightAnchor, constant: 0),
            contentStackView.bottomAnchor.constraint(equalTo: demoImageView.bottomAnchor),
            contentStackView.topAnchor.constraint(equalTo: demoImageView.topAnchor),
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
