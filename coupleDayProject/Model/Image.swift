//
//  Image.swift
//  coupleDayProject
//
//  Created by 김성훈 on 2022/06/26.
//

import Foundation
import RealmSwift

class Image: Object {
    @objc dynamic var mainImageData: Data? = nil
    @objc dynamic var myProfileImageData: Data? = nil
    @objc dynamic var partnerProfileImageData: Data? = nil
}