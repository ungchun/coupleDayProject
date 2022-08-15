import Foundation
import FirebaseFirestoreSwift

struct DatePlace: Codable {
    var placeName: String
    var address: String
    var introduce: String
    var number: String
    
    init() {
        self.placeName  = "empty placeName"
        self.address  = "empty address"
        self.introduce  = "empty introduce"
        self.number  = "empty number"
    }
}
