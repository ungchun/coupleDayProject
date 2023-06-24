import Foundation

import RealmSwift

final class RealmUserModel: Object {
    @objc dynamic var beginCoupleDay = 0
    @objc dynamic var birthDay = 0
    @objc dynamic var zeroDayStartCheck = false
}
