import PhotosUI
import SwiftUI
import UIKit

enum ImageCropImplementation {
	case frameworkless
	case tca
}

enum SDKImplementation {
	case uiKit
	case swiftUI
}

final class ViewController: UIViewController {
	// MARK: Properties
	
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var sdkSegmentControl: UISegmentedControl!
	
	var shape: ImageCropShape = .square {
		didSet {
			switch shape {
			case .square:
				imageView.layer.cornerRadius = 0
			case .circle:
				imageView.layer.cornerRadius = imageView.bounds.width / 2
			}
		}
	}
	var implementation: ImageCropImplementation = .tca {
		didSet {
			sdkSegmentControl.isEnabled = implementation == .tca
		}
	}
	var sdk: SDKImplementation = .uiKit
	
	// MARK: UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		imageView.layer.borderColor = UIColor.secondarySystemBackground.cgColor
		imageView.layer.borderWidth = 2.0
	}

	// MARK: IBActions
	
	@IBAction func shapeValueChanged(_ sender: UISegmentedControl) {
		shape = sender.selectedSegmentIndex == 0 ? .square : .circle
	}
	
	@IBAction func implementationValueChanged(_ sender: UISegmentedControl) {
		implementation = sender.selectedSegmentIndex == 0 ? .frameworkless : .tca
	}
	
	@IBAction func sdkValueChanged(_ sender: UISegmentedControl) {
		sdk = sender.selectedSegmentIndex == 0 ? .uiKit : .swiftUI
	}
	
	@IBAction func cropWomanButtonPressed(_ sender: Any) {
		displayCropController(with: UIImage(named: "Female_Portrait.jpg"))
	}
	
	@IBAction func cropVerticalButtonPressed(_ sender: Any) {
		displayCropController(with: UIImage(named: "Vertical.jpeg"))
	}
	
	@IBAction func cropHorizontalButtonPressed(_ sender: Any) {
		displayCropController(with: UIImage(named: "Horizontal.jpg"))
	}
	
	@IBAction func cropFromLibraryButtonPressed(_ sender: Any) {
		displayPhotoPicker()
	}
}

private extension ViewController {
	func displayCropController(with image: UIImage?) {
		guard let image else { return }
		switch implementation {
		case .frameworkless:
			displayFrameworklessCropController(with: image)
		case .tca:
			displayTCACropController(with: image)
		}
	}
	
	func displayFrameworklessCropController(with image: UIImage) {
		let cropController = ImageCropViewController(image: image, shape: shape, resultType: .frame) { [weak self] result in
			self?.processImageCropResult(result, originalImage: image)
		}
		let navController = UINavigationController(rootViewController: cropController)
		present(navController, animated: true)
	}
	
	func displayTCACropController(with image: UIImage) {
		let store = ImageCropStore(
			initialState: .init(
				image: image,
				shape: shape,
				resultType: .frame
			),
			reducer: {
				ImageCropReducer(completion: { [weak self] result in
					self?.processImageCropResult(result, originalImage: image)
				})
			}
		)
		let controller: UIViewController
		switch sdk {
		case .uiKit:
			controller = TCAImageCropViewController(store: store)
		case .swiftUI:
			if #available(iOS 16, *) {
				controller = UIHostingController(rootView: CropView(store: store))
			} else {
				controller = UIHostingController(rootView: EmptyView())
			}
		}
		let navController = UINavigationController(rootViewController: controller)
		present(navController, animated: true)
	}
	
	func processImageCropResult(_ result: ImageCropResult, originalImage: UIImage) {
		switch result {
		case .image(let image):
			imageView.image = image
		case .frame(let frame):
			imageView.image = originalImage.cropped(within: frame)
		}
	}
	
	func displayPhotoPicker() {
		guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
		let picker = UIImagePickerController()
		picker.sourceType = .photoLibrary
		picker.delegate = self
		present(picker, animated: true)
	}
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		picker.dismiss(animated: true)
		guard let image = info[.originalImage] as? UIImage else { return }
		displayCropController(with: image)
	}
}
