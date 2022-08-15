import UIKit
import Combine

class ContainerViewController: UIViewController {
    
    // MARK: Properties
    //
    private let containerViewModelCombine = ContainerViewModelCombine()
    var disposalbleBag = Set<AnyCancellable>()
    
    // MARK: Views
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
    private let anniversaryBtn: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "note.text")
        imageView.tintColor = TrendingConstants.appMainColor
        imageView.contentMode = .center
        return imageView
    }()
    
    private lazy var btnStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [anniversaryBtn, setBtn])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        return stackView
    }()
    private lazy var stackView: UIStackView = { // appNameLabel + 버튼
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
    
    // MARK: Functions
    //
    fileprivate func setupView() {
        
        view.backgroundColor = UIColor(named: "bgColor")
        view.addSubview(stackView)
        
        // 버튼 클릭 제스쳐
        //
        let setTapGesture = UITapGestureRecognizer(target: self, action: #selector(setBtnTap(_:)))
        setBtn.isUserInteractionEnabled = true
        setBtn.addGestureRecognizer(setTapGesture)
        let anniversaryTapGesture = UITapGestureRecognizer(target: self, action: #selector(setAnniversaryTap(_:)))
        anniversaryBtn.isUserInteractionEnabled = true
        anniversaryBtn.addGestureRecognizer(anniversaryTapGesture)
        
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
    @objc func setBtnTap(_ gesture: UITapGestureRecognizer) {
        let settingViewController = SettingViewController()
        self.navigationController?.pushViewController(settingViewController, animated: true)
    }
    @objc func setAnniversaryTap(_ gesture: UITapGestureRecognizer) {
        let anniversaryViewController = AnniversaryViewController()
        anniversaryViewController.modalPresentationStyle = .custom
        anniversaryViewController.transitioningDelegate = self
        self.present(anniversaryViewController, animated: true)
    }
}

// 기념일 present 할 때 위에 어느정도 띄워주는 custom modal
//
class PresentationController: UIPresentationController {
    
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

// MARK: Extension
//
extension ContainerViewController: UIViewControllerTransitioningDelegate {
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
