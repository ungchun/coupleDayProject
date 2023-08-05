import Foundation

import FirebaseFirestore

enum FetchKind {
	case couple
	case placeList
}

protocol FirebaseInterface { }

final class FirebaseService: FirebaseInterface {
	
	static let shared = FirebaseService()
	
	let firestore: Firestore
	
	private init() {
		self.firestore = Firestore.firestore()
	}
	
	static func fetchPlace(localNameText: String, fetchKind: FetchKind) async throws -> [Place] {
		
		var placeCount = 0
		var placeArray: [Place] = []
		
		return try await withUnsafeThrowingContinuation { configuration in
			FirebaseService.shared.firestore.collection("\(localNameText)").getDocuments { (querySnapshot, error) in
				
				guard let querySnapshot = querySnapshot else {
					configuration.resume(throwing: FirebaseError.badsnapshot)
					return
				}
				
				for document in querySnapshot.documents {
					let dto = PlaceDTO(
						id: document.documentID,
						modifyState: document.data()["modifyState"] as? Bool,
						address: document.data()["address"] as? String,
						shortAddress: document.data()["shortAddress"] as? String,
						introduce: document.data()["introduce"] as? [String],
						imageUrl: document.data()["imageUrl"] as? [String],
						latitude: document.data()["latitude"] as? String,
						longitude: document.data()["longitude"] as? String
					)
					let entity = dto.toEntity()
					placeArray.append(entity)
					
					placeCount += 1
					
					DispatchQueue.global().async {
						guard let imageUrl = entity.imageUrl.first else { return }
						CacheImageManger().downloadImageAndCache(urlString: imageUrl)
					}
					
					if fetchKind == .couple {
						if placeCount == 5 { break }
					}
				}
				configuration.resume(returning: placeArray)
			}
		}
	}
}
