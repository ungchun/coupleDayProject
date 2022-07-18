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
        // receive transferUserInfo
        // transferUserInfo -> app 이 켜져야 새로고침 전달한다는 느낌 -> image 는 바꿀려면 앱 켜서 바꿔야해서 ok
        //
        if let data = userInfo["imageData"] as? Data {
            DispatchQueue.main.async {
                self.demoImage.setImage(UIImage(data: data))
            }
        } else { }
    }
    
    override init() {
        super.init()
        //        assert(WCSession.isSupported(), "watch")
        //        WCSession.default.delegate = self
        //        WCSession.default.activate()
    }
    
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        assert(WCSession.isSupported(), "watch")
        WCSession.default.delegate = self
        WCSession.default.activate()
    }
    
    override func willActivate() {
        group.setContentInset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        // updateApplicationContext -> transferUserInfo 랑은 다르게 항상 도는거 같음 (내부 디비 쓰는 느낌 ?) -> days는 하루가 지나면 앱을 안키더라도 업데이트 되어야해서 updateApplicationContext 처리
        // 그럼 이미지도 updateApplicationContext 쓰면 안되냐 ? -> updateApplicationContext 중복 불가, 뒤에 오는 데이터가 앞 데이터 덮어버림
        //
        let timedColor = WCSession.default.receivedApplicationContext
        if timedColor.isEmpty == false {
            DispatchQueue.main.async {
                // 현재 날짜 스트링 데이터 -> 현재 날짜 데이트 데이터
                // 현재 - 사귄날짜 = days
                //
                if let data = timedColor.values.first as? String {
                    let nowDayDataString = Date().toString
                    let nowDayDataDate = nowDayDataString.toDate
                    let minus = nowDayDataDate.millisecondsSince1970-Int64(data)!
                    let value = String(describing: minus / 86400000)
                    DispatchQueue.main.async {
                    self.demoLabel.setText("\(value) days")
                    }
                } else {
                    self.demoLabel.setText("days")
                }
            }
        }
        
        self.topTitle.setText("우리 오늘")
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko-KR")
        dateFormatter.dateFormat = "yyyy.MM.dd"
        self.todayLabel.setText(dateFormatter.string(from: Date.now))
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
}

extension Date { // MARK: Date extension
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

extension String { // MARK: String extension
    
    // yyyy-MM-dd 형식 string -> date 로 변환
    //
    var toDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        return dateFormatter.date(from: self)!
    }
}
