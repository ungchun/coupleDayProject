import Photos
import UIKit

import CropViewController
import TOCropViewController

final class SettingViewController: BaseViewController {
	
	//MARK: - Properties
	
	weak var coordinator: SettingViewCoordinator?
	private var coupleTabViewModel: CoupleTabViewModel?
	private let imagePickerController = UIImagePickerController()
	
	//MARK: - Views
	
	private let settingView = SettingView()
	
	//MARK: - Life Cycle
	
	init(coupleTabViewModel: CoupleTabViewModel) {
		super.init(nibName: nil, bundle: nil)
		self.coupleTabViewModel = coupleTabViewModel
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.isNavigationBarHidden = false
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		coordinator?.didFinishSettingView()
	}
	
	//MARK: - Functions
	
	override func setupLayout() {
		view.addSubview(settingView)
		
		NSLayoutConstraint.activate([
			settingView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
			settingView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
		])
	}
	
	override func setupView() {
		settingView.delegate = self
		imagePickerController.delegate = self
		setupBackButton()
	}
}

extension SettingViewController: SettingViewDelegate {
	func didCoupleDayTap() {
		let datePicker = setupCoupleDayDatePicker()
		let dateChooserAlert = setupCoupleDayDateChooserAlert(datePicker)
		present(dateChooserAlert, animated: true, completion: nil)
	}
	
	func didBackgroundImageTap() {
		self.present(imagePickerController, animated: true, completion: nil)
	}
	
	func didBirthDayTap() {
		let datePicker = setupBirthDayDatePicker()
		let dateChooserAlert = setupBirthDayDateChooserAlert(datePicker)
		present(dateChooserAlert, animated: true, completion: nil)
	}
	
	func didDarkModeTap() {
		let alert = UIAlertController(title: .none, message: .none, preferredStyle: .actionSheet)
		let lightMode = setupLightModeAlertAction()
		let darkMode = setupDarkModeAlertAction()
		let cancelAction = UIAlertAction(title: "취소", style: .cancel) {(action) in }
		alert.addAction(lightMode)
		alert.addAction(darkMode)
		alert.addAction(cancelAction)
		present(alert, animated: true, completion: nil)
	}
}

private extension SettingViewController {
	func setupCoupleDayDatePicker() -> UIDatePicker {
		let datePicker = UIDatePicker()
		datePicker.datePickerMode = .date
		datePicker.preferredDatePickerStyle = .wheels
		datePicker.translatesAutoresizingMaskIntoConstraints = false
		datePicker.locale = NSLocale(localeIdentifier: "ko_KO") as Locale
		
		let calendar = Calendar(identifier: .gregorian)
		let currentDate = Date()
		var components = DateComponents()
		
		components.calendar = calendar
		components.year = -1
		components.month = 12
		let maxDate = calendar.date(byAdding: components, to: currentDate)
		components.year = -31
		let minDate = calendar.date(byAdding: components, to: currentDate)
		
		datePicker.minimumDate = minDate
		datePicker.maximumDate = maxDate
		
		return datePicker
	}
	
	func setupCoupleDayDateChooserAlert(_ datePicker : UIDatePicker) -> UIAlertController {
		let dateChooserAlert = UIAlertController(
			title: nil,
			message: nil,
			preferredStyle: .actionSheet
		)
		dateChooserAlert.view.addSubview(datePicker)
		dateChooserAlert.addAction(
			UIAlertAction(
				title: "선택완료",
				style: .default,
				handler: { [self] (action:UIAlertAction!) in
					RealmService.shared.updateBeginCoupleDay(datePicker: datePicker)
					coupleTabViewModel?.updateBeginCoupleDay()
				}
			)
		)
		dateChooserAlert.addAction(
			UIAlertAction(
				title: "취소",
				style: .cancel,
				handler: { (action:UIAlertAction!) in }
			)
		)
		dateChooserAlert.view.addConstraint(
			NSLayoutConstraint(
				item: datePicker,
				attribute: .centerX,
				relatedBy: .equal,
				toItem: dateChooserAlert.view,
				attribute: .centerX,
				multiplier: 1,
				constant: 0
			)
		)
		dateChooserAlert.view.addConstraint(
			NSLayoutConstraint(
				item: datePicker,
				attribute: .centerY,
				relatedBy: .equal,
				toItem: dateChooserAlert.view,
				attribute: .centerY,
				multiplier: 1,
				constant: -50
			)
		)
		let alertContentHeight: NSLayoutConstraint = NSLayoutConstraint(
			item: dateChooserAlert.view!,
			attribute: .height,
			relatedBy: .equal,
			toItem: nil,
			attribute: .notAnAttribute,
			multiplier: 1, constant: 350
		)
		dateChooserAlert.view.addConstraint(alertContentHeight)
		return dateChooserAlert
	}
	
