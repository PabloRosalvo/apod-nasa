import UIKit
import Combine

class APODViewController: UIViewController {
    
    private let viewModel: APODViewModelProtocol
    
    private lazy var contentView: APODView = {
        let contentView = APODView()
        return contentView
    }()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: APODViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "APOD"
        setupBindings()
    }
    
    override func loadView() {
        self.view = contentView
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
    
    private func setupBindings() {
        viewModel.apod
            .sinkToMainThread { [weak self] apod in
                self?.contentView.apod = apod
            }
            .store(in: &cancellables)
        
        viewModel.isFavorite
            .sinkToMainThread { [weak self] isFavorite in
                self?.contentView.updateFavoriteButton(isFavorite: isFavorite)
            }
            .store(in: &cancellables)
        
        contentView.favoriteButtonTapped
            .sinkToMainThread { [weak self] in
                self?.viewModel.favoriteButtonTapped.send(())
            }
            .store(in: &cancellables)
        
        viewModel.isLoading
            .sinkToMainThread { isLoading in
                isLoading ? LoadingView.startLoading() : LoadingView.stopLoading()
            }
            .store(in: &cancellables)
        
        viewModel.isError
            .sinkToMainThread { [weak self] isError in
                guard let self = self, isError else { return }
                
                let errorModal = ErrorModalView(
                    message: "Falha ao buscar os dados.",
                    retryAction: { self.viewModel.viewWillAppear() }
                )
                errorModal.show(in: self.view)
            }
            .store(in: &cancellables)
    }
    
}
