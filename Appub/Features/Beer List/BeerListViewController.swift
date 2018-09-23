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
  
  override func viewDidLoad() {

    super.viewDidLoad()
    setupView()
    loadingView.show(on: self.view)
    AppubAPIWorker.sharedInstance.fetchAllBeers { (beers, error) in
      if let allBeers = beers {
        self.allBeers = allBeers.map { BeerCollectionViewModel(beerImage: $0.imageURL,
                                                               beerNameLabel: $0.name,
                                                               beerAbvLabel: String($0.abv)) }
        DispatchQueue.main.async {
          self.loadingView.hide()
          self.collectionView?.reloadData()
        }
      } else {
        print(error.debugDescription)
      }
    }
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
