import Foundation
import FirebaseFirestoreSwift

struct DatePlace: Codable {
    var placeName: String
    var address: String
    var shortAddress: String
    var introduce: String
    var number: String
    var imageUrl: Array<String>
    
    init() {
        self.placeName  = "empty placeName"
        self.address  = "empty address"
        self.introduce  = "empty introduce"
        self.number  = "empty number"
        self.shortAddress = "empty shortAddress"
        self.imageUrl = []
    }
}
