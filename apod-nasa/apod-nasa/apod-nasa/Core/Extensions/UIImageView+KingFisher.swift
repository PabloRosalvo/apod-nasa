import UIKit
import Kingfisher

extension UIImageView {
    
    func setImage(from urlString: String,
                  forceRefresh: Bool = false,
                  completion: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) {
        self.kf.indicatorType = .activity
        self.backgroundColor = .clear
        
        guard let url = URL(string: urlString) else {
            self.image = nil
            completion?(.failure(KingfisherError.requestError(reason: .emptyRequest)))
            return
        }
        
        let options: KingfisherOptionsInfo = forceRefresh ? [.forceRefresh] : []
        
        self.kf.setImage(
            with: url,
            placeholder: nil,
            options: options
        ) { result in
            switch result {
            case .success(let imageResult):
                completion?(.success(imageResult))
            case .failure(let error):
                self.image = nil
                completion?(.failure(error))
            }
        }
    }
    
    func setImage(_ urlString: String,
                  forceRefresh: Bool = false,
                  completion: (() -> Void)? = nil) {
        setImage(from: urlString, forceRefresh: forceRefresh) { _ in
            completion?()
        }
    }
}
