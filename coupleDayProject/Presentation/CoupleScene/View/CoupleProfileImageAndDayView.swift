//
//  CoupleProfileImageAndDayView.swift
//  coupleDayProject
//
//  Created by Kim SungHun on 2023/06/29.
//

import UIKit

protocol CoupleProfileImageAndDayViewDelegate: AnyObject {
	func didMyProfileTap()
	func didPartnerProfileTap()
}

final class CoupleProfileImageAndDayView: BaseView {
	
	//MARK: - Properties
	
	weak var delegate: CoupleProfileImageAndDayViewDelegate?
	
	//MARK: - Views
	
	let myProfileImageView: UIImageView = {
		let view = UIImageView()
		view.clipsToBounds = true
		view.isUserInteractionEnabled = true
		return view
	}()
	
	let partnerProfileImageView: UIImageView = {
		let view = UIImageView()
		view.clipsToBounds = true
		view.isUserInteractionEnabled = true
		return view
	}()
	
	private let loveIconAndDayView: UIStackView = {
		let view = UIStackView()
		view.axis = .vertical
		view.alignment = .center
		view.spacing = 5
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private let loveIconView: UIImageView = {
		let view = UIImageView()
		view.image = UIImage(
			systemName: "heart.fill",
			withConfiguration: UIImage.SymbolConfiguration(
				pointSize: 24,
				weight: UIImage.SymbolWeight.light
			)
		)
		view.tintColor = TrendingConstants.appMainColor
		return view
	}()
	
	let dayText: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = ""
		label.font = UIFont(name: "GangwonEduAllLight", size: 25)
		return label
	}()
	
	private let contentView: UIStackView = {
		let view = UIStackView()
		view.axis = .horizontal
		view.alignment = .center
		view.distribution = .equalSpacing
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	//MARK: - Functions
	
	override func setupLayout() {
		self.addSubview(contentView)
		
		loveIconAndDayView.addArrangedSubview(loveIconView)
		loveIconAndDayView.addArrangedSubview(dayText)
		
		contentView.addArrangedSubview(myProfileImageView)
		contentView.addArrangedSubview(loveIconAndDayView)
		contentView.addArrangedSubview(partnerProfileImageView)
		
		NSLayoutConstraint.activate([
			myProfileImageView.widthAnchor.constraint(equalToConstant: CommonSize.coupleProfileSize),
			myProfileImageView.heightAnchor.constraint(equalToConstant: CommonSize.coupleProfileSize),
			
			partnerProfileImageView.widthAnchor.constraint(equalToConstant: CommonSize.coupleProfileSize),
			partnerProfileImageView.heightAnchor.constraint(equalToConstant: CommonSize.coupleProfileSize),
		])
		
		NSLayoutConstraint.activate([
			loveIconView.widthAnchor.constraint(equalToConstant: 30),
			loveIconView.heightAnchor.constraint(equalToConstant: 30),
		])
		
		NSLayoutConstraint.activate([
			contentView.topAnchor.constraint(equalTo: self.topAnchor),
			contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
			contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
		])
	}
	
	override func setupView() {
		let tapGestureMyProfileImageView = UITapGestureRecognizer(
			target: self,
			action: #selector(myProfileTap(_:))
		)
		myProfileImageView.addGestureRecognizer(tapGestureMyProfileImageView)
		myProfileImageView.layer.cornerRadius = CommonSize.coupleProfileSize / 2
		
		let tapGesturePartnerProfileImageView = UITapGestureRecognizer(
			target: self,
			action: #selector(partnerProfileTap(_:))
		)
		partnerProfileImageView.addGestureRecognizer(tapGesturePartnerProfileImageView)
		partnerProfileImageView.layer.cornerRadius = CommonSize.coupleProfileSize / 2
	}
}

private extension CoupleProfileImageAndDayView {
	@objc func myProfileTap(_ gesture: UITapGestureRecognizer) {
		delegate?.didMyProfileTap()
	}
	
	@objc func partnerProfileTap(_ gesture: UITapGestureRecognizer) {
		delegate?.didPartnerProfileTap()
	}
}
