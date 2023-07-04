//
//  SetupView.swift
//  coupleDayProject
//
//  Created by Kim SungHun on 2023/06/26.
//

import UIKit

protocol SetupViewDelegate: AnyObject {
	func didStartBtnTap()
}

final class SetupView: BaseView {
	
	//MARK: - Properties
	
	weak var delegate: SetupViewDelegate?
	private var handleDateValue = Date()
	private var zeroDayStartCheck = false
	
	//MARK: - Views
	
	private let guideText: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont(name: "GangwonEduAllLight", size: 20)
		label.sizeToFit()
		label.text = "인연의 시작을 알려주세요"
		label.textColor = TrendingConstants.appMainColor
		return label
	}()
	
	private let datePicker: UIDatePicker = {
		let datePicker = UIDatePicker()
		datePicker.preferredDatePickerStyle = .wheels
		datePicker.datePickerMode = .date
		datePicker.locale = Locale(identifier: "ko-KR")
		datePicker.frame.size = CGSize(width: 0, height: 250)
		
		let calendar = Calendar(identifier: .gregorian)
		let currentDate = Date()
		var components = DateComponents()
		components.calendar = calendar
		
		// datePicker max 날짜 세팅 -> 오늘 날짜 에서
		components.year = -1
		components.month = 12
		let maxDate = calendar.date(byAdding: components, to: currentDate)
		
		// datePicker min 날짜 세팅 -> 30년 전 까지
		components.year = -31
		let minDate = calendar.date(byAdding: components, to: currentDate)
		
		datePicker.minimumDate = minDate
		datePicker.maximumDate = maxDate
		
		return datePicker
	}()

	private let divider: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.contentMode = .scaleToFill
		view.backgroundColor = TrendingConstants.appMainColor
		return view
	}()
	
	private let checkButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setTitle("0일부터 시작", for: .normal)
		button.setTitleColor(UIColor.black, for: .normal)
		button.titleLabel?.font = UIFont(name: "GangwonEduAllLight", size: 20)
		
		let zeroDayCheckConfig = UIImage.SymbolConfiguration(
			pointSize: 15,
			weight: UIImage.SymbolWeight.medium,
			scale: UIImage.SymbolScale.large
		)
		let zeroDayCheckBox = UIImage(systemName: "square", withConfiguration: zeroDayCheckConfig)
		button.setImage(zeroDayCheckBox, for: .normal)
		let titleSize = button.titleLabel?.text!.size(withAttributes: [
			NSAttributedString.Key.font: button.titleLabel?.font as Any
		])
		button.imageView?.contentMode = .scaleAspectFit
		button.imageView?.tintColor = TrendingConstants.appMainColor
		button.contentHorizontalAlignment = .center
		button.contentVerticalAlignment = .bottom
		button.semanticContentAttribute = .forceLeftToRight
		button.imageEdgeInsets = UIEdgeInsets(top:0, left:-10, bottom:0, right:0)
		button.titleEdgeInsets = UIEdgeInsets(top:0, left:10, bottom:0, right:0)
		return button
	}()
	
	private let coupleBeginDay: UITextField = {
		let textField = UITextField()
		textField.translatesAutoresizingMaskIntoConstraints = false
		let formatter = DateFormatter()
		formatter.locale = Locale(identifier: "ko-KR")
		formatter.dateFormat = "yyyy-MM-dd"
		textField.text = formatter.string(from: Date())
		textField.font = UIFont(name: "GangwonEduAllBold", size: 40)
		return textField
	}()
	
	private lazy var contentView: UIStackView = {
		var stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical
		stackView.spacing = 10
		return stackView
	}()
	
	private let startBtn: UIButton = {
		let btn = UIButton()
		btn.setTitle("시작하기", for: .normal)
		btn.titleLabel?.font = UIFont(name: "GangwonEduAllLight", size: 25)
		btn.setTitleColor(UIColor.gray, for: .normal)
		return btn
	}()
	
	//MARK: - Functions
	
	override func setupLayout() {
		self.addSubview(contentView)
		
		contentView.addArrangedSubview(guideText)
		contentView.addArrangedSubview(coupleBeginDay)
		contentView.addArrangedSubview(startBtn)
		contentView.addArrangedSubview(divider)
		contentView.addArrangedSubview(checkButton)
		
		contentView.setCustomSpacing(25, after: coupleBeginDay)
		contentView.setCustomSpacing(25, after: startBtn)
		contentView.setCustomSpacing(25, after: divider)
		
		NSLayoutConstraint.activate([
			contentView.topAnchor.constraint(equalTo: self.topAnchor),
			contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
			contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
		])
		
		divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
	}
	
	override func setupView() {
		datePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
		checkButton.addTarget(self, action: #selector(checkButtonTap), for: .touchUpInside)
		startBtn.addTarget(self, action: #selector(startBtnTap), for: .touchUpInside)
		
		coupleBeginDay.inputView = datePicker
		coupleBeginDay.tintColor = .clear
		coupleBeginDay.textAlignment = .center
		
		guideText.textAlignment = .center
	}
}

private extension SetupView {
	func setUpCheckBox(_ zeroDayStartCheck: Bool) {
		let zeroDayCheckConfig = UIImage.SymbolConfiguration(
			pointSize: 15,
			weight: UIImage.SymbolWeight.medium,
			scale: UIImage.SymbolScale.large
		)
		let zeroDayCheckBox = UIImage(
			systemName: zeroDayStartCheck ? "square" : "checkmark.square",
			withConfiguration: zeroDayCheckConfig
		)
		checkButton.setImage(zeroDayCheckBox, for: .normal)
	}
	
	@objc func handleDatePicker(_ sender: UIDatePicker) {
		coupleBeginDay.text = sender.date.toString
		handleDateValue = sender.date
	}
	
	@objc func checkButtonTap() {
		setUpCheckBox(zeroDayStartCheck)
		zeroDayStartCheck.toggle()
	}
	
	@objc func startBtnTap() {
		let realmUserModel = RealmUserModel()
		let realmImageModel = RealmImageModel()
		
		if zeroDayStartCheck {
			realmUserModel.beginCoupleDay = Int(
				handleDateValue.toString.toDate.millisecondsSince1970
			)
		} else {
			realmUserModel.beginCoupleDay = Int(
				Calendar.current.date(
					byAdding: .day,
					value: -1,
					to: handleDateValue.toString.toDate
				)!.millisecondsSince1970
			)
		}
		realmUserModel.zeroDayStartCheck = zeroDayStartCheck
		realmImageModel.homeMainImage = UIImage(
			named: "coupleImg"
		)?.jpegData(compressionQuality: 0.5)
		
		initNotBirthDayAnniversaryModel()
		RealmService.shared.writeUserData(userData: realmUserModel)
		RealmService.shared.writeImageData(imageData: realmImageModel)
		
		self.delegate?.didStartBtnTap()
	}
}
