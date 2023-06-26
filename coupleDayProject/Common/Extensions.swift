import UIKit

import Kingfisher

extension UIViewController {
	///	키보드 내리는 로직 같은데 view.endEditing(true) 이걸로도 대체 가능한걸로 암
	func setupHideKeyboardOnTap() {
		self.view.addGestureRecognizer(self.endEditingRecognizer())
		self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
	}
	
	private func endEditingRecognizer() -> UIGestureRecognizer {
		let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
		tap.cancelsTouchesInView = false
		return tap
	}
}

extension Date {
	init(milliseconds: Int64) {
		self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
	}
	
	var millisecondsSince1970: Int64 {
		Int64((self.timeIntervalSince1970 * 1000.0).rounded())
	}
	
	func adding(_ component: Calendar.Component, value: Int, using calendar: Calendar = .current) -> Date {
		calendar.date(byAdding: component, value: value, to: self)!
	}
	
	/// date -> return string yyyy-MM-dd
	var toString: String {
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "ko-KR")
		dateFormatter.dateFormat = "yyyy-MM-dd"
		return dateFormatter.string(from: self)
	}
	
	/// date -> return string yyyy.MM.dd
	var toStoryString: String {
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "ko-KR")
		dateFormatter.dateFormat = "yyyy.MM.dd(E)"
		return dateFormatter.string(from: self)
	}
	
	/// date -> return string MM/dd
	var toSlashAnniversaryString: String {
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "ko-KR")
		dateFormatter.dateFormat = "MM/dd"
		return dateFormatter.string(from: self)
	}
	
	/// date -> return string MM-dd
	var toMinusAnniversaryString: String {
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "ko-KR")
		dateFormatter.dateFormat = "MM-dd"
		return dateFormatter.string(from: self)
	}
}

extension String {
	
	/// string yyyy-MM-dd -> return date
	var toDate: Date {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
		return dateFormatter.date(from: self)!
	}
}

extension Int {
	var toMillisecondsSince1970: Int64 {
		Int64(self * 86400000)
	}
}

extension UIImageView {
	// Kingfisher 이용 캐시 값 확인하고 setImage
	func setImage(with urlString: String) {
		ImageCache.default.retrieveImage(forKey: urlString, options: nil) { result in
			switch result {
			case .success(let value):
				if let image = value.image { //캐시가 존재하는 경우
					self.image = image
				} else { //캐시가 존재하지 않는 경우
					guard let url = URL(string: urlString) else { return }
					let resource = ImageResource(downloadURL: url, cacheKey: urlString)
					self.kf.indicatorType = .activity
					self.kf.setImage(with: resource, options: [.transition(.fade(1.5)), .forceTransition])
				}
			case .failure(let error):
				print(error)
			}
		}
	}
}

extension UIView {
	
	func fadeIn(duration: TimeInterval = 1.0) {
		UIView.animate(withDuration: duration, animations: {
			self.alpha = 1.0
		})
	}
	
	func fadeOut(duration: TimeInterval = 1.0) {
		UIView.animate(withDuration: duration, animations: {
			self.alpha = 0.0
		})
	}
}

extension NSAttributedString {
	func withLineSpacing(_ spacing: CGFloat) -> NSAttributedString {
		let attributedString = NSMutableAttributedString(attributedString: self)
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.lineBreakMode = .byTruncatingTail
		paragraphStyle.lineSpacing = spacing
		attributedString.addAttribute(.paragraphStyle,
									  value: paragraphStyle,
									  range: NSRange(location: 0, length: string.count))
		return NSAttributedString(attributedString: attributedString)
	}
}

extension Notification.Name {
	static let coupleDay = Notification.Name("coupleDay")
	static let darkModeCheck = Notification.Name("darkModeCheck")
}
