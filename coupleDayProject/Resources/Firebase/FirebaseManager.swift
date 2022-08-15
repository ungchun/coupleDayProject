import Foundation
import FirebaseFirestore

final class FirebaseManager {
    static let shared = FirebaseManager()
    let firestore: Firestore
    
    private init() {
        self.firestore = Firestore.firestore()
    }
}
