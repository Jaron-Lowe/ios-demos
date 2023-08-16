import UIKit
import SwiftUI

public struct XScrollView<Content: View>: UIViewRepresentable {
	public typealias VisibleAreaChangeHandler = (_ offset: CGPoint, _ visibleRect: CGRect) -> Void
	
	// MARK: Properties
	
	private let content: Content
	
	// MARK: Optional Parameters
	private(set) var onVisibleAreaChanged: VisibleAreaChangeHandler?
	
	// MARK: Initialization
	
	public init(@ViewBuilder content: @escaping () -> Content) {
		self.content = content()
	}
	
	// MARK: UIViewRepresentable
	
	public typealias UIViewType = UIScrollView
	
	public func makeUIView(context: Context) -> UIViewType {
		let view = UIScrollView()
		view.delegate = context.coordinator
		view.scrollsToTop = false
		view.isScrollEnabled = true
		view.showsVerticalScrollIndicator = false
		view.showsHorizontalScrollIndicator = false
		view.alwaysBounceVertical = true
		view.alwaysBounceHorizontal = true
		view.bouncesZoom = true
		view.minimumZoomScale = 0.36
		view.maximumZoomScale = 3.0
		view.clipsToBounds = false
		
		guard let hostedView = context.coordinator.hostingController.view else { return view }
		hostedView.translatesAutoresizingMaskIntoConstraints = true
		hostedView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		hostedView.frame = view.bounds
		view.addSubview(hostedView)
		
		return view
	}
	
	public func updateUIView(_ uiView: UIViewType, context: Context) {
		context.coordinator.hostingController.rootView = content
	}
	
	public func makeCoordinator() -> Coordinator {
		Coordinator(
			parent: self,
			hostingController: UIHostingController(rootView: content)
		)
	}
}

// MARK: - Coordinator

extension XScrollView {
	public class Coordinator: NSObject, UIScrollViewDelegate {
		// MARK: Properties
		
		let parent: XScrollView
		let hostingController: UIHostingController<Content>
		
		// MARK: Initialization
		
		init(parent: XScrollView, hostingController: UIHostingController<Content>) {
			self.parent = parent
			self.hostingController = hostingController
		}
		
		// MARK: UIScrollViewDelegate
		
		public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
			hostingController.view
		}
		
		public func scrollViewDidScroll(_ scrollView: UIScrollView) {
			parent.onVisibleAreaChanged?(
				scrollView.contentOffset,
				scrollView.convert(
					scrollView.bounds,
					to: hostingController.view
				)
			)
		}
		
		public func scrollViewDidZoom(_ scrollView: UIScrollView) {
			parent.onVisibleAreaChanged?(
				scrollView.contentOffset,
				scrollView.convert(
					scrollView.bounds,
					to: hostingController.view
				)
			)
		}
		
	}
}

// MARK: - Optional Modifiers
extension XScrollView {
	public func onVisibleAreaChanged(_ body: @escaping VisibleAreaChangeHandler) -> Self {
		restructured { $0.onVisibleAreaChanged = body }
	}
}
