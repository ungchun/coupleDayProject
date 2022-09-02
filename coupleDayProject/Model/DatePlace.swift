import Foundation
import FirebaseFirestoreSwift

struct DatePlace: Codable {
    var placeName: String
    var address: String
    var shortAddress: String
    var introduce: Array<String>
    var imageUrl: Array<String>
    var latitude: String
    var longitude: String
    var modifyState: Bool

    init() {
        self.placeName  = "empty placeName"
        self.address  = "empty address"
        self.introduce  = []
        self.shortAddress = "empty shortAddress"
        self.imageUrl = []
        self.latitude = "empty latitude"
        self.longitude = "empty longitude"
        self.modifyState = false
    }
}

let LocalName: [String: String] = [
    "chungcheong": "충청", "gangwon": "강원", "gyeongsang": "경상", "jeju": "제주", "jeolla": "전라", "seoul": "서울", "sudo": "수도권"
]
