import Foundation

import RealmSwift

final class User: Object {
    @objc dynamic var beginCoupleDay = 0
    @objc dynamic var birthDay = 0
    @objc dynamic var zeroDayStartCheck = false
}
