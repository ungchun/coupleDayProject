import Foundation

struct Place: Codable {
	let placeName: String
	let address: String
	let shortAddress: String
	let introduce: Array<String>
	let imageUrl: Array<String>
	let latitude: String
	let longitude: String
	let modifyStateCheck: Bool
}

let LocalName: [String: String] = [
	"seoul": "서울",
	"sudo": "수도권",
	"chungcheong": "충청",
	"gangwon": "강원",
	"gyeongsang": "경상",
	"jeolla": "전라",
	"jeju": "제주"
]
