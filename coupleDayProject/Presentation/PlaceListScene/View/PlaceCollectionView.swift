//
//  PlaceCollectionView.swift
//  coupleDayProject
//
//  Created by Kim SungHun on 2023/06/30.
//

import UIKit

protocol PlaceCollectionViewDelegate: AnyObject {
	func didPlaceTap(place: Place)
}

final class PlaceCollectionView: UICollectionView {
	
	//MARK: - Properties
	
	var mainDatePlaceList = [Place]()
	weak var _delegate: PlaceCollectionViewDelegate?
	
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

private extension PlaceCollectionView {
	
	//MARK: - Functions

	func setupLayout() { }
	
	func setupView() {
		translatesAutoresizingMaskIntoConstraints = false
		showsVerticalScrollIndicator = false
		backgroundColor = UIColor(named: "bgColor")
		
		flowLayout.scrollDirection = .vertical
		flowLayout.minimumLineSpacing = 30
		flowLayout.minimumInteritemSpacing = 0
	
		dataSource = self
		delegate = self
		register(
			PlaceCollectionViewCell.self,
			forCellWithReuseIdentifier: PlaceCollectionViewCell.reuseIdentifier
		)
	}
}

extension PlaceCollectionView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(
		_ collectionView: UICollectionView,
		numberOfItemsInSection section: Int
	) -> Int {
		return mainDatePlaceList.count
	}
	
	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(
			withReuseIdentifier: PlaceCollectionViewCell.reuseIdentifier,
			for: indexPath
		)
		if let cell = cell as? PlaceCollectionViewCell {
			cell.placeImageView.image = nil
			cell.datePlaceModel = mainDatePlaceList[indexPath.item]
		}
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		_delegate?.didPlaceTap(place: mainDatePlaceList[indexPath.item])
//		let detailDatePlaceViewController = DetailDatePlaceViewController()
//		detailDatePlaceViewController.datePlace = mainDatePlaceList[indexPath.item]
//		self.navigationController?.pushViewController(detailDatePlaceViewController, animated: true)
	}
	
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		let padding: CGFloat = 60
		let collectionViewSize = self.frame.size.width - padding
		return CGSize(width: collectionViewSize/2, height: collectionViewSize / 2 + 90)
	}
	
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		insetForSectionAt section: Int
	) -> UIEdgeInsets {
		return UIEdgeInsets(top: 30, left: 20, bottom: 20, right: 20)
	}
}
