//
//  Extension.swift
//  trendingProject
//
//  Created by 김성훈 on 2022/06/07.
//

import Foundation
import UIKit

// MARK: UIViewController
extension UIViewController {
    func setupHideKeyboardOnTap() { // outSide touch 하면 inputView dismiss
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }

    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
}

// MARK: Date
extension Date {
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
    var millisecondsSince1970: Int64 {
        Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    var toString: String { // date -> yyyy-MM-dd 형식의 string 으로 변환
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko-KR")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    var toStoryString: String { // date -> yyyy.MM.dd 형식의 string 으로 변환
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko-KR")
        dateFormatter.dateFormat = "yyyy.MM.dd(E)"
        return dateFormatter.string(from: self)
    }
    func adding(_ component: Calendar.Component, value: Int, using calendar: Calendar = .current) -> Date {
        calendar.date(byAdding: component, value: value, to: self)!
    }
}

// MARK: String
extension String {
    var toDate: Date { // yyyy-MM-dd 형식 string -> date 로 변환
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        return dateFormatter.date(from: self)!
    }
}

// MARK: Int
extension Int {
    var toMillisecondsSince1970: Int64 {
        Int64(self * 86400000)
    }
}

// MARK: UIImageView
extension UIImageView {
    func load(url: URL) {
//        let url = URL(string: image.url)
        DispatchQueue.global().async { [weak self] in
            print("before extension")
            if let data = try? Data(contentsOf: url) {
                print("extension \(data)")
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

