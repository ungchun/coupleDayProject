import UIKit

class DatePlaceCarouselView: UIView {
    
    // MARK: Properties
    //
    static let cellOneHeight = 300.0
    var progress: Progress?
    var timer: Timer?
    var imageUrlArray: Array<String>?
    
    // MARK: Views
    //
    var carouselCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    private lazy var carouselProgressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.trackTintColor = .gray
        progressView.progressTintColor = .white
        return progressView
    }()
    
    required init(imageUrlArray: Array<String>){
        print("required init")
        self.imageUrlArray = imageUrlArray
        
        super.init(frame: CGRect.zero)
        

        self.addSubview(carouselCollectionView)
        self.addSubview(carouselProgressView)
        
        carouselCollectionView.register(CarouselCollectionViewCell.self, forCellWithReuseIdentifier: CarouselCollectionViewCell.reuseIdentifier)
        carouselCollectionView.dataSource = self
        carouselCollectionView.delegate = self
        
        carouselCollectionView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(0)
        }
        carouselProgressView.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.width.equalTo((UIScreen.main.bounds.size.width - 40) * 0.6)
            make.bottom.equalTo(carouselCollectionView.snp.bottom).offset(-20)
        }
        
        configureProgressView()
        activateTimer()
        
        // colors * 3 기준 index 0에서 중앙 첫번째 index로 옮겨주는 거
        //
        let segmentSize = imageUrlArray.count
        carouselCollectionView.scrollToItem(at: IndexPath(item: segmentSize, section: 0), at: .centeredHorizontally, animated: false)

        
        // Can't call super.init() here because it's a convenience initializer not a desginated initializer
    }

    // MARK: Life Cycle
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        print("override init")
        self.addSubview(carouselCollectionView)
        self.addSubview(carouselProgressView)
        
        carouselCollectionView.register(CarouselCollectionViewCell.self, forCellWithReuseIdentifier: CarouselCollectionViewCell.reuseIdentifier)
        carouselCollectionView.dataSource = self
        carouselCollectionView.delegate = self
        
        carouselCollectionView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(0)
        }
        carouselProgressView.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.width.equalTo((UIScreen.main.bounds.size.width - 40) * 0.6)
            make.bottom.equalTo(carouselCollectionView.snp.bottom).offset(-20)
        }
        
        configureProgressView()
        activateTimer()
        
        // colors * 3 기준 index 0에서 중앙 첫번째 index로 옮겨주는 거
        //
        guard let imageUrlArray = imageUrlArray else { return }
        let segmentSize = imageUrlArray.count
        carouselCollectionView.scrollToItem(at: IndexPath(item: segmentSize, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: functions
    //
    // progress 세팅
    //
    private func configureProgressView() {
        guard let imageUrlArray = imageUrlArray else { return }
        carouselProgressView.progress = 0.0
        progress = Progress(totalUnitCount: Int64(imageUrlArray.count))
        progress?.completedUnitCount = 1
        carouselProgressView.setProgress(Float(progress!.fractionCompleted), animated: false)
    }
    
    // 타이머 초기화
    //
    func invalidateTimer() {
        timer?.invalidate()
    }
    
    // 타이머 세팅
    //
    private func activateTimer() {
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(timerCallBack), userInfo: nil, repeats: true)
    }
    
    // 현재 보이는 content의 IndexPath
    //
    private func visibleCellIndexPath() -> IndexPath {
        return carouselCollectionView.indexPathsForVisibleItems[0]
    }
    
    // 시간지나면 배너 움직이는 매서드
    //
    @objc
    func timerCallBack() {
        var item = visibleCellIndexPath().item
        
        // 제일 끝으로 갔을 때 다시 중간으로 이동시키는 코드
        //
        guard let imageUrlArray = imageUrlArray else { return }
        if item == imageUrlArray.count * 3 - 1 {
            carouselCollectionView.scrollToItem(at: IndexPath(item: imageUrlArray.count * 2 - 1, section: 0), at: .centeredHorizontally, animated: false)
            item = imageUrlArray.count * 2 - 1
        }
        
        item += 1
        
        // 배너형식으로 움직이면서 custome cell 사용하려면 이렇게 안하면 scrollToItem 이거 이상하게 돌아감..
        //
        carouselCollectionView.delegate = self
        carouselCollectionView.reloadData()
        carouselCollectionView.layoutIfNeeded()
        
        carouselCollectionView.scrollToItem(at: IndexPath(item: item, section: 0), at: .centeredHorizontally, animated: true)
        
        let unitCount: Int = item % imageUrlArray.count + 1
        progress?.completedUnitCount = Int64(unitCount)
        carouselProgressView.setProgress(Float(progress!.fractionCompleted), animated: false)
    }
}

// MARK: extension
//
// 맨 처음과 끝에서 드래그하면 그 다음 셀이 보인다 -> 시작이 0이 아니다.
// cell list를 3개를 이어붙여서 시작과 동시에 중간으로 오게 한다.
//
extension DatePlaceCarouselView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let imageUrlArray = imageUrlArray else { return 0 }
        print("imageUrlArray \(imageUrlArray.count)")
        return imageUrlArray.count * 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageUrlString = imageUrlArray![indexPath.item % imageUrlArray!.count]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCollectionViewCell.reuseIdentifier, for: indexPath) as! CarouselCollectionViewCell
        let url = URL(string: (imageUrlString))
        cell.imageView.kf.setImage(with: url)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // cell click
    }
}

extension DatePlaceCarouselView: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        invalidateTimer()
        activateTimer()
        
        // 제일 처음 또는 제일 끝으로 갔을 때 다시 중앙으로 이동시키는 코드
        //
        guard let imageUrlArray = imageUrlArray else { return }
        var item = visibleCellIndexPath().item
        if item == imageUrlArray.count * 3 - 1 {
            item = imageUrlArray.count * 2 - 1
        } else if item == 1 {
            item = imageUrlArray.count + 1
        }
        
        carouselCollectionView.scrollToItem(at: IndexPath(item: item, section: 0), at: .centeredHorizontally, animated: false)
        
        let unitCount: Int = item % imageUrlArray.count + 1
        progress?.completedUnitCount = Int64(unitCount)
        carouselProgressView.setProgress(Float(progress!.fractionCompleted), animated: false)
    }
}

extension DatePlaceCarouselView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: carouselCollectionView.frame.width, height: carouselCollectionView.frame.height)
    }
}

