import UIKit
import NVActivityIndicatorView

struct BeerCollectionViewModel {
  let beerImage: String
  let beerNameLabel: String
  let beerAbvLabel: String
}

class BeerListViewController: UIViewController {
  
  @IBOutlet private weak var collectionView: UICollectionView!
  
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
    collectionView.backgroundColor = .clear
    collectionView.contentInset = UIEdgeInsets(top: 23, left: 16, bottom: 10, right: 16)
  }
  
}

extension BeerListViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return allBeers.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BeerCollectionViewCell",
                                                            for: indexPath) as? BeerCollectionViewCell
          else {
            return UICollectionViewCell()
        }
        let beerForIndex = allBeers[indexPath.row]
        cell.bind(viewModel: beerForIndex)
        return cell
  }
}

extension BeerListViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    DispatchQueue.main.async { [weak self] in
      guard let controller = self else { return }
      controller.interactor.beer(at: indexPath.row)
    }
  }
}

extension BeerListViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let contentInset = collectionView.contentInset
    let rightSpace: CGFloat = 10
    let itemSize = (collectionView.frame.width - (contentInset.left + contentInset.right + rightSpace)) / 2
    
    return CGSize(width: itemSize, height: itemSize)
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
    DispatchQueue.main.async {
      self.allBeers = beers
      self.collectionView?.reloadData()
      NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
  }
  
  func showError(error: Error?) {
    self.showAlertMessage(message: error?.localizedDescription ?? "Erro Desconhecido.")
  }
}
