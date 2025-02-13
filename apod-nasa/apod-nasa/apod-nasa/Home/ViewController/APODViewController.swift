import UIKit
import Combine

class APODViewController: UIViewController {
    
    private let viewModel: APODViewModelProtocol
    private lazy var contentView: APODView = APODView()
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: APODViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
    
    override func loadView() {
        self.view = contentView
    }

    private func setupBindings() {
        viewModel.titleText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] title in
                self?.contentView.titleText = title
            }
            .store(in: &cancellables)

        viewModel.descriptionText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] description in
                self?.contentView.descriptionText = description
            }
            .store(in: &cancellables)

        viewModel.imageUrlText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] imageUrl in
                self?.contentView.mediaURLText = imageUrl
            }
            .store(in: &cancellables)

        viewModel.isFavorite
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isFavorite in
                self?.contentView.updateFavoriteButton(isFavorite: isFavorite)
            }
            .store(in: &cancellables)

        contentView.actionButtonTapped
            .sink { [weak self] in
                self?.viewModel.primaryButtonTapped.send(())
            }
            .store(in: &cancellables)

        contentView.favoriteButtonTapped
            .sink { [weak self] in
                self?.viewModel.favoriteButtonTapped.send(())
            }
            .store(in: &cancellables)
    }

}
