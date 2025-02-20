import UIKit
import Combine

final class FavoritesViewController: UIViewController {
    
    private let viewModel: FavoritesViewModelProtocol
    private let contentView = FavoritesView()
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: FavoritesViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favoritos"
        setupBindings()
    }
    
    private func setupBindings() {
        viewModel.favoritesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] favorites in
                self?.contentView.updateFavorites(favorites)
            }
            .store(in: &cancellables)
        
        contentView.deleteActionPublisher
            .sink { [weak self] index in
                self?.viewModel.removeFavorite(at: index)
            }
            .store(in: &cancellables)
    }
}
