import ComposableArchitecture
import UIKit

typealias ImageCropStore = StoreOf<ImageCropReducer>

struct ImageCropReducer: Reducer {
	
	let completion: ImageCropCompletionHandler
	
	private enum CancelID {
		case blurTimer
	}
	
	struct State: Equatable {
		let image: UIImage
		let shape: ImageCropShape
		let resultType: ImageCropResultType
		var isEditing = true
	}
	
	enum Action: Equatable {
		case viewDidLoad
		case cropEdit
		case blurTimerElapsed
		case doneButtonPressed(CGRect, UIViewController)
		case cancelButtonPressed(UIViewController)
	}
	
	func reduce(into state: inout State, action: Action) -> Effect<Action> {
		switch action {
		case .viewDidLoad:
			return .send(.cropEdit)
		case .cropEdit:
			state.isEditing = true
			return .merge(
				.cancel(id: CancelID.blurTimer),
				.run { send in
					try await Task.sleep(nanoseconds: UInt64(1.5) * 1_000_000_000)
					await send(.blurTimerElapsed)
				}.cancellable(id: CancelID.blurTimer)
			)
		case .blurTimerElapsed:
			state.isEditing = false
		case .doneButtonPressed(let cropFrame, let controller):
			switch state.resultType {
			case .image:
				guard let croppedImage = state.image.cropped(within: cropFrame) else { return .none }
				completion(.image(croppedImage))
			case .frame:
				completion(.frame(cropFrame))
			}
			controller.dismiss(animated: true)
		case .cancelButtonPressed(let controller):
			controller.dismiss(animated: true)
		}
		return .none
	}
}
