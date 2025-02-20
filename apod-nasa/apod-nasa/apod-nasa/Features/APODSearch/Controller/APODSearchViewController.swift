import UIKit
import Combine

final class APODSearchViewController: UIViewController {
    
    private let viewModel: APODSearchViewModelProtocol
    private let contentView = APODSearchView()
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: APODSearchViewModelProtocol) {
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
        title = "Buscar APOD"
        setupBindings()
    }
    
    private func setupBindings() {
        contentView.searchButtonTapped
            .sinkToMainThread { [weak self] selectedDate in
                self?.viewModel.fetchAPOD(for: selectedDate)
            }
            .store(in: &cancellables)
        
        viewModel.apodPublisher
            .sinkToMainThread { [weak self] apod in
                self?.contentView.update(with: apod)
            }
            .store(in: &cancellables)
        
        viewModel.isError
            .sinkToMainThread { [weak self] isError, date in
                guard let self = self, isError else { return }
                
                let errorModal = ErrorModalView(
                    message: "Falha ao buscar os dados.",
                    retryAction: { self.viewModel.fetchAPOD(for: date) }
                )
                errorModal.show(in: self.view)
            }
            .store(in: &cancellables)
    }

}
