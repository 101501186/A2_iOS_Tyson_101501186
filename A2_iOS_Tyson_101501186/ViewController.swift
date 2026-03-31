import UIKit

class ViewController: UIViewController {

    let repository = ProductRepository()

    override func viewDidLoad() {
        super.viewDidLoad()
        repository.seedProductsIfNeeded()
    }
}


