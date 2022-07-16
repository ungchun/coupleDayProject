import UIKit

class AnniversaryTabViewController: UIViewController {
    private let tempText: UILabel = {
       let view = UILabel()
        view.text = "Anniversary"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tempText)
        NSLayoutConstraint.activate([
            tempText.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            tempText.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
}
