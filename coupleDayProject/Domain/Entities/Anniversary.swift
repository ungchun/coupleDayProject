import UIKit

final class Anniversary {
	static var AnniversaryInfo: [[String:String]] = [[:]]
	static var AnniversaryImageUrl: [[String:String]] = [[:]]
}

func initNotBirthDayAnniversary() {
	Anniversary.AnniversaryInfo = [
		["\(DateValues.GetOnlyYear())-01-14": "다이어리데이"],
		["\(DateValues.GetOnlyYear())-01-19": "찜질방데이"],
		["\(DateValues.GetOnlyYear())-02-02": "액자데이"],
		["\(DateValues.GetOnlyYear())-02-14": "발렌타인데이"],
		["\(DateValues.GetOnlyYear())-02-22": "커플데이"],
		["\(DateValues.GetOnlyYear())-03-03": "삼겹살데이"],
		["\(DateValues.GetOnlyYear())-03-14": "화이트데이"],
		["\(DateValues.GetOnlyYear())-04-04": "클로버데이"],
		["\(DateValues.GetOnlyYear())-04-05": "블랙데이"],
		["\(DateValues.GetOnlyYear())-05-14": "로즈데이"],
		["\(DateValues.GetOnlyYear())-06-06": "반지데이"],
		["\(DateValues.GetOnlyYear())-06-14": "키스데이"],
		["\(DateValues.GetOnlyYear())-07-07": "엿데이"],
		["\(DateValues.GetOnlyYear())-07-14": "아이스크림데이"],
		["\(DateValues.GetOnlyYear())-08-08": "목걸이데이"],
		["\(DateValues.GetOnlyYear())-08-14": "뮤직데이"],
		["\(DateValues.GetOnlyYear())-09-14": "포토데이"],
		["\(DateValues.GetOnlyYear())-10-14": "와인데이"],
		["\(DateValues.GetOnlyYear())-10-22": "통화데이"],
		["\(DateValues.GetOnlyYear())-10-31": "할로윈데이"],
		["\(DateValues.GetOnlyYear())-11-11": "빼빼로데이"],
		["\(DateValues.GetOnlyYear())-11-14": "무비데이"],
		["\(DateValues.GetOnlyYear())-12-14": "허그데이"],
		["\(DateValues.GetOnlyYear())-12-25": "크리스마스"],
		["\(DateValues.GetOnlyYear())-12-31": "\(DateValues.GetOnlyYear()) 마지막"],
	]
	
	Anniversary.AnniversaryImageUrl = [
		["\(DateValues.GetOnlyYear())-01-14": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/diary.jpg?alt=media&token=21c3b832-e66c-483e-8034-5ed98f4b80ae"],
		["\(DateValues.GetOnlyYear())-01-19": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/sauna.jpg?alt=media&token=70649a6e-311b-4fcb-993b-669c73b34c9c"],
		["\(DateValues.GetOnlyYear())-02-02": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/frame.jpg?alt=media&token=67869f70-f0b4-4352-8dac-be48b9407311"],
		["\(DateValues.GetOnlyYear())-02-14": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/valentine.jpg?alt=media&token=d7a86611-3c82-4b25-a7f0-034a164057c5"],
		["\(DateValues.GetOnlyYear())-02-22": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/couple.jpg?alt=media&token=57a7a7f6-fdb4-4e28-8c9f-cf08d25ec143"],
		["\(DateValues.GetOnlyYear())-03-03": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/pork.jpg?alt=media&token=5275c4a3-e788-448d-8f82-b23badc6fc27"],
		["\(DateValues.GetOnlyYear())-03-14": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/white.jpg?alt=media&token=37ff4811-acc7-477d-a6c5-4796049e065c"],
		["\(DateValues.GetOnlyYear())-04-04": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/clover.jpg?alt=media&token=b0dfb66d-8b9a-4eb6-8065-ea6a4d21fb97"],
		["\(DateValues.GetOnlyYear())-04-05": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/black.jpg?alt=media&token=246e7094-c2fe-4dc8-9c19-bbe82d111a7d"],
		["\(DateValues.GetOnlyYear())-05-14": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/rose.jpg?alt=media&token=447b23e7-e851-4ddc-afb3-5777354385fb"],
		["\(DateValues.GetOnlyYear())-06-06": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/ring.jpg?alt=media&token=ddc3b8ea-aac1-486a-b601-4fe84dc666dd"],
		["\(DateValues.GetOnlyYear())-06-14": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/kiss.jpg?alt=media&token=341f24bc-7c0f-4782-9445-cc3f69c0daf8"],
		["\(DateValues.GetOnlyYear())-07-07": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/yeot.jpg?alt=media&token=a788d7ea-e167-4ede-a52b-cce963e0ef8b"],
		["\(DateValues.GetOnlyYear())-07-14": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/iceCream.jpg?alt=media&token=385c05ba-91b3-4780-a8e9-d336c120b3dc"],
		["\(DateValues.GetOnlyYear())-08-08": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/necklace.jpg?alt=media&token=2b764d7c-99ac-410f-9170-d3bae4f1dbce"],
		["\(DateValues.GetOnlyYear())-08-14": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/msuic.jpg?alt=media&token=dbb905b6-daa1-418b-8756-266b266dd2ca"],
		["\(DateValues.GetOnlyYear())-09-14": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/photo.jpg?alt=media&token=6b915863-ee75-4ae1-bef7-78d05f59451b"],
		["\(DateValues.GetOnlyYear())-10-14": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/whine.jpg?alt=media&token=68d07cb3-7ea9-4c53-8e06-6d863b064d36"],
		["\(DateValues.GetOnlyYear())-10-22": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/call.jpg?alt=media&token=d7bae2dc-168c-4928-8022-a692acdde53e"],
		["\(DateValues.GetOnlyYear())-10-31": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/halloween.jpg?alt=media&token=e4dbe08c-179b-4a1f-8a2e-ade35369aa11"],
		["\(DateValues.GetOnlyYear())-11-11": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/pepero.jpg?alt=media&token=512db221-e6cf-490c-85fe-e02a57e7e32f"],
		["\(DateValues.GetOnlyYear())-11-14": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/movie.jpg?alt=media&token=eb5f706a-ddb7-41b1-af33-02bff4076efc"],
		["\(DateValues.GetOnlyYear())-12-14": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/hug.jpg?alt=media&token=93dba46d-748d-4998-b3ba-746a586939df"],
		["\(DateValues.GetOnlyYear())-12-25": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/christmas.jpg?alt=media&token=d3a7fdec-277e-4619-8e26-abd20d8bd73c"],
		["\(DateValues.GetOnlyYear())-12-31": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/newYear.jpg?alt=media&token=db38d39e-ad33-44e1-8ba4-804cbdbd5ad9"]
	]
	
	Anniversary.AnniversaryInfo.sort {$0.keys.first?.toDate ?? Date() < $1.keys.first?.toDate ?? Date()}
	Anniversary.AnniversaryImageUrl.sort {$0.keys.first?.toDate ?? Date() < $1.keys.first?.toDate ?? Date()}
	
	DispatchQueue.global().async {
		Anniversary.AnniversaryImageUrl.forEach { values in
			if let url = values.values.first {
				CacheImageManger().downloadImageAndCache(urlString: url)
			}
		}
	}
}

func initBirthDayAnniversary(dateValue: Int) {
	Anniversary.AnniversaryInfo = [
		["\(DateValues.GetOnlyYear())-\(Date(timeIntervalSince1970: TimeInterval(dateValue) / 1000).toMinusAnniversaryString)": "생일"],
		["\(DateValues.GetOnlyYear())-01-14": "다이어리데이"],
		["\(DateValues.GetOnlyYear())-01-19": "찜질방데이"],
		["\(DateValues.GetOnlyYear())-02-02": "액자데이"],
		["\(DateValues.GetOnlyYear())-02-14": "발렌타인데이"],
		["\(DateValues.GetOnlyYear())-02-22": "커플데이"],
		["\(DateValues.GetOnlyYear())-03-03": "삼겹살데이"],
		["\(DateValues.GetOnlyYear())-03-14": "화이트데이"],
		["\(DateValues.GetOnlyYear())-04-04": "클로버데이"],
		["\(DateValues.GetOnlyYear())-04-05": "블랙데이"],
		["\(DateValues.GetOnlyYear())-05-14": "로즈데이"],
		["\(DateValues.GetOnlyYear())-06-06": "반지데이"],
		["\(DateValues.GetOnlyYear())-06-14": "키스데이"],
		["\(DateValues.GetOnlyYear())-07-07": "엿데이"],
		["\(DateValues.GetOnlyYear())-07-14": "아이스크림데이"],
		["\(DateValues.GetOnlyYear())-08-08": "목걸이데이"],
		["\(DateValues.GetOnlyYear())-08-14": "뮤직데이"],
		["\(DateValues.GetOnlyYear())-09-14": "포토데이"],
		["\(DateValues.GetOnlyYear())-10-14": "와인데이"],
		["\(DateValues.GetOnlyYear())-10-22": "통화데이"],
		["\(DateValues.GetOnlyYear())-10-31": "할로윈데이"],
		["\(DateValues.GetOnlyYear())-11-11": "빼빼로데이"],
		["\(DateValues.GetOnlyYear())-11-14": "무비데이"],
		["\(DateValues.GetOnlyYear())-12-14": "허그데이"],
		["\(DateValues.GetOnlyYear())-12-25": "크리스마스"],
		["\(DateValues.GetOnlyYear())-12-31": "\(DateValues.GetOnlyYear()) 마지막"],
	]
	
	Anniversary.AnniversaryImageUrl = [
		["\(DateValues.GetOnlyYear())-\(Date(timeIntervalSince1970: TimeInterval(dateValue) / 1000).toMinusAnniversaryString)": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/birthday.jpg?alt=media&token=ee79ef6a-136b-449e-959a-2368afa45c99"],
		["\(DateValues.GetOnlyYear())-01-14": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/diary.jpg?alt=media&token=21c3b832-e66c-483e-8034-5ed98f4b80ae"],
		["\(DateValues.GetOnlyYear())-01-19": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/sauna.jpg?alt=media&token=70649a6e-311b-4fcb-993b-669c73b34c9c"],
		["\(DateValues.GetOnlyYear())-02-02": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/frame.jpg?alt=media&token=67869f70-f0b4-4352-8dac-be48b9407311"],
		["\(DateValues.GetOnlyYear())-02-14": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/valentine.jpg?alt=media&token=d7a86611-3c82-4b25-a7f0-034a164057c5"],
		["\(DateValues.GetOnlyYear())-02-22": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/couple.jpg?alt=media&token=57a7a7f6-fdb4-4e28-8c9f-cf08d25ec143"],
		["\(DateValues.GetOnlyYear())-03-03": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/pork.jpg?alt=media&token=5275c4a3-e788-448d-8f82-b23badc6fc27"],
		["\(DateValues.GetOnlyYear())-03-14": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/white.jpg?alt=media&token=37ff4811-acc7-477d-a6c5-4796049e065c"],
		["\(DateValues.GetOnlyYear())-04-04": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/clover.jpg?alt=media&token=b0dfb66d-8b9a-4eb6-8065-ea6a4d21fb97"],
		["\(DateValues.GetOnlyYear())-04-05": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/black.jpg?alt=media&token=246e7094-c2fe-4dc8-9c19-bbe82d111a7d"],
		["\(DateValues.GetOnlyYear())-05-14": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/rose.jpg?alt=media&token=447b23e7-e851-4ddc-afb3-5777354385fb"],
		["\(DateValues.GetOnlyYear())-06-06": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/ring.jpg?alt=media&token=ddc3b8ea-aac1-486a-b601-4fe84dc666dd"],
		["\(DateValues.GetOnlyYear())-06-14": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/kiss.jpg?alt=media&token=341f24bc-7c0f-4782-9445-cc3f69c0daf8"],
		["\(DateValues.GetOnlyYear())-07-07": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/yeot.jpg?alt=media&token=a788d7ea-e167-4ede-a52b-cce963e0ef8b"],
		["\(DateValues.GetOnlyYear())-07-14": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/iceCream.jpg?alt=media&token=385c05ba-91b3-4780-a8e9-d336c120b3dc"],
		["\(DateValues.GetOnlyYear())-08-08": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/necklace.jpg?alt=media&token=2b764d7c-99ac-410f-9170-d3bae4f1dbce"],
		["\(DateValues.GetOnlyYear())-08-14": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/msuic.jpg?alt=media&token=dbb905b6-daa1-418b-8756-266b266dd2ca"],
		["\(DateValues.GetOnlyYear())-09-14": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/photo.jpg?alt=media&token=6b915863-ee75-4ae1-bef7-78d05f59451b"],
		["\(DateValues.GetOnlyYear())-10-14": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/whine.jpg?alt=media&token=68d07cb3-7ea9-4c53-8e06-6d863b064d36"],
		["\(DateValues.GetOnlyYear())-10-22": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/call.jpg?alt=media&token=d7bae2dc-168c-4928-8022-a692acdde53e"],
		["\(DateValues.GetOnlyYear())-10-31": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/halloween.jpg?alt=media&token=e4dbe08c-179b-4a1f-8a2e-ade35369aa11"],
		["\(DateValues.GetOnlyYear())-11-11": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/pepero.jpg?alt=media&token=512db221-e6cf-490c-85fe-e02a57e7e32f"],
		["\(DateValues.GetOnlyYear())-11-14": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/movie.jpg?alt=media&token=eb5f706a-ddb7-41b1-af33-02bff4076efc"],
		["\(DateValues.GetOnlyYear())-12-14": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/hug.jpg?alt=media&token=93dba46d-748d-4998-b3ba-746a586939df"],
		["\(DateValues.GetOnlyYear())-12-25": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/christmas.jpg?alt=media&token=d3a7fdec-277e-4619-8e26-abd20d8bd73c"],
		["\(DateValues.GetOnlyYear())-12-31": "https://firebasestorage.googleapis.com/v0/b/coupledayproject.appspot.com/o/newYear.jpg?alt=media&token=db38d39e-ad33-44e1-8ba4-804cbdbd5ad9"]
	]
	
	Anniversary.AnniversaryInfo.sort {$0.keys.first?.toDate ?? Date() < $1.keys.first?.toDate ?? Date()}
	Anniversary.AnniversaryImageUrl.sort {$0.keys.first?.toDate ?? Date() < $1.keys.first?.toDate ?? Date()}
	
	DispatchQueue.global().async {
		Anniversary.AnniversaryImageUrl.forEach { values in
			if let url = values.values.first {
				CacheImageManger().downloadImageAndCache(urlString: url)
			}
		}
	}
}
