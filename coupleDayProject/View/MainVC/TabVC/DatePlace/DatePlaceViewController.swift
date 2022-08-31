import UIKit

class DatePlaceViewController: UIViewController {
    
    // MARK: Views
    //
    let testLabel: UILabel = {
        let label = UILabel()
        label.text = "데이트장소"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Life Cycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(testLabel)
        view.backgroundColor = .white
        NSLayoutConstraint.activate([
            testLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        self.navigationController?.navigationBar.tintColor = TrendingConstants.appMainColor
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "GangwonEduAllBold", size: 18) as Any], for: .normal)
        self.navigationController?.navigationBar.topItem?.title = "뒤로가기"
        self.view.backgroundColor = UIColor(named: "bgColor")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
}
