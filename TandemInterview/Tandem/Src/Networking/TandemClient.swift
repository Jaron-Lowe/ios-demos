import Foundation
import SimpleApiClient

final class TandemClient: HttpClient {
	init() {
		super.init(baseUrl: URL(string: "https://gist.githubusercontent.com/russellbstephens/41e3b81879cf096212fc9834be0407b5/")!)
	}
}
