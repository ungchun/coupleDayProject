import Foundation
import UIKit
import SnapKit

final class OpenMapBottomSheetContentView: UIView {
    
    private lazy var allMapsStackViews: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .green
        stackView.axis = .vertical
        return stackView
    }()
    private let openMapsTitleText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "GangwonEduAllLight", size: 25)
        label.text = "지도 앱 열기"
        label.textColor = .black
        return label
    }()
    private let googleMapsIcon: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        return view
    }()
    private let googleMapsText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "GangwonEduAllLight", size: 15)
        label.text = "구글 맵스"
        label.textColor = .black
        return label
    }()
    private lazy var googleMapsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        return stackView
    }()
    private let kakaoMapsIcon: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .yellow
        return view
    }()
    private let kakaoMapsText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "GangwonEduAllLight", size: 15)
        label.text = "카카오맵"
        label.textColor = .black
        return label
    }()
    private lazy var kakaoMapsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        kakaoMapsStackView.addArrangedSubview(kakaoMapsIcon)
        kakaoMapsStackView.addArrangedSubview(kakaoMapsText)
        
        googleMapsStackView.addArrangedSubview(googleMapsIcon)
        googleMapsStackView.addArrangedSubview(googleMapsText)
        
        allMapsStackViews.addArrangedSubview(openMapsTitleText)
        allMapsStackViews.addArrangedSubview(googleMapsStackView)
        allMapsStackViews.addArrangedSubview(kakaoMapsStackView)
        
        self.addSubview(allMapsStackViews)
        
        googleMapsIcon.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        kakaoMapsIcon.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        kakaoMapsStackView.snp.makeConstraints { make in
            //            make.width.equalTo(500)
            //            make.height.equalTo(100)
        }
        googleMapsStackView.snp.makeConstraints { make in
            //            make.width.equalTo(500)
            //            make.height.equalTo(100)
        }
        allMapsStackViews.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
