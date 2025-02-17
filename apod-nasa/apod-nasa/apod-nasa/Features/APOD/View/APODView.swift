import UIKit
import Combine
import Kingfisher
import WebKit

final class APODView: UIView, WKNavigationDelegate, ViewConfiguration {
    
    @Published var apod: APODResponse?

    let favoriteButtonTapped = PassthroughSubject<Void, Never>()

    private var cancellables = Set<AnyCancellable>()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.color = .gray
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var mediaContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.separator.cgColor
        view.clipsToBounds = true
        view.isHidden = true
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.systemGray3.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.isHidden = true
        webView.navigationDelegate = self
        webView.layer.cornerRadius = 16
        webView.layer.borderWidth = 1
        webView.layer.borderColor = UIColor.systemGray3.cgColor
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = UIColor.label
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor.secondaryLabel
        label.numberOfLines = 0
        label.textAlignment = .justified
        return label
    }()

    private(set) lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            mediaContainerView, titleLabel, descriptionLabel, favoriteButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupViews()
        setupBindings()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        mediaContainerView.addSubview(imageView)
        mediaContainerView.addSubview(webView)
        mediaContainerView.addSubview(activityIndicator)

        setupConstraints()
    }
    
    private func setupBindings() {
        $apod
            .compactMap { $0 }  
            .sink { [weak self] apod in
                self?.updateUI(apod)
            }
            .store(in: &cancellables)

    }
    
    func updateUI(_ model: APODResponse) {
        titleLabel.text = model.title
        descriptionLabel.text = model.explanation
        handleMediaLoading(model.url ?? "")
    }
    
    @objc private func favoriteTapped() {
        favoriteButtonTapped.send(())
    }

    func updateFavoriteButton(isFavorite: Bool) {
        let imageName = isFavorite ? "star.fill" : "star"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
        favoriteButton.tintColor = isFavorite ? .yellow : .gray
    }
    
    private func handleMediaLoading(_ urlString: String) {
        if urlString.contains("youtube.com/embed/") {
            showVideo(urlString)
        } else {
            showImage(urlString)
        }
    }

    private func showVideo(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        webView.isHidden = true
        imageView.isHidden = true
        activityIndicator.startAnimating()
        webView.load(URLRequest(url: url))
    }

    private func showImage(_ urlString: String) {
        webView.isHidden = true
        imageView.isHidden = false
        activityIndicator.stopAnimating()
        mediaContainerView.isHidden = false
        favoriteButton.isHidden = false
        if urlString.contains("https") {
            imageView.setImage(from: urlString)
        } else {
            imageView.image = UIImage(named: urlString)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation?) {
        activityIndicator.stopAnimating()
        webView.isHidden = false
        mediaContainerView.isHidden = false
        favoriteButton.isHidden = false
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),

            mediaContainerView.widthAnchor.constraint(equalToConstant: 300),
            mediaContainerView.heightAnchor.constraint(equalToConstant: 300),

            imageView.widthAnchor.constraint(equalTo: mediaContainerView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: mediaContainerView.heightAnchor),

            webView.widthAnchor.constraint(equalTo: mediaContainerView.widthAnchor),
            webView.heightAnchor.constraint(equalTo: mediaContainerView.heightAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: mediaContainerView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: mediaContainerView.centerYAnchor)
        ])
    }
}
