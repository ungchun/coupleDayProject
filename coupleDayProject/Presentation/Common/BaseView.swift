//
//  BaseView.swift
//  coupleDayProject
//
//  Created by Kim SungHun on 2023/06/26.
//

import UIKit

class BaseView: UIView {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		translatesAutoresizingMaskIntoConstraints = false
		setupLayout()
		setupView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupLayout() { }
	
	func setupView() { }
}
