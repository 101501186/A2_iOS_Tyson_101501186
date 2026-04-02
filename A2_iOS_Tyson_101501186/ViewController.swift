import UIKit

class ViewController: UIViewController {

    let repository = ProductRepository()
    var products: [Product] = []
    var currentIndex = 0

    @IBOutlet weak var productIDLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var providerLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        repository.seedProductsIfNeeded()
        products = repository.fetchAllProducts()

        if let firstProduct = products.first {
            displayProduct(firstProduct)
        }
    }

    func displayProduct(_ product: Product) {
        productIDLabel.text = "Product ID: \(product.productID)"
        nameLabel.text = "Name: \(product.name ?? "")"
        descriptionLabel.text = "Description: \(product.productDescription ?? "")"
        priceLabel.text = String(format: "Price: $%.2f", product.price)
        providerLabel.text = "Provider: \(product.provider ?? "")"
    }

    @IBAction func nextProductTapped(_ sender: UIButton) {
        if currentIndex < products.count - 1 {
            currentIndex += 1
            displayProduct(products[currentIndex])
        }
    }

    @IBAction func previousProductTapped(_ sender: UIButton) {
        if currentIndex > 0 {
            currentIndex -= 1
            displayProduct(products[currentIndex])
        }
    }
}
