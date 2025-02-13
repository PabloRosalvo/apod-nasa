import UIKit
import Kingfisher

extension UIImageView {
    func setImage(from urlString: String,
                  forceRefresh: Bool = false,
                  placeholder: UIImage? = nil,
                  errorImage: UIImage? = UIImage(systemName: "xmark.octagon.fill")) {
        guard let url = URL(string: urlString) else {
            self.image = errorImage
            return
        }
        
        let options: KingfisherOptionsInfo = forceRefresh ? [.forceRefresh] : []
        self.kf.setImage(
            with: url,
            placeholder: placeholder,
            options: options
        ) { result in
            switch result {
            case .success:
                break
            case .failure:
                self.image = errorImage
            }
        }
    }
}
