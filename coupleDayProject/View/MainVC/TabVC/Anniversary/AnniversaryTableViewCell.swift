import UIKit

import Kingfisher

final class AnniversaryTableViewCell: UITableViewCell {
    
    // MARK: Views
    //
    private let anniversaryNameText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "너랑나랑"
        label.font = UIFont(name: "GangwonEduAllBold", size: 25)
        label.textColor = .white
        return label
    }()
    private let anniversaryD_DayText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "D-50"
        label.font = UIFont(name: "GangwonEduAllBold", size: 20)
        label.textColor = .white
        return label
    }()
    private let anniversaryDateText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2022.07.28"
        label.font = UIFont(name: "GangwonEduAllLight", size: 15)
        label.textColor = .lightGray
        return label
    }()
    private let anniversaryBackGroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "coupleImg")!
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    private lazy var D_DayDateStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [anniversaryD_DayText, anniversaryDateText])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .trailing
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()
    private lazy var allContentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [anniversaryNameText, D_DayDateStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    // MARK: Life Cycle
    //
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(
            by: UIEdgeInsets(
                top: 5, left: 0, bottom: 5, right: 0
            )
        )
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        anniversaryBackGroundImage.addSubview(allContentStackView)
        contentView.addSubview(anniversaryBackGroundImage)
        
        NSLayoutConstraint.activate([
            anniversaryBackGroundImage.heightAnchor.constraint(equalToConstant: 100),
            anniversaryBackGroundImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            anniversaryBackGroundImage.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            anniversaryBackGroundImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            anniversaryBackGroundImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            allContentStackView.leftAnchor.constraint(equalTo: anniversaryBackGroundImage.leftAnchor, constant: 30),
            allContentStackView.rightAnchor.constraint(equalTo: anniversaryBackGroundImage.rightAnchor, constant: -30),
            allContentStackView.bottomAnchor.constraint(equalTo: anniversaryBackGroundImage.bottomAnchor),
            allContentStackView.topAnchor.constraint(equalTo: anniversaryBackGroundImage.topAnchor),
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Functions
    //
    func setAnniversaryCellText(dictValue: Dictionary<String, String>, url: String) {
        anniversaryNameText.text = dictValue.values.first!
        let minus = Int(dictValue.keys.first!.toDate.millisecondsSince1970)-Int(Date().millisecondsSince1970)
        let D_DayValue = String(describing: (minus / 86400000)) == "0" ? "DAY" : String(describing: (minus / 86400000))
        anniversaryDateText.text = "\(dictValue.keys.first!.toDate.toAnniversaryString)"
        anniversaryD_DayText.text = "D-\(D_DayValue)"
        
        anniversaryBackGroundImage.setImage(with: url)
    }
}
