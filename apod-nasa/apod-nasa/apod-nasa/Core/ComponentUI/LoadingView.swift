import UIKit

final class LoadingView: UIView {
    private static var shared: LoadingView?

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.color = .red
        return indicator
    }()

    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        isUserInteractionEnabled = false
        addSubview(backgroundView)
        addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    static func startLoading() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.connectedScenes
                .compactMap({ ($0 as? UIWindowScene)?.keyWindow })
                .first else { return }

            if shared == nil {
                shared = LoadingView(frame: window.bounds)
            }

            guard let loadingView = shared else { return }

            if loadingView.superview == nil {
                window.addSubview(loadingView)
            }

            loadingView.activityIndicator.startAnimating()
            loadingView.isHidden = false
        }
    }

    static func stopLoading() {
        DispatchQueue.main.async {
            guard let loadingView = shared else { return }
            loadingView.activityIndicator.stopAnimating()
            loadingView.isHidden = true
            loadingView.removeFromSuperview()
        }
    }
}
