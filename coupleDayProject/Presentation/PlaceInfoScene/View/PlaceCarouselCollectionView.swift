//
//  PlaceCarouselCollectionView.swift
//  coupleDayProject
//
//  Created by Kim SungHun on 2023/06/30.
//

import UIKit

protocol PlaceCarouselCollectionViewDelegate: AnyObject {
	func didProgressViewSetProgress(unitCount: Int)
}

final class PlaceCarouselCollectionView: UICollectionView {
	
	//MARK: - Properties
	
	weak var _delegate: PlaceCarouselCollectionViewDelegate?
	var timer: Timer?
	var imageUrlArray: Array<String>?
	
	//MARK: - Views
	
	private let flowLayout = UICollectionViewFlowLayout()
	
	//MARK: - Life Cycle
	
	override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
		super.init(frame: .null, collectionViewLayout: flowLayout)
		
		setupLayout()
		setupView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

private extension PlaceCarouselCollectionView {
	
	//MARK: - Functions
	
	func setupLayout() { }
	
	func setupView() {
		translatesAutoresizingMaskIntoConstraints = false
		showsHorizontalScrollIndicator = false
		isPagingEnabled = true
		
		flowLayout.scrollDirection = .horizontal
		flowLayout.minimumLineSpacing = 0
		flowLayout.minimumInteritemSpacing = 0
		
		dataSource = self
		delegate = self
		register(
			PlaceCarouselCollectionViewCell.self,
			forCellWithReuseIdentifier: PlaceCarouselCollectionViewCell.reuseIdentifier
		)
		
		activateTimer()
	}
}

extension PlaceCarouselCollectionView: UICollectionViewDataSource {
	func collectionView (
		_ collectionView: UICollectionView,
		numberOfItemsInSection section: Int
	) -> Int {
		guard let imageUrlArray = imageUrlArray else { return 0 }
		return imageUrlArray.count * 3
	}
	
	func collectionView (
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let imageUrlString = imageUrlArray![indexPath.item % imageUrlArray!.count]
		let cell = collectionView.dequeueReusableCell(
			withReuseIdentifier: PlaceCarouselCollectionViewCell.reuseIdentifier,
			for: indexPath
		) as! PlaceCarouselCollectionViewCell
		cell.imageView.setImage(with: imageUrlString)
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
}

extension PlaceCarouselCollectionView: UICollectionViewDelegate {
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		invalidateTimer()
		activateTimer()
		
		guard let imageUrlArray = imageUrlArray else { return }
		var item = visibleCellIndexPath().item
		if item == imageUrlArray.count * 3 - 1 {
			item = imageUrlArray.count * 2 - 1
		} else if item == 1 {
			item = imageUrlArray.count + 1
		}
		
		scrollToItem(
			at: IndexPath(item: item, section: 0),
			at: .centeredHorizontally, animated: false
		)
		
		let unitCount: Int = item % imageUrlArray.count + 1
		
		_delegate?.didProgressViewSetProgress(unitCount: unitCount)
	}
}

extension PlaceCarouselCollectionView: UICollectionViewDelegateFlowLayout {
	func collectionView (
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		return CGSize(
			width: frame.width,
			height: frame.height
		)
	}
}

private extension PlaceCarouselCollectionView {
	func activateTimer() {
		timer = Timer.scheduledTimer(
			timeInterval: 5,
			target: self,
			selector: #selector(timerCallBack),
			userInfo: nil,
			repeats: true
		)
	}
	
	func visibleCellIndexPath() -> IndexPath {
		return indexPathsForVisibleItems[0]
	}
	
	@objc func timerCallBack() {
		var item = visibleCellIndexPath().item
		
		guard let imageUrlArray = imageUrlArray else { return }
		if item == imageUrlArray.count * 3 - 1 {
			scrollToItem(
				at: IndexPath(item: imageUrlArray.count * 2 - 1, section: 0),
				at: .centeredHorizontally, animated: false
			)
			item = imageUrlArray.count * 2 - 1
		}
		
		item += 1
		
		delegate = self
		reloadData()
		layoutIfNeeded()
		
		scrollToItem(
			at: IndexPath(item: item, section: 0),
			at: .centeredHorizontally, animated: true
		)
		
		let unitCount: Int = item % imageUrlArray.count + 1
		
		_delegate?.didProgressViewSetProgress(unitCount: unitCount)
	}
}

extension PlaceCarouselCollectionView {
	func invalidateTimer() {
		timer?.invalidate()
	}
}
