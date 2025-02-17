import UIKit
import Kingfisher
import WebKit

final class FavoriteCell: UITableViewCell, Reusable, ViewConfiguration, WKNavigationDelegate {
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let mediaImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.isHidden = true
        webView.layer.cornerRadius = 10
        webView.clipsToBounds = true
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: FavoritesListModel) {
        titleLabel.text = model.title
        handleMediaLoading(urlString: model.mediaURL ?? "")
    }
    
    func configureViews() {
        selectionStyle = .none
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 12
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
        contentView.clipsToBounds = false
    }
    
    func setupViewHierarchy() {
        contentView.addSubview(mediaImageView)
        contentView.addSubview(webView)
        contentView.addSubview(activityIndicator)
        contentView.addSubview(titleLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            mediaImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            mediaImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            mediaImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            mediaImageView.heightAnchor.constraint(equalToConstant: 200),
            
            webView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            webView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            webView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            webView.heightAnchor.constraint(equalToConstant: 200),

            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: mediaImageView.centerYAnchor),

            titleLabel.topAnchor.constraint(equalTo: mediaImageView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(with apod: APODResponse) {
        titleLabel.text = apod.title
        handleMediaLoading(urlString: apod.url ?? "")
    }
    
    private func handleMediaLoading(urlString: String) {
        webView.isHidden = true
        mediaImageView.isHidden = true
        activityIndicator.startAnimating()
        
        if urlString.contains("youtube.com/embed/") {
            loadWebView(urlString)
        } else {
            loadImage(urlString)
        }
    }
    
    private func loadWebView(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            activityIndicator.stopAnimating()
            return
        }
        webView.isHidden = false
        webView.load(URLRequest(url: url))
    }

    private func loadImage(_ urlString: String) {
        if urlString.hasPrefix("https") {
            mediaImageView.kf.setImage(
                with: URL(string: urlString),
                placeholder: nil,
                completionHandler: { [weak self] _ in
                    DispatchQueue.main.async {
                        self?.mediaImageView.isHidden = false
                        self?.activityIndicator.stopAnimating()
                    }
                }
            )
        } else {
            mediaImageView.image = UIImage(named: "image_teste")
            mediaImageView.isHidden = false
            activityIndicator.stopAnimating()
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation?) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.webView.isHidden = false
        }
    }
}
