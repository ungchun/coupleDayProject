import Foundation

import FirebaseFirestore

protocol FirebaseInterface {
	
}

enum FirebaseError: Error {
	case noData
	case network
	case exception(errorMessage: String)
}

final class FirebaseService: FirebaseInterface {
	
	static let shared = FirebaseService()
	
	let firestore: Firestore
	
	private init() {
		self.firestore = Firestore.firestore()
	}
}
