import Foundation

import RealmSwift

final class HomeImage: Object {
    @objc dynamic var homeMainImage: Data? = nil
    @objc dynamic var myProfileImage: Data? = nil
    @objc dynamic var partnerProfileImage: Data? = nil
}