import UIKit
import Kingfisher

class DatePlaceViewController: UIViewController {
    
    var datePlace: DatePlace?
    
    
    // MARK: Views
    //
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        return view
    }()
    let contentView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let datePlaceName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "GangwonEduAllBold", size: 25)
        return label
    }()
    let datePlaceAddress: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "GangwonEduAllLight", size: 15)
        return label
    }()
    let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let introduceTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "GangwonEduAllBold", size: 25)
        return label
    }()
    let introduceContent: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "GangwonEduAllLight", size: 15)
        label.numberOfLines = 0
        return label
    }()
    
    let mapAddressTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "위치"
        label.font = UIFont(name: "GangwonEduAllBold", size: 25)
        return label
    }()
    let mapAddressContent: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    // MARK: Life Cycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // 초기화
        let url = URL(string: (datePlace?.imageUrl.first)!)
        mainImageView.kf.setImage(with: url)
        
        contentView.addSubview(mainImageView)
        
        datePlaceName.text = datePlace?.placeName
        contentView.addSubview(datePlaceName)
        
        datePlaceAddress.text = datePlace?.shortAddress
        contentView.addSubview(datePlaceAddress)
        
        introduceTitle.text = datePlace!.introduce[0]
        contentView.addSubview(introduceTitle)
        
        let introduceContentValue = NSAttributedString(string: datePlace!.introduce[1]).withLineSpacing(10)
        introduceContent.attributedText = introduceContentValue
        contentView.addSubview(introduceContent)
        
        contentView.addSubview(mapAddressTitle)
        contentView.addSubview(mapAddressContent)
        
        NSLayoutConstraint.activate([
            
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.leftAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.rightAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            
            mainImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            mainImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            mainImageView.heightAnchor.constraint(equalToConstant: 400),
            
            datePlaceName.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 30),
            datePlaceName.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            
            datePlaceAddress.topAnchor.constraint(equalTo: datePlaceName.bottomAnchor, constant: 10),
            datePlaceAddress.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            
            mapAddressTitle.topAnchor.constraint(equalTo: datePlaceAddress.bottomAnchor, constant: 20),
            mapAddressTitle.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            
            mapAddressContent.topAnchor.constraint(equalTo: mapAddressTitle.bottomAnchor, constant: 20),
            mapAddressContent.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            mapAddressContent.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            mapAddressContent.heightAnchor.constraint(equalToConstant: 200),
            
            introduceTitle.topAnchor.constraint(equalTo: mapAddressContent.bottomAnchor, constant: 20),
            introduceTitle.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            
            introduceContent.topAnchor.constraint(equalTo: introduceTitle.bottomAnchor, constant: 10),
            introduceContent.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            introduceContent.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
        ])
        
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        let contentViewHeight = contentView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor, constant: 100)
        contentViewHeight.priority = .defaultLow
        contentViewHeight.isActive = true
        
        self.navigationController?.navigationBar.tintColor = TrendingConstants.appMainColor
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "GangwonEduAllBold", size: 18) as Any], for: .normal)
        self.navigationController?.navigationBar.topItem?.title = "뒤로가기"
        self.view.backgroundColor = UIColor(named: "bgColor")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
}
