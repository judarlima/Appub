import UIKit

struct BeerCollectionViewModel {
  let beerImage: String
  let beerNameLabel: String
  let beerAbvLabel: String
}

class BeerListViewController: UICollectionViewController {
  
  private lazy var loadingView: LoadingView = {
    let view = LoadingView(frame: self.view.bounds)
    return view
  }()
  private var allBeers: [BeerCollectionViewModel] = []
  
  private lazy var router: BeerListRouter = {
    let router = BeerListRouter()
    router.viewController = self
    return router
  }()
  
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
    loadingView.show(on: self.view)
    self.interactor.beerList()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    loadingView.hide()
  }
  
  
  private func setupView() {
    guard let collectionView = collectionView else { return }
    collectionView.backgroundColor = .clear
    collectionView.contentInset = UIEdgeInsets(top: 23, left: 16, bottom: 10, right: 16)
  }
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  
  override func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
    return allBeers.count
  }
  
  override func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BeerCollectionViewCell",
                                                        for: indexPath) as? BeerCollectionViewCell
      else {
        return UICollectionViewCell()
    }
    let beerForIndex = allBeers[indexPath.row]
    cell.bind(viewModel: beerForIndex)
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    DispatchQueue.main.async { [weak self] in
      guard let controller = self else { return }
      controller.interactor.beer(at: indexPath.row)
      controller.loadingView.show(on: controller.view)
    }
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
  }
}

extension BeerListViewController: BeersListPresenter {
  
  func showBeerList(beers: [BeerCollectionViewModel]) {
    DispatchQueue.main.async {
      self.allBeers = beers
      self.collectionView?.reloadData()
      self.loadingView.hide()
    }
  }
  
  func showError(error: Error?) {
    self.showAlertMessage(message: error?.localizedDescription ?? "Erro Desconhecido.")
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
