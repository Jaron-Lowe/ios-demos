import NukeExtensions
import UIKit

final class ImageDetailViewController: UIViewController {
	
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var urlLabel: UILabel!
	@IBOutlet weak var dimensionsLabel: UILabel!
	
	var image: GalleryImage?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "Image Details"
		
		guard let image else { return }
		NukeExtensions.loadImage(
			with: URL(string: image.url),
			options: .init(transition: .fadeIn(duration: 0.33)),
			into: imageView
		) { [weak self] result in
			switch result {
			   case.success(let response):
				self?.dimensionsLabel.text = "\(Int(response.image.size.width)) x \(Int(response.image.size.width))"
			   case .failure(let error):
				   print("---", error.localizedDescription)
			   }
		   }
		
		urlLabel.text = image.url
	}
}
