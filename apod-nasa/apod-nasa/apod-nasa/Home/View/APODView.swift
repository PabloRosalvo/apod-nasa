import UIKit
import Combine
import Kingfisher
import WebKit

final class APODView: UIView {
    
    @Published var titleText: String?
    @Published var descriptionText: String?
    @Published var mediaURLText: String?
    
    let actionButtonTapped = PassthroughSubject<Void, Never>()
    let favoriteButtonTapped = PassthroughSubject<Void, Never>()

    private var cancellables = Set<AnyCancellable>()

    private lazy var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.systemGray6.cgColor,
            UIColor.systemGray4.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        return gradient
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
        view.layer.borderColor = UIColor.systemGray3.cgColor
        view.clipsToBounds = true
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
        return imageView
    }()
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.isHidden = true
        webView.layer.cornerRadius = 16
        webView.layer.borderWidth = 1
        webView.layer.borderColor = UIColor.systemGray3.cgColor
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = UIColor.darkGray
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor.gray
        label.numberOfLines = 0
        label.textAlignment = .justified
        return label
    }()

    private(set) lazy var actionButton: UIButton = {
        let button = UIButton()
        button.setTitle("See More information", for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private(set) lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            mediaContainerView, titleLabel, descriptionLabel, actionButton, favoriteButton
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    private func setupViews() {
        layer.insertSublayer(gradientLayer, at: 0)

        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        mediaContainerView.addSubview(imageView)
        mediaContainerView.addSubview(webView)

        setupConstraints()
    }
    
    private func setupBindings() {
        $titleText
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: titleLabel)
            .store(in: &cancellables)

        $descriptionText
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: descriptionLabel)
            .store(in: &cancellables)

        $mediaURLText
            .compactMap { $0 }
            .sink { [weak self] urlString in
                self?.handleMediaLoading(urlString)
            }
            .store(in: &cancellables)

        actionButton
            .addAction(UIAction { [weak self] _ in
                self?.actionButtonTapped.send(())
            }, for: .touchUpInside)
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
        webView.isHidden = false
        imageView.isHidden = true
        webView.load(URLRequest(url: url))
    }

    private func showImage(_ urlString: String) {
        webView.isHidden = true
        imageView.isHidden = false
        imageView.setImage(from: urlString, placeholder: UIImage(named: "placeholder"))
    }

    private func setupConstraints() {
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

            actionButton.widthAnchor.constraint(equalToConstant: 250),
            actionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
