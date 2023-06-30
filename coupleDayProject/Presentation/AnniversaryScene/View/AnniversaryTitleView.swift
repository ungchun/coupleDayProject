//
//  AnniversaryTitleView.swift
//  coupleDayProject
//
//  Created by Kim SungHun on 2023/06/28.
//

import UIKit

final class AnniversaryTitleView: BaseView {
	
	//MARK: - Views
	
	private let anniversaryTitleText: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "커플 기념일"
		label.font = UIFont(name: "GangwonEduAllLight", size: 20)
		return label
	}()
	
	private let contentView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical
		stackView.alignment = .center
		stackView.distribution = .fill
		stackView.isUserInteractionEnabled = true
		return stackView
	}()
	
	//MARK: - Functions
	
	override func setupLayout() {
		self.addSubview(contentView)
		contentView.addArrangedSubview(anniversaryTitleText)
		
		NSLayoutConstraint.activate([
			contentView.topAnchor.constraint(equalTo: self.topAnchor),
			contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
			contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
		])
	}
	
	override func setupView() {
		let tapcloseBtn = UITapGestureRecognizer(target: self, action: #selector(tapClose))
		contentView.addGestureRecognizer(tapcloseBtn)
	}
}

private extension AnniversaryTitleView {
	@objc func tapClose() {
		if let viewController = window?.rootViewController {
			viewController.dismiss(animated: true, completion: nil)
		}
	}
}
