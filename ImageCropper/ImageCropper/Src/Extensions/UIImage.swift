import UIKit

extension UIImage {
	/// Returns a cropped sub image within a given frame of the source image.
	/// - Parameter frame: The frame used to extract a cropped sub image.
	/// - Returns: A `UIImage` cropped from an source image within a given frame.
	public func cropped(within frame: CGRect) -> UIImage? {
		guard
			let image = orientationNormalizedImaged,
			let cgImage = image.cgImage,
			let imageRef = cgImage.cropping(to: frame) else { return nil }
		return UIImage(
			cgImage: imageRef,
			scale: image.scale,
			orientation: image.imageOrientation
		)
	}
	
	/// Returns a new `UIImage` with an orientation normalized to upright.
	///
	/// If the source image is already upright, it is returned directly, unaltered.
	var orientationNormalizedImaged: UIImage? {
		guard imageOrientation != .up else { return self }
		UIGraphicsBeginImageContextWithOptions(size, false, scale)
		defer { UIGraphicsEndImageContext() }
		draw(in: CGRect(origin: .zero, size: size))
		return UIGraphicsGetImageFromCurrentImageContext()
	}
}
