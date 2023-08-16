import ComposableArchitecture
import SwiftUI

@available(iOS 16, *)
struct CropView: View {
	private let store: ImageCropStore
	
	init(store: ImageCropStore) {
		self.store = store
	}
	
	var body: some View {
		WithViewStore(store, observe: { $0 }) { viewStore in
			GeometryReader { proxy in
				let cropSize = cropSize(proxy: proxy)
				let clipShape = clipShape(cropShape: viewStore.shape)
				ZStack {
					ScrollViewReader { scrollProxy in
						XScrollView {
							Image(uiImage: viewStore.image)
						}
						.onVisibleAreaChanged { _, visibleArea in
							viewStore.send(.cropEdit)
							print("---", visibleArea)
						}
						.frame(width: cropSize, height: cropSize)
						.overlay(
							clipShape
								.stroke(Color(uiColor: .secondarySystemBackground), lineWidth: 2)
						)
					}
					Color(uiColor: .systemBackground).opacity(0.6)
						.reverseMask {
							clipShape
								.frame(width: cropSize, height: cropSize)
						}
						.allowsHitTesting(false)
						.opacity(viewStore.isEditing ? 1.0 : 0.0)
						.animation(.default, value: viewStore.isEditing)
					Color.clear
						.background(.regularMaterial)
						.reverseMask {
							clipShape
								.frame(width: cropSize, height: cropSize)
						}
						.allowsHitTesting(false)
						.opacity(viewStore.isEditing ? 0.0 : 1.0)
						.animation(.default, value: viewStore.isEditing)
				}
				.ignoresSafeArea()
				.navigationTitle("Crop")
			}
			.onAppear {
				viewStore.send(.viewDidLoad)
			}
		}
	}
	
	func cropSize(proxy: GeometryProxy) -> CGFloat {
		min(proxy.size.width, proxy.size.height) * 0.9
	}
	
	func clipShape(cropShape: ImageCropShape) -> some Shape {
		switch cropShape {
		case .square:
			return AnyShape(Rectangle())
		case .circle:
			return AnyShape(Circle())
		}
	}
}

extension View {
	@available(iOS 15, *) @inlinable
	public func reverseMask<Mask: View>(alignment: Alignment = .center, @ViewBuilder _ mask: () -> Mask) -> some View {
		self.mask {
			Rectangle()
				.overlay(alignment: alignment) {
					mask()
						.blendMode(.destinationOut)
				}
		}
	}
}


struct CropView_Previews: PreviewProvider {
	static var previews: some View {
		if #available(iOS 16, *) {
			CropView(store: .init(
				initialState: .init(
					image: UIImage(named: "Horizontal.jpg")!,
					shape: .circle,
					resultType: .frame
				),
				reducer: {
					ImageCropReducer(completion: { _ in })
				}
			))
		}
		else {
			EmptyView()
		}
	}
}
