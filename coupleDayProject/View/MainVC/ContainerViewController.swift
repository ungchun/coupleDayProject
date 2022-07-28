import UIKit
import Combine

class ContainerViewController: UIViewController {
    
    private let containerViewModelCombine = ContainerViewModelCombine()
    
    var disposalbleBag = Set<AnyCancellable>()
    
    // MARK: UI
    //
    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "너랑나랑"
        label.font = UIFont(name: "GangwonEduAllLight", size: 20)
        return label
    }()
    private let setBtn: UIImageView = { // 설정 버튼
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "gearshape")
        imageView.tintColor = TrendingConstants.appMainColor
        imageView.contentMode = .center
        return imageView
    }()
    private lazy var stackView: UIStackView = { // appNameLabel + 설정 버튼
        let stackView = UIStackView(arrangedSubviews: [appNameLabel, setBtn])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    // MARK: init
    //
    override func viewWillAppear(_ animated: Bool) {
        // 상단 NavigationBar 공간 hide -> 안해주면 NavigationBar 크기만큼 자리먹음
        //
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewDidLoad() {
        setupView()
        
        self.containerViewModelCombine.$appNameLabelValue.sink { updateLabel in
            DispatchQueue.main.async {
                let transition = CATransition()
                transition.duration = 1
                transition.timingFunction = .init(name: .easeIn)
                transition.type = .fade
                self.appNameLabel.layer.add(transition, forKey: CATransitionType.fade.rawValue)
                self.appNameLabel.text = updateLabel
            }
        }.store(in: &disposalbleBag)
    }
    
    // MARK: func
    //
    fileprivate func setupView() {
        
        view.backgroundColor = UIColor(named: "bgColor")
        view.addSubview(stackView)
        
        // 설정 버튼 클릭 제스쳐
        //
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(setBtnTap(_:)))
        setBtn.isUserInteractionEnabled = true
        setBtn.addGestureRecognizer(tapGesture)
        
        // set autolayout
        //
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            stackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            stackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
        ])
        
        // add child tabman
        //
        let mainTabManVC = TabManViewController()
        addChild(mainTabManVC)
        view.addSubview(mainTabManVC.view)
        mainTabManVC.didMove(toParent: self)
        mainTabManVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainTabManVC.view.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            mainTabManVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainTabManVC.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainTabManVC.view.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
    
    // MARK: objc
    //
    @objc
    func setBtnTap(_ gesture: UITapGestureRecognizer) {
        let settingViewController = SettingViewController()
        self.navigationController?.pushViewController(settingViewController, animated: true)
    }
}
