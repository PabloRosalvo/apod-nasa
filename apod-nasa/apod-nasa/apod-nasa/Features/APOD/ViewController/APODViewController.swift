import UIKit
import Combine

class APODViewController: UIViewController {
    
    private let viewModel: APODViewModelProtocol
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var contentView = APODView()
    
    init(viewModel: APODViewModelProtocol) {
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
        title = "APOD"
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
    
    private func setupBindings() {
        viewModel.apod
            .sinkToMainThread { [weak self] in self?.contentView.apod = $0 }
            .store(in: &cancellables)
        
        viewModel.isFavorite
            .sinkToMainThread { [weak self] in self?.contentView.updateFavoriteButton(isFavorite: $0) }
            .store(in: &cancellables)
        
        contentView.favoriteButtonTapped
            .sinkToMainThread { [weak self] in self?.viewModel.favoriteButtonTapped.send(()) }
            .store(in: &cancellables)
        
        viewModel.isLoading
            .sinkToMainThread { $0 ? LoadingView.startLoading() : LoadingView.stopLoading() }
            .store(in: &cancellables)
        
        viewModel.isError
            .sinkToMainThread { [weak self] isError in
                guard let self = self, isError else { return }
                self.showErrorModal()
            }
            .store(in: &cancellables)
    }
    
    private func showErrorModal() {
        let errorModal = ErrorModalView(
            message: "Falha ao buscar os dados.",
            retryAction: { self.viewModel.viewWillAppear() }
        )
        errorModal.show(in: self.view)
    }
}
