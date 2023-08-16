import UIKit

final class ImageCropViewController: UIViewController {
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
	
	let resultType: ImageCropResultType
	let completion: ImageCropCompletionHandler
    var fadeTimer: Timer? = nil
    
	// MARK: Initialization
	
	init(image: UIImage, shape: ImageCropShape = .square, resultType: ImageCropResultType, completion: @escaping ImageCropCompletionHandler) {
		self.resultType = resultType
		self.completion = completion
		
		contentView = ImageCropView(image: image, shape: shape)
		
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
		
		startFadeTimer()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        haltFadeTimer()
    }
    
    // MARK: IBActions
    
    @IBAction func cancelButtonPressed(_ sender:UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
		let cropFrame = contentView.scrollView.convert(
			contentView.scrollView.bounds,
			to: contentView.imageView
		)
		switch resultType {
		case .image:
			guard let image = contentView.imageView.image?.cropped(within: cropFrame) else { return }
			completion(.image(image))
		case .frame:
			completion(.frame(cropFrame))
		}
        dismiss(animated: true)
    }
}

private extension ImageCropViewController {
	func startFadeTimer() {
		haltFadeTimer()
		fadeTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { [weak self] _ in
			self?.fadeOutEditorOverlay()
		}
	}
	
	func haltFadeTimer() {
		fadeInEditorOverlay()
		fadeTimer?.invalidate()
		fadeTimer = nil
	}
	
	func fadeOutEditorOverlay() {
		UIView.animate(withDuration: 0.5, animations: {() in
			self.contentView.gridView.alpha = 0.0
			self.contentView.alphaView.alpha = 0.0
			self.contentView.blurView.alpha = 1.0
		})
	}
	
	func fadeInEditorOverlay() {
		UIView.animate(withDuration: 0.5, animations: {() in
			self.contentView.gridView.alpha = 1.0
			self.contentView.alphaView.alpha = 1.0
			self.contentView.blurView.alpha = 0.0
		})
	}
}

extension ImageCropViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        haltFadeTimer()
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        haltFadeTimer()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        startFadeTimer()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        startFadeTimer()
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        startFadeTimer()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		contentView.imageView
    }
}
