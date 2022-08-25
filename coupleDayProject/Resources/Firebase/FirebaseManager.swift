import Foundation
import FirebaseFirestore

struct FirebaseManager {
    static let shared = FirebaseManager()
    let firestore: Firestore
    
    private init() {
        self.firestore = Firestore.firestore()
    }
}
