//
//  SettingView.swift
//  coupleDayProject
//
//  Created by Kim SungHun on 2023/06/27.
//

import UIKit

protocol SettingViewDelegate: AnyObject {
	func didCoupleDayTap()
	func didBackgroundImageTap()
	func didBirthDayTap()
	func didDarkModeTap()
}

final class SettingView: BaseView {
	
	//MARK: - Properties
	
	weak var delegate: SettingViewDelegate?
	
	//MARK: - Views
	
	private let coupleDayText: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "커플 날짜"
		label.font = UIFont(name: "GangwonEduAllLight", size: 20)
		return label
	}()
	
	private let backgroundImageText: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "배경 사진"
		label.font = UIFont(name: "GangwonEduAllLight", size: 20)
		return label
	}()
	
	private let birthDayText: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "생일 설정"
		label.font = UIFont(name: "GangwonEduAllLight", size: 20)
		return label
	}()
	
	private let darkModeText: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "화면 설정"
		label.font = UIFont(name: "GangwonEduAllLight", size: 20)
		return label
	}()
	
	private let divider: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.contentMode = .scaleToFill
		view.backgroundColor = UIColor(named: "reversebgColor")
		return view
	}()
	
	private lazy var allContentStackView: UIStackView = {
		let view = UIStackView(
			arrangedSubviews: [coupleDayText, backgroundImageText, birthDayText,
							   divider, darkModeText]
		)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.axis = .vertical
		view.distribution = .fill
		view.alignment = .center
		view.spacing = 50
		return view
	}()
	
	//MARK: - Functions
	
	override func setupLayout() {
		self.addSubview(allContentStackView)
		
		NSLayoutConstraint.activate([
			allContentStackView.topAnchor.constraint(equalTo: self.topAnchor),
			allContentStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
			allContentStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			allContentStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			
			divider.widthAnchor.constraint(equalToConstant: 10),
			divider.heightAnchor.constraint(equalToConstant: 1),
		])
	}
	
	override func setupView() {
		let tapGestureCoupleDayText = UITapGestureRecognizer(
			target: self,
			action: #selector(setCoupleDayTap)
		)
		coupleDayText.isUserInteractionEnabled = true
		coupleDayText.addGestureRecognizer(tapGestureCoupleDayText)
		
		let tapGestureBackgroundImageText = UITapGestureRecognizer(
			target: self,
			action: #selector(setBackgroundImageTap)
		)
		backgroundImageText.isUserInteractionEnabled = true
		backgroundImageText.addGestureRecognizer(tapGestureBackgroundImageText)
		
		let tapGestureBirthDayText = UITapGestureRecognizer(
			target: self,
			action: #selector(setBirthDayTap)
		)
		birthDayText.isUserInteractionEnabled = true
		birthDayText.addGestureRecognizer(tapGestureBirthDayText)
		
		let tapGestureDarkModeText = UITapGestureRecognizer(
			target: self,
			action: #selector(setDarkModeTap)
		)
		darkModeText.isUserInteractionEnabled = true
		darkModeText.addGestureRecognizer(tapGestureDarkModeText)
	}
}

private extension SettingView {
	@objc func setCoupleDayTap() {
		delegate?.didCoupleDayTap()
	}
	
	@objc func setBackgroundImageTap() {
		delegate?.didBackgroundImageTap()
	}
	
	@objc func setBirthDayTap() {
		delegate?.didBirthDayTap()
	}
	
	@objc func setDarkModeTap() {
		delegate?.didDarkModeTap()
	}
}
