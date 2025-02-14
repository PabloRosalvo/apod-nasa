import UIKit
import Kingfisher

extension UIImageView {
    
    func setImage(from urlString: String,
                  forceRefresh: Bool = false) {
        self.kf.indicatorType = .activity
        self.backgroundColor = .clear
        guard let url = URL(string: urlString) else {
            self.image = nil
            return
        }
        let options: KingfisherOptionsInfo = forceRefresh ? [.forceRefresh] : []
        
        self.kf.setImage(
            with: url,
            placeholder: nil,
            options: options
        ) { result in
            switch result {
            case .success:
                break
            case .failure:
                self.image = nil
            }
        }
    }
}
