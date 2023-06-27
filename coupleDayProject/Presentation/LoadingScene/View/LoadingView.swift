//
//  LoadingView.swift
//  coupleDayProject
//
//  Created by Kim SungHun on 2023/06/26.
//

import UIKit

import Lottie

final class LoadingView: BaseView {
	
	//MARK: - Views
	
	let lottieAnimationView: AnimationView = {
		let lottieView = AnimationView(name: "lottieFile")
		lottieView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
		return lottieView
	}()
	
	private let loadingCenterText: UILabel = {
		let label = UILabel()
		label.text = "너랑나랑"
		label.font = UIFont(name: "GangwonEduAllLight", size: 50)
		label.textColor = .white
		return label
	}()
	
	private let loadingContentStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.distribution = .fillEqually
		stackView.alignment = .center
		return stackView
	}()
	
	//MARK: - Functions
	
	override func setupLayout() {
		loadingContentStackView.addArrangedSubview(loadingCenterText)
		loadingContentStackView.addArrangedSubview(lottieAnimationView)
		
		self.addSubview(loadingContentStackView)
		
		NSLayoutConstraint.activate([
			loadingContentStackView.topAnchor.constraint(equalTo: self.topAnchor),
			loadingContentStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
			loadingContentStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			loadingContentStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
		])
	}
	
	override func setupView() {
		guard let loadingCenterLabelText = loadingCenterText.text else { return }
		let attributedStr = NSMutableAttributedString(string: loadingCenterLabelText)
		attributedStr.addAttribute(
			.foregroundColor,
			value: TrendingConstants.appMainColor,
			range: (loadingCenterLabelText as NSString).range(of:"너")
		)
		attributedStr.addAttribute(
			.foregroundColor,
			value: TrendingConstants.appMainColor,
			range: (loadingCenterLabelText as NSString).range(of:"나")
		)
		
		loadingCenterText.attributedText = attributedStr
		
		lottieAnimationView.loopMode = .repeat(2.5)
	}
}
