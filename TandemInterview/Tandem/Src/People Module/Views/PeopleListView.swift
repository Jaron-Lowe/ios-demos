import Combine
import SwiftUI

struct PeopleListView: View {
	private let viewAppears = PassthroughSubject<Void, Never>()
	
	@ObservedObject var viewModel: PeopleListViewModel
	
	init(viewModel: PeopleListViewModel) {
		self.viewModel = viewModel
		viewModel.transform(inputs: .init(viewAppears: viewAppears.eraseToAnyPublisher()))
	}
	
    var body: some View {
		ZStack {
			switch viewModel.viewState {
			case .loading:
				ProgressView()
			case .loaded(let people):
				List(people) { person in
					VStack(alignment: .leading, spacing: 4.0) {
						Text(person.name)
							.font(.body)
						Text(person.language ?? "Unknown")
							.font(.caption)
					}
				}
			case .failed:
				VStack {
					Text("Something went wrong")
						.font(.title)
					Text("We should handle the error case ;)")
				}
				
			}
		}
		.onAppear {
			viewAppears.send()
		}
    }
}

extension Person: Identifiable {
	var id: String { name }
}
