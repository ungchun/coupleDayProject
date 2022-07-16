import Foundation
import RealmSwift

// Realm Image DB
//
class ImageModel: Object {
    @objc dynamic var mainImageData: Data? = nil
    @objc dynamic var myProfileImageData: Data? = nil
    @objc dynamic var partnerProfileImageData: Data? = nil
}
