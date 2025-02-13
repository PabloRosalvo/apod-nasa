import UIKit

final class LoadingView: UIView, ViewConfiguration {
    private static var shared: LoadingView?

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.color = .black
        return indicator
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureViews() {
        backgroundColor = .white
        layer.cornerRadius = 10
    }
    func setupViewHierarchy() {
        addSubview(activityIndicator)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    static func startLoading(in view: UIView) {
        if shared == nil {
            shared = LoadingView()
        }

        guard let loadingView = shared else { return }

        loadingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingView)

        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        loadingView.activityIndicator.startAnimating()
        loadingView.isHidden = false
    }

    static func stopLoading() {
        guard let loadingView = shared else { return }
        loadingView.activityIndicator.stopAnimating()
        loadingView.isHidden = true
        loadingView.removeFromSuperview()
    }
}
