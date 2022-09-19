import UIKit
import Combine
import Kingfisher

final class MainViewController: UIViewController {
    
    // MARK: Properties
    //
    weak var coordinator: MainViewCoordinator?
    
    private let coupleTabViewModel = CoupleTabViewModel()
    private let mainViewModelCombine = MainViewModelCombine()
    private var disposalbleBag = Set<AnyCancellable>()
    
    // MARK: Views
    //
    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "너랑나랑"
        label.font = UIFont(name: "GangwonEduAllLight", size: 20)
        return label
    }()
    private let settingBtn: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "gearshape")
        imageView.tintColor = TrendingConstants.appMainColor
        imageView.contentMode = .center
        return imageView
    }()
    private let anniversaryBtn: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "note.text")
        imageView.tintColor = TrendingConstants.appMainColor
        imageView.contentMode = .center
        return imageView
    }()
    private let datePlaceBtn: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "note.text")
        imageView.tintColor = TrendingConstants.appMainColor
        imageView.contentMode = .center
        return imageView
    }()
    
    private lazy var btnStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [datePlaceBtn, anniversaryBtn, settingBtn])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        return stackView
    }()
    private lazy var allContentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [appNameLabel, btnStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    // MARK: Life Cycle
    //
    override func viewWillAppear(_ animated: Bool) {
        // 상단 NavigationBar 공간 hide -> 안해주면 NavigationBar 크기만큼 자리먹음
        //
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewDidLoad() {
        setUpView()
        
        mainViewModelCombine.receivedCoupleDayData = coupleTabViewModel.beginCoupleDay.value
        self.mainViewModelCombine.$appNameLabelValue.sink { [weak self] updateLabel in
            guard let self = self else { return }
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
    
    // MARK: Functions
    //
    fileprivate func setUpView() {
        
        view.backgroundColor = UIColor(named: "bgColor")
        view.addSubview(allContentStackView)
        
        let settingTapGesture = UITapGestureRecognizer(target: self, action: #selector(settingBtnTap(_:)))
        settingBtn.isUserInteractionEnabled = true
        settingBtn.addGestureRecognizer(settingTapGesture)
        let anniversaryTapGesture = UITapGestureRecognizer(target: self, action: #selector(anniversaryBtnTap(_:)))
        anniversaryBtn.isUserInteractionEnabled = true
        anniversaryBtn.addGestureRecognizer(anniversaryTapGesture)
        let datePlaceTapGesture = UITapGestureRecognizer(target: self, action: #selector(datePlaceTabBtnTap(_:)))
        datePlaceBtn.isUserInteractionEnabled = true
        datePlaceBtn.addGestureRecognizer(datePlaceTapGesture)
        
        NSLayoutConstraint.activate([
            allContentStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            allContentStackView.heightAnchor.constraint(equalToConstant: 50),
            allContentStackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            allContentStackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
        ])
        
        let mainTabManVC = MainTabManViewController(coupleTabViewModel: coupleTabViewModel)
        addChild(mainTabManVC)
        view.addSubview(mainTabManVC.view)
        mainTabManVC.didMove(toParent: self)
        mainTabManVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainTabManVC.view.topAnchor.constraint(equalTo: allContentStackView.bottomAnchor),
            mainTabManVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainTabManVC.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainTabManVC.view.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
    @objc func settingBtnTap(_ gesture: UITapGestureRecognizer) {
        // 설정을 통해 커플날짜랑 배경사진을 바꿔야함 -> 같은 coupleTabViewModel의 데이터 사용해야함 -> coupleTabViewModel 주입
        //
        coordinator?.showSettingView(coupleTabViewModel: coupleTabViewModel)
    }
    @objc func anniversaryBtnTap(_ gesture: UITapGestureRecognizer) {
        let anniversaryViewController = AnniversaryViewController()
        anniversaryViewController.modalPresentationStyle = .custom
        anniversaryViewController.transitioningDelegate = self
        coordinator?.showAnniversaryView(vc: anniversaryViewController)
    }
    @objc func datePlaceTabBtnTap(_ gesture: UITapGestureRecognizer) {
        coordinator?.showDatePlaceTabView()
    }
}

// MARK: Extension
//
extension MainViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

// 기념일 present 할 때 위에 어느정도 띄워주는 custom modal
//
final class PresentationController: UIPresentationController {
    
    let blurEffectView: UIVisualEffectView!
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurEffectView.isUserInteractionEnabled = true
        self.blurEffectView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        CGRect(origin: CGPoint(x: 0, y: self.containerView!.frame.height * 0.15),
               size: CGSize(width: self.containerView!.frame.width, height: self.containerView!.frame.height * 0.85))
    }
    
    override func presentationTransitionWillBegin() {
        self.blurEffectView.alpha = 0
        self.containerView?.addSubview(blurEffectView)
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.alpha = 0.7
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in })
    }
    
    override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.alpha = 0
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.removeFromSuperview()
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView!.roundCorners([.topLeft, .topRight], radius: 22)
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
        blurEffectView.frame = containerView!.bounds
    }
    
    @objc func dismissController(){
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
}
