import UIKit
import Kingfisher

extension UIImageView {
    func imageFromURL(path: String) {
        let isImageCached = ImageCache.default.imageCachedType(forKey: path)
        if isImageCached.cached, let image = ImageCache.default.retrieveImageInMemoryCache(forKey: path) {
            self.image = image
        } else {
            guard let url = URL(string: path) else { return }
            let resource = KF.ImageResource(downloadURL: url, cacheKey: path)
            self.kf.setImage(with: resource)
        }
    }

    func setImageColor(with color: UIColor) {
        let tintedImage = self.image?.withRenderingMode(.alwaysTemplate)
        tintedImage?.withTintColor(color)
        self.image = tintedImage
        self.tintColor = color
    }

}
