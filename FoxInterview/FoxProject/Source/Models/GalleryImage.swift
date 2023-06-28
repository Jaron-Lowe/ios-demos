import Foundation

struct GalleryImage {
	let url: String
	
	static let all: [GalleryImage] = [Int](1..<124).reduce(into: [], { partialResult, index in
		partialResult.append(.init(url: "https://jaronlowe.com/services/Profile_Pictures/Female_\(index).jpeg"))
		if index <= 52 {
			partialResult.append(.init(url: "https://jaronlowe.com/services/Profile_Pictures/Male_\(index).jpeg"))
		}
	})
}
