import Foundation
import Combine

// ViewModel DataBinding Combine
//
class ContainerViewModelCombine: ObservableObject {
    
    // MARK: Properties
    //
    private var changeLabelCheck = false // 타이머 시작은 딱 한번만 해야함 -> 체크하는 변수
    private var labelState = false // 앱 이름 <> 연애 날짜 상태확인해주는 변수
    private var changeLabelTimer = Timer() // 자동으로 함수 실행하기 위한 타이머
    var receivedCoupleDayData = "너랑나랑" // NotificationCenter로 커플 날짜 변경되면 변경된 날짜 데이터 받아옴
    
    @Published var appNameLabelValue: String = "너랑나랑"
    
    // MARK: Functions
    //
    init() {
        changeAppNameLabel()
        
        // Notification Center에 Observer 등록
        //
        NotificationCenter.default.addObserver(self, selector: #selector(receiveCoupleDayData(notification:)), name: Notification.Name.coupleDay, object: nil)
    }
    fileprivate func changeAppNameLabel() {
        if !changeLabelCheck {
            
            // 10초마다 updateLabel() 실행
            //
            changeLabelTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updateLabel), userInfo: nil, repeats: true)
            changeLabelCheck = true
        }
    }
    @objc fileprivate func updateLabel() {
        self.appNameLabelValue = labelState ? "\(receivedCoupleDayData) days" : "너랑나랑"
        labelState.toggle()
    }
    @objc func receiveCoupleDayData(notification: Notification) {
        // notification.userInfo 값을 받아온다.
        //
        guard let object = notification.userInfo?["coupleDay"] as? String else {
            return
        }
        receivedCoupleDayData = object
    }
}
