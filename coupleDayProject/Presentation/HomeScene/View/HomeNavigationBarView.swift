//
//  HomeTopNaviBarView.swift
//  coupleDayProject
//
//  Created by Kim SungHun on 2023/06/28.
//

import UIKit

protocol HomeNavigationBarDelegate: AnyObject {
	func didSettingBtnTap()
	func didAnniversaryBtnTap()
	func didPlaceBtnTap()
}

final class HomeNavigationBarView: BaseView {
	
	//MARK: - Properties
	
	weak var delegate: HomeNavigationBarDelegate?
	
	//MARK: - Views
	
	let appNameText: UILabel = {
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
	
	private let placeBtn: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.image = UIImage(systemName: "map")
		imageView.tintColor = TrendingConstants.appMainColor
		imageView.contentMode = .center
		return imageView
	}()
	
	private lazy var btnViews: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [placeBtn, anniversaryBtn, settingBtn])
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .horizontal
		stackView.distribution = .equalSpacing
		stackView.spacing = 20
		return stackView
	}()
	
	private lazy var contentView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [appNameText, btnViews])
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .horizontal
		stackView.distribution = .equalSpacing
		return stackView
	}()
	
	//MARK: - Functions
	
	override func setupLayout() {
		self.addSubview(contentView)
		
		NSLayoutConstraint.activate([
			contentView.topAnchor.constraint(equalTo: self.topAnchor),
			contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
			contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
		])
	}
	
	override func setupView() {
		let settingTapGesture = UITapGestureRecognizer(
			target: self,
			action: #selector(settingBtnTap(_:))
		)
		settingBtn.isUserInteractionEnabled = true
		settingBtn.addGestureRecognizer(settingTapGesture)
		let anniversaryTapGesture = UITapGestureRecognizer(
			target: self,
			action: #selector(anniversaryBtnTap(_:))
		)
		anniversaryBtn.isUserInteractionEnabled = true
		anniversaryBtn.addGestureRecognizer(anniversaryTapGesture)
		let datePlaceTapGesture = UITapGestureRecognizer(
			target: self,
			action: #selector(placeBtnTap(_:))
		)
		placeBtn.isUserInteractionEnabled = true
		placeBtn.addGestureRecognizer(datePlaceTapGesture)
	}
}

private extension HomeNavigationBarView {
	@objc func settingBtnTap(_ gesture: UITapGestureRecognizer) {
		delegate?.didSettingBtnTap()

	}
	
	@objc func anniversaryBtnTap(_ gesture: UITapGestureRecognizer) {
		delegate?.didAnniversaryBtnTap()

	}
	
	@objc func placeBtnTap(_ gesture: UITapGestureRecognizer) {
		delegate?.didPlaceBtnTap()
	}
}
