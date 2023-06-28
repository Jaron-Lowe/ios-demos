import Combine
import Foundation
import SimpleApiClient

protocol SwiftUIViewModel {
	associatedtype Inputs
	func transform(inputs: Inputs)
}

final class PeopleListViewModel: ObservableObject {
	private let service: PeopleServicing
	@Published var viewState: ViewState = .loading
	
	init(service: PeopleServicing) {
		self.service = service
	}
}

extension PeopleListViewModel: SwiftUIViewModel {
	struct Inputs {
		let viewAppears: AnyPublisher<Void, Never>
	}
	
	struct Compositions {
		let peopleResponse: AnyPublisher<AsyncResult<GetPeopleResponse, Error>, Never>
	}
		
	func transform(inputs: Inputs) {
		let compositions = Compositions(peopleResponse: peopleResponse(inputs: inputs))
		
		let viewStateOutput = viewState(compositions: compositions)
		viewStateOutput.assign(to: &$viewState)
	}
}

private extension PeopleListViewModel {
	// MARK: Compositions
	
	func peopleResponse(inputs: Inputs) -> AnyPublisher<AsyncResult<GetPeopleResponse, Error>, Never> {
		inputs.viewAppears
			.scan(0, { accumulator, _ in
				accumulator + 1
			})
			.filter { $0 != 0 }
			.map { [service = self.service] _ in
				service.getPeople()
			}
			.switchToLatest()
			.share()
			.eraseToAnyPublisher()
	}
	
	// MARK: Outputs
	
	func viewState(compositions: Compositions) -> AnyPublisher<ViewState, Never> {
		compositions.peopleResponse
			.map {
				switch $0 {
				case .inProgress:
					return .loading
				case .success(let response):
					return .loaded(response.people)
				case .failure:
					return .failed
					
				}
			}
			.receive(on: DispatchQueue.main)
			.eraseToAnyPublisher()
	}
}

extension PeopleListViewModel {
	enum ViewState {
		case loading
		case loaded([Person])
		case failed
	}
}
