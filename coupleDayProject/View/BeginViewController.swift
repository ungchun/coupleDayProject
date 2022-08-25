import Foundation
import UIKit

protocol BeginViewControllerDelegate {
    func setBegin()
}

final class BeginViewController: UIViewController {
    
    // MARK: Properties
    //
    weak var coordinator: BeginViewCoordinator?
    var delegate: BeginViewControllerDelegate?
    
    private var handleDateValue = Date()
    private var checkValue = false
    
    // MARK: Views
    //
    private let guideText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "GangwonEduAllLight", size: 20)
        label.sizeToFit() // label 크기를 text에 맞추기
        label.text = "인연의 시작을 알려주세요"
        label.textColor = TrendingConstants.appMainColor
        return label
    }()
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.frame.size = CGSize(width: 0, height: 250)
        
        let calendar = Calendar(identifier: .gregorian)
        let currentDate = Date()
        var components = DateComponents()
        components.calendar = calendar
        
        // datePicker max 날짜 세팅 -> 오늘 날짜 에서
        //
        components.year = -1
        components.month = 12
        let maxDate = calendar.date(byAdding: components, to: currentDate)!
        
        // datePicker min 날짜 세팅 -> 30년 전 까지
        //
        components.year = -31
        let minDate = calendar.date(byAdding: components, to: currentDate)!
        
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        
        return datePicker
    }()
    private let startBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("시작하기", for: .normal)
        btn.titleLabel?.font = UIFont(name: "GangwonEduAllLight", size: 25)
        btn.setTitleColor(UIColor.gray, for: .normal)
        return btn
    }()
    private let divider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        view.backgroundColor = TrendingConstants.appMainColor
        return view
    }()
    private let checkButton: UIButton = { // 0일부터 시작 체크버튼 + 택스트 같이 묶어서 버튼으로 만듬
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("0일부터 시작", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "GangwonEduAllLight", size: 20)
        
        // 0일부터 시작 왼쪽 체크버튼
        //
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: UIImage.SymbolWeight.medium, scale: UIImage.SymbolScale.large)
        let largeImage = UIImage(systemName: "square", withConfiguration: largeConfig)
        button.setImage(largeImage, for: .normal)
        let titleSize = button.titleLabel?.text!.size(withAttributes: [
            NSAttributedString.Key.font: button.titleLabel?.font as Any
        ])
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.tintColor = TrendingConstants.appMainColor
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .bottom
        button.semanticContentAttribute = .forceLeftToRight
        button.imageEdgeInsets = UIEdgeInsets(top:0, left:-10, bottom:0, right:0)
        button.titleEdgeInsets = UIEdgeInsets(top:0, left:10, bottom:0, right:0)
        return button
    }()
    private let coupleBeginDay: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko-KR")
        formatter.dateFormat = "yyyy-MM-dd"
        textField.text = formatter.string(from: Date())
        textField.font = UIFont(name: "GangwonEduAllBold", size: 40)
        return textField
    }()
    private lazy var stackView: UIStackView = { // 전체 UI
        var stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    // MARK: Life Cycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupHideKeyboardOnTap()
        setupView()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        coordinator?.didFinishBeginView()
    }
    
    // MARK: Functions
    //
    fileprivate func setupView() {
        // 날짜 변경 클릭, 0일부터 시작 버튼 클릭, 시작하기 버튼 클릭
        //
        datePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
        checkButton.addTarget(self, action: #selector(checkButtonTap), for: .touchUpInside)
        startBtn.addTarget(self, action: #selector(startBtnTap), for: .touchUpInside)
        
        view.backgroundColor = TrendingConstants.appMainColorAlaph40
        
        coupleBeginDay.inputView = datePicker
        coupleBeginDay.tintColor = .clear
        coupleBeginDay.textAlignment = .center
        guideText.textAlignment = .center
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        stackView.addArrangedSubview(guideText)
        stackView.addArrangedSubview(coupleBeginDay)
        stackView.addArrangedSubview(startBtn)
        stackView.addArrangedSubview(divider)
        stackView.addArrangedSubview(checkButton)
        
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // stackView에서 주는 space 말고도 추가로 spacing 25 추가로 더 주기
        //
        stackView.setCustomSpacing(25, after: coupleBeginDay)
        stackView.setCustomSpacing(25, after: startBtn)
        stackView.setCustomSpacing(25, after: divider)
    }
    @objc func handleDatePicker(_ sender: UIDatePicker) {
        coupleBeginDay.text = sender.date.toString
        handleDateValue = sender.date
    }
    @objc func checkButtonTap() {
        if checkValue {
            checkValue.toggle()
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: UIImage.SymbolWeight.medium, scale: UIImage.SymbolScale.large)
            let largeImage = UIImage(systemName: "square", withConfiguration: largeConfig)
            checkButton.setImage(largeImage, for: .normal)
        } else {
            checkValue.toggle()
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: UIImage.SymbolWeight.medium, scale: UIImage.SymbolScale.large)
            let largeImage = UIImage(systemName: "checkmark.square", withConfiguration: largeConfig)
            checkButton.setImage(largeImage, for: .normal)
        }
    }
    @objc func startBtnTap() {
        let userData = UserModel()
        let imageData = ImageModel()
        
        // 0일부터 시작 체크 or not
        //
        if checkValue {
            userData.beginCoupleDay = Int(handleDateValue.toString.toDate.millisecondsSince1970)
        } else {
            userData.beginCoupleDay = Int(Calendar.current.date(byAdding: .day, value: -1, to: handleDateValue.toString.toDate)!.millisecondsSince1970)
        }
        userData.zeroDayStart = checkValue
        imageData.mainImageData = UIImage(named: "coupleImg")?.jpegData(compressionQuality: 0.5)
        
        // add Realm db init
        //
        RealmManager.shared.writeUserData(userData: userData)
        RealmManager.shared.writeImageData(imageData: imageData)
        
        // BeginViewCoordinator -> AppCoordinator -> ContainerView
        // 델리게이트로 AppCoordinator에 세팅 다 했으니 ContainerView로 이동하라고 알림
        //
        self.delegate?.setBegin()
    }
}
