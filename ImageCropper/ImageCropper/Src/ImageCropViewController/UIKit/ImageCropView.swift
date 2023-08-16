import UIKit

final class ImageCropView: UIView {
	// MARK: Properties
	
	private(set) lazy var scrollView: UIScrollView = {
		let view = UIScrollView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = .systemBackground
		view.layer.borderWidth = 2
		view.layer.borderColor = UIColor.white.cgColor
		view.scrollsToTop = false
		view.isScrollEnabled = true
		view.showsVerticalScrollIndicator = false
		view.showsHorizontalScrollIndicator = false
		view.alwaysBounceVertical = true
		view.alwaysBounceHorizontal = true
		view.bouncesZoom = true
		view.minimumZoomScale = 1.0
		view.maximumZoomScale = 3.0
		view.clipsToBounds = false
		return view
	}()
	
	private(set) lazy var imageView: UIImageView = {
		let view = UIImageView(image: image)
		view.isUserInteractionEnabled = true
		return view
	}()
	
	private(set) lazy var gridView: UIView = {
		let view = UIView()
		view.clipsToBounds = true
		view.isUserInteractionEnabled = false
		view.translatesAutoresizingMaskIntoConstraints = false
		
		let lineA = UIView()
		lineA.translatesAutoresizingMaskIntoConstraints = false
		lineA.backgroundColor = .white
		view.addSubview(lineA)
		
		let lineB = UIView()
		lineB.translatesAutoresizingMaskIntoConstraints = false
		lineB.backgroundColor = .white
		view.addSubview(lineB)
		
		let lineC = UIView()
		lineC.translatesAutoresizingMaskIntoConstraints = false
		lineC.backgroundColor = .white
		view.addSubview(lineC)
		
		let lineD = UIView()
		lineD.translatesAutoresizingMaskIntoConstraints = false
		lineD.backgroundColor = .white
		view.addSubview(lineD)
		
		NSLayoutConstraint.activate([
			lineA.widthAnchor.constraint(equalToConstant: 1),
			lineB.widthAnchor.constraint(equalToConstant: 1),
			lineA.topAnchor.constraint(equalTo: view.topAnchor),
			lineB.topAnchor.constraint(equalTo: view.topAnchor),
			lineA.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			lineB.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			.init(item: lineA, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 2/3, constant: 0),
			.init(item: lineB, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 4/3, constant: 0),
			
			lineC.heightAnchor.constraint(equalToConstant: 1),
			lineD.heightAnchor.constraint(equalToConstant: 1),
			lineC.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			lineD.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			lineC.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			lineD.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			.init(item: lineC, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 2/3, constant: 0),
			.init(item: lineD, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 4/3, constant: 0),
		])
		
		return view
	}()
	
	private(set) lazy var blurView: UIVisualEffectView = {
		let blurEffect = UIBlurEffect(style: .systemMaterial)
		let view = UIVisualEffectView(effect: blurEffect)
		view.isUserInteractionEnabled = false
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private(set) lazy var alphaView: UIView = {
		let view = UIView()
		view.isUserInteractionEnabled = false
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = .systemBackground.withAlphaComponent(0.6)
		return view
	}()
	
	private let image: UIImage
	private let shape: ImageCropShape
	private var isFirstLayout = true
	
	// MARK: Initialization
	
	init(image: UIImage, shape: ImageCropShape) {
		self.image = image
		self.shape = shape
		
		super.init(frame: .zero)
		
		setUpView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setUpView() {
		backgroundColor = .systemBackground
		scrollView.contentSize = image.size
		imageView.frame = .init(
			x: 0,
			y: 0,
			width: image.size.width,
			height: image.size.height
		)
		
		addSubview(scrollView)
		scrollView.addSubview(imageView)
		addSubview(gridView)
		addSubview(blurView)
		addSubview(alphaView)
		
		NSLayoutConstraint.activate([
			scrollView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
			scrollView.heightAnchor.constraint(equalTo: scrollView.widthAnchor),
			scrollView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
			scrollView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
			
			gridView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
			gridView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
			gridView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
			gridView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
			
			blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
			blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
			blurView.topAnchor.constraint(equalTo: topAnchor),
			blurView.bottomAnchor.constraint(equalTo: bottomAnchor),
			
			alphaView.leadingAnchor.constraint(equalTo: leadingAnchor),
			alphaView.trailingAnchor.constraint(equalTo: trailingAnchor),
			alphaView.topAnchor.constraint(equalTo: topAnchor),
			alphaView.bottomAnchor.constraint(equalTo: bottomAnchor),
		])
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		let scrollFrame = scrollView.frame
		let scaleWidth = scrollFrame.width / image.size.width
		let scaleHeight = scrollFrame.height / image.size.height
		let minScale = max(scaleWidth, scaleHeight)
		
		scrollView.minimumZoomScale = minScale
		if isFirstLayout {
			scrollView.zoomScale = minScale
			isFirstLayout = false
		}
		
		if shape == .circle {
			scrollView.layer.cornerRadius = scrollView.bounds.width / 2
			gridView.layer.cornerRadius = gridView.bounds.width / 2
		}
		
		setUpMasks()
	}
	
	func setUpMasks() {
		let blurOuterPath = UIBezierPath(roundedRect: blurView.frame, cornerRadius: 0.0)
		let blurInnerPath: UIBezierPath
		switch shape {
		case .square:
			blurInnerPath = UIBezierPath(roundedRect: scrollView.frame, cornerRadius: 0.0)
		case .circle:
			blurInnerPath = UIBezierPath(ovalIn: scrollView.frame)
		}
		blurOuterPath.append(blurInnerPath)
		blurOuterPath.usesEvenOddFillRule = true
		
		let blurMask = CAShapeLayer()
		blurMask.fillRule = .evenOdd
		blurMask.path = blurOuterPath.cgPath
		
		let alphaMask = CAShapeLayer();
		alphaMask.fillRule = .evenOdd;
		alphaMask.path = blurOuterPath.cgPath;
		
		blurView.layer.mask = blurMask
		alphaView.layer.mask = alphaMask
	}
}
