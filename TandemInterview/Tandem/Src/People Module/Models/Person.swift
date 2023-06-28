import Foundation

struct GetPeopleResponse: Decodable {
	let people: [Person]
}

struct Person: Decodable {
	let name: String
	let language: String?
}

