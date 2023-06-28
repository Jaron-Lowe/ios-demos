import SwiftUI

@main
struct TandemApp: App {
    var body: some Scene {
        WindowGroup {
            PeopleListView(viewModel: PeopleListViewModel(service: PeopleService(client: TandemClient())))
        }
    }
}
