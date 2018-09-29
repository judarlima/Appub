import UIKit
import NVActivityIndicatorView

class BeerListViewController: UIViewController {
  
  @IBOutlet private weak var collectionView: UICollectionView!
  
  private var beersDataSource: BeersDataSource?
  private var selectedIndexPath: IndexPath? = nil
  
  private var allBeers: [BeerCollectionViewModel] = []
  
  private lazy var router: BeerListRouter = {
    let router = BeerListRouter()
    router.viewController = self
    return router
  }()
  
  lazy var activityData = ActivityData()
  
  private lazy var interactor: BeersInteractor = {
    let interactor = BeersInteractor(gateway: BeersGateway(service: APIService()),
                                     presenter: self,
                                     router: self.router)
    return interactor
  }()
  
  //MARK: View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    self.interactor.beerList()
    NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
  }
  
  private func setupView() {
    collectionView.backgroundColor = .darkGray
    collectionView.contentInset = UIEdgeInsets(top: 23, left: 16, bottom: 10, right: 16)
  }
  
}

extension BeerListViewController {
  fileprivate func showAlertMessage(message: String) {
    let alertController = UIAlertController(title: "Atenção",
                                            message: message,
                                            preferredStyle: UIAlertControllerStyle.alert)
    let tryAgain = UIAlertAction(title: "Tentar Novamente", style: UIAlertActionStyle.default) { _ in
      self.interactor.beerList()
    }
    alertController.addAction(tryAgain)
    self.present(alertController, animated: true, completion: nil)
    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
  }
}

extension BeerListViewController: BeersListPresenter {
  
  func showBeerList(beers: [BeerCollectionViewModel]) {
    DispatchQueue.main.async { [weak self] in
      guard let controller = self else { return }
      controller.beersDataSource = BeersDataSource(collectionView: controller.collectionView, array: beers)
      controller.beersDataSource?.collectionItemSelectionHandler = { [weak self] indexPath in
        guard let strongSelf = self else { return }
        strongSelf.selectedIndexPath = indexPath
        strongSelf.interactor.beer(with: beers[indexPath.row].id)
      }
      controller.collectionView?.reloadData()
      NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
  }
  
  func showError(error: Error?) {
    self.showAlertMessage(message: error?.localizedDescription ?? "Erro Desconhecido.")
  }
}
