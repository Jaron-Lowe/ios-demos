import NukeExtensions
import UIKit

final class GalleryViewController: UIViewController {

	@IBOutlet weak var collectionView: UICollectionView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "Image Gallery"
	}
}

extension GalleryViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		GalleryImage.all.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryItemCell.identifier, for: indexPath) as! GalleryItemCell
		
		let image = GalleryImage.all[indexPath.item]
		cell.configure(image: image)
		return cell
	}
}

extension GalleryViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let controller = storyboard?.instantiateViewController(withIdentifier: "image_detail") as? ImageDetailViewController else { return }
		let image = GalleryImage.all[indexPath.item]
		controller.image = image
		navigationController?.pushViewController(controller, animated: true)
	}
}

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let dimension = ((collectionView.bounds.width - 13) / 4)
		return CGSize(width: dimension, height: dimension)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		4
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		4
	}
}


final class GalleryItemCell: UICollectionViewCell {
	static let identifier = "GalleryItemCell"
	
	@IBOutlet weak var imageView: UIImageView!
	
	func configure(image: GalleryImage) {
		NukeExtensions.loadImage(
			with: URL(string: image.url),
			options: .init(transition: .fadeIn(duration: 0.33)),
			into: imageView
		)
	}
}
