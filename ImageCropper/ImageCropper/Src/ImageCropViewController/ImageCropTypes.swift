import UIKit

/// Describes the shape used to frame a cropping area.
public enum ImageCropShape {
	case square
	case circle
}

public enum ImageCropResultType {
	case image
	case frame
}

/// Contains the result of an image crop.
public enum ImageCropResult {
	/// A result containing a cropped image.
	case image(UIImage)
	/// A result containing the frame by which to crop the image.
	case frame(CGRect)
}

public typealias ImageCropCompletionHandler = (ImageCropResult) -> Void
