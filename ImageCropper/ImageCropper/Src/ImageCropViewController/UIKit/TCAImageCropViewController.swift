import Combine
import ComposableArchitecture
import UIKit

final class TCAImageCropViewController: UIViewController {
	// MARK: Properties
	
	private lazy var cancelButton: UIBarButtonItem = {
		.init(
			barButtonSystemItem: .cancel,
			target: self,
			action: #selector(cancelButtonPressed(_:))
		)
	}()
	
	private lazy var doneButton: UIBarButtonItem = {
		.init(
			barButtonSystemItem: .done,
			target: self,
			action: #selector(doneButtonPressed(_:))
		)
	}()
	
	private let contentView: ImageCropView
	
	let viewStore: ViewStoreOf<ImageCropReducer>
	var cancelBag = Set<AnyCancellable>()
	var previewTask: DispatchWorkItem?
	
	// MARK: Initialization
	
	init(store: ImageCropStore) {
		self.viewStore = ViewStore(store, observe: { $0 })
		contentView = ImageCropView(image: viewStore.image, shape: viewStore.shape)
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: UIViewController
	
	override func loadView() {
		view = contentView
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()

		contentView.scrollView.delegate = self
		navigationItem.leftBarButtonItem = cancelButton
		navigationItem.rightBarButtonItem = doneButton
		
		setUpSubscriptions()
		viewStore.send(.viewDidLoad)
	}
	
	// MARK: IBActions
	
	@IBAction func cancelButtonPressed(_ sender:UIBarButtonItem) {
		viewStore.send(.cancelButtonPressed(self))
	}
	
	@IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
		let cropFrame = contentView.scrollView.convert(
			contentView.scrollView.bounds,
			to: contentView.imageView
		)
		viewStore.send(.doneButtonPressed(cropFrame, self))
	}
}

private extension TCAImageCropViewController {
	func setUpSubscriptions() {
		viewStore.publisher.isEditing
			.removeDuplicates()
			.sink { [weak self] isEditing in
				self?.updateViewsForEditing(isEditing: isEditing)
			}
			.store(in: &cancelBag)
	}
	
	func updateViewsForEditing(isEditing: Bool) {
		UIView.animate(withDuration: 0.5, animations: {() in
			if isEditing {
				self.contentView.gridView.alpha = 1.0
				self.contentView.alphaView.alpha = 1.0
				self.contentView.blurView.alpha = 0.0
			} else {
				self.contentView.gridView.alpha = 0.0
				self.contentView.alphaView.alpha = 0.0
				self.contentView.blurView.alpha = 1.0
			}
		})
	}
}

extension TCAImageCropViewController: UIScrollViewDelegate {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		viewStore.send(.cropEdit)
	}
	
	func scrollViewDidZoom(_ scrollView: UIScrollView) {
		viewStore.send(.cropEdit)
	}
	
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		contentView.imageView
	}
}
