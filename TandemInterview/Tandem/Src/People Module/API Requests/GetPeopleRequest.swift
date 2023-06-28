import Foundation
import SimpleApiClient

struct GetPeopleRequest: HttpApiRequest {
	typealias ResponseType = GetPeopleResponse
	
	var endpointPath: String {
		"raw/388971ddd9fd1b099e829de233526eb345a1ad37/people.json"
	}
	
	var method: SimpleApiClient.HttpMethod {
		.get
	}
}
