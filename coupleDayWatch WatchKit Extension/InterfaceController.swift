//
//  InterfaceController.swift
//  coupleDayWatch WatchKit Extension
//
//  Created by 김성훈 on 2022/07/12.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet weak var demoImage: WKInterfaceImage!
    @IBOutlet weak var demoLabel: WKInterfaceLabel!
    @IBOutlet weak var topTitle: WKInterfaceLabel!
    @IBOutlet weak var todayLabel: WKInterfaceLabel!
    @IBOutlet weak var group: WKInterfaceGroup!
    
    var count: Int = 0
    let session = WCSession.default
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        if let data = userInfo["dayData"] as? String {
            let nowDayDataString = Date().toString // 현재 날짜 스트링 데이터
            let nowDayDataDate = nowDayDataString.toDate // 현재 날짜 데이트 데이터
            let minus = nowDayDataDate.millisecondsSince1970-Int64(data)! // 현재 - 사귄날짜 = days
            let value = String(describing: minus / 86400000)
            DispatchQueue.main.async {
                self.demoLabel.setText("\(value) days")
            }
        } else {
            self.demoLabel.setText("days")
        }
    }
    
    override init() {
        super.init()
        assert(WCSession.isSupported(), "watch")
        WCSession.default.delegate = self
        WCSession.default.activate()
    }
    
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        //        session.delegate = self
        //        session.activate()
    }
    
    override func willActivate() {
        group.setContentInset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        self.topTitle.setText("우리 오늘")
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko-KR")
        dateFormatter.dateFormat = "yyyy.MM.dd"
        self.todayLabel.setText(dateFormatter.string(from: Date.now))
        
        //        return dateFormatter.string(from: self)
        
        // updateApplicationContext
        //
        let timedColor = WCSession.default.receivedApplicationContext
        if timedColor.isEmpty == false {
            DispatchQueue.main.async {
                self.demoImage.setImage(UIImage(data: timedColor.values.first as! Data))
            }
        }
        
        //        let test = WCSession.default.outstandingUserInfoTransfers
        //        self.demoLabel.setText("sunghun \(test)")
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
}

extension Date { // MARK: Date
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
    var millisecondsSince1970: Int64 {
        Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    // date -> yyyy-MM-dd 형식의 string 으로 변환
    //
    var toString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko-KR")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
}

extension String { // MARK: String
    
    // yyyy-MM-dd 형식 string -> date 로 변환
    //
    var toDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        return dateFormatter.date(from: self)!
    }
}
