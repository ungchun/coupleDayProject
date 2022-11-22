import Foundation
import Combine

final class MainViewModelCombine: ObservableObject {
    
    // MARK: Properties
    //
    private var changeLabelInitCheck = false
    private var appNameDayToggleFlag = false
    private var changeLabelTimer = Timer()
    var receivedCoupleDayData = "너랑나랑" // NotificationCenter로 커플 날짜 변경되면 변경된 날짜 데이터 받아옴
    
    @Published var appNameLabelValue: String = "너랑나랑"
    
    // MARK: Functions
    //
    init() {
        changeAppNameLabel()
        
        // Notification Center에 Observer 등록
        //
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(receiveCoupleDayData(notification:)),
            name: Notification.Name.coupleDay, object: nil
        )
    }
    private func changeAppNameLabel() {
        if !changeLabelInitCheck {
            changeLabelTimer = Timer.scheduledTimer(
                timeInterval: 5,
                target: self,
                selector: #selector(updateLabel),
                userInfo: nil,
                repeats: true
            )
            changeLabelInitCheck = true
        }
    }
    @objc private func updateLabel() {
        self.appNameLabelValue = appNameDayToggleFlag ? "\(receivedCoupleDayData) days" : "너랑나랑"
        appNameDayToggleFlag.toggle()
    }
    @objc private func receiveCoupleDayData(notification: Notification) {
        // notification.userInfo 값을 받아온다.
        //
        guard let object = notification.userInfo?["coupleDay"] as? String else {
            return
        }
        receivedCoupleDayData = object
    }
}
