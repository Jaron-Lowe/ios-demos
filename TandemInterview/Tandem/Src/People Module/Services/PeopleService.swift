import Combine
import Foundation
import SimpleApiClient

protocol PeopleServicing {
	func getPeople() -> AnyPublisher<AsyncResult<GetPeopleResponse, Error>, Never>
}

final class PeopleService {
	private let client: TandemClient
	
	init(client: TandemClient) {
		self.client = client
	}
}

extension PeopleService: PeopleServicing {
	func getPeople() -> AnyPublisher<AsyncResult<GetPeopleResponse, Error>, Never> {
		client.sendPublisher(api: GetPeopleRequest())
	}
}