	func setupBirthDayDatePicker() -> UIDatePicker {
		let datePicker = UIDatePicker()
		datePicker.datePickerMode = .date
		datePicker.preferredDatePickerStyle = .wheels
		datePicker.translatesAutoresizingMaskIntoConstraints = false
		datePicker.locale = NSLocale(localeIdentifier: "ko_KO") as Locale
		
		let calendar = Calendar(identifier: .gregorian)
		let currentDate = Date()
		var components = DateComponents()
		
		components.calendar = calendar
		components.year = -1
		components.month = 12
		let maxDate = calendar.date(byAdding: components, to: currentDate)
		components.year = -51
		let minDate = calendar.date(byAdding: components, to: currentDate)
		
		datePicker.minimumDate = minDate
		datePicker.maximumDate = maxDate
		
		return datePicker
	}
	
	func setupBirthDayDateChooserAlert(_ datePicker : UIDatePicker) -> UIAlertController {
		let dateChooserAlert = UIAlertController(
			title: nil,
			message: nil,
			preferredStyle: .actionSheet
		)
		dateChooserAlert.view.addSubview(datePicker)
		dateChooserAlert.addAction(
			UIAlertAction(
				title: "선택완료",
				style: .default,
				handler: { (action:UIAlertAction!) in
					RealmService.shared.updateBirthDay(datePicker: datePicker)
				}
			)
		)
		dateChooserAlert.addAction(
			UIAlertAction(
				title: "취소",
				style: .cancel,
				handler: { (action:UIAlertAction!) in }
			)
		)
		dateChooserAlert.view.addConstraint(
			NSLayoutConstraint(
				item: datePicker,
				attribute: .centerX,
				relatedBy: .equal,
				toItem: dateChooserAlert.view,
				attribute: .centerX,
				multiplier: 1,
				constant: 0
			)
		)
		dateChooserAlert.view.addConstraint(
			NSLayoutConstraint(
				item: datePicker,
				attribute: .centerY,
				relatedBy: .equal,
				toItem: dateChooserAlert.view,
				attribute: .centerY,
				multiplier: 1,
				constant: -50
			)
		)
		let alertContentHeight: NSLayoutConstraint = NSLayoutConstraint(
			item: dateChooserAlert.view!,
			attribute: .height,
			relatedBy: .equal,
			toItem: nil,
			attribute: .notAnAttribute,
			multiplier: 1, constant: 350
		)
		dateChooserAlert.view.addConstraint(alertContentHeight)
		return dateChooserAlert
	}
	
	func setupLightModeAlertAction() -> UIAlertAction{
		let lightMode = UIAlertAction(title: "주간모드", style: .default) {(action) in
			if let window = UIApplication.shared.windows.first {
				if #available(iOS 13.0, *) {
					window.overrideUserInterfaceStyle = .light
					UserDefaultsSetting.isDarkMode = false
					NotificationCenter.default.post(
						name: Notification.Name.darkModeCheck,
						object: nil,
						userInfo: ["darkModeCheck": "lightMode"]
					)
				}
			}
		}
		return lightMode
	}
	
	func setupDarkModeAlertAction() -> UIAlertAction{
		let darkMode = UIAlertAction(title: "야간모드", style: .default) {(action) in
			if let window = UIApplication.shared.windows.first {
				if #available(iOS 13.0, *) {
					window.overrideUserInterfaceStyle = .dark
					UserDefaultsSetting.isDarkMode = true
					NotificationCenter.default.post(
						name: Notification.Name.darkModeCheck,
						object: nil,
						userInfo: ["darkModeCheck": "darkMode"]
					)
				}
			}
		}
		return darkMode
	}
}

extension SettingViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
	func imagePickerController(
		_ picker: UIImagePickerController,
		didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
	) {
		let imageData = info[.editedImage] is UIImage ?
		info[UIImagePickerController.InfoKey.editedImage] :
		info[UIImagePickerController.InfoKey.originalImage]
		self.dismiss(animated: true) {
			self.presentCropViewController(image: imageData as! UIImage)
		}
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		self.dismiss(animated: true, completion: nil)
	}
}

extension SettingViewController: CropViewControllerDelegate {
	func presentCropViewController(image: UIImage) {
		let image: UIImage = image
		let cropViewController = CropViewController(image: image)
		cropViewController.delegate = self
		cropViewController.setAspectRatioPreset(.preset4x3, animated: true) // 4x3 비율 set
		cropViewController.aspectRatioLockEnabled = true // 비율 고정
		cropViewController.aspectRatioPickerButtonHidden = true
		cropViewController.doneButtonTitle = "완료"
		cropViewController.cancelButtonTitle = "취소"
		present(cropViewController, animated: true, completion: nil)
	}
	
	func cropViewController(
		_ cropViewController: CropViewController,
		didCropToImage image: UIImage,
		withRect cropRect: CGRect,
		angle: Int
	) {
		RealmService.shared.updateMainImage(mainImage: image)
		coupleTabViewModel?.updateHomeMainImage()
		dismiss(animated: true, completion: nil)
	}
}
