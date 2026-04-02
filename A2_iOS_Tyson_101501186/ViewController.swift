import UIKit

class ViewController: UIViewController, UISearchBarDelegate {

    let repository = ProductRepository()
    var products: [Product] = []
    var currentIndex = 0

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var productIDLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var providerLabel: UILabel!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        repository.seedProductsIfNeeded()
        reloadProducts(showLastProduct: false)
    }

    func displayProduct(_ product: Product) {
        productIDLabel.text = "Product ID: \(product.productID)"
        nameLabel.text = "Name: \(product.name ?? "")"
        descriptionLabel.text = "Description: \(product.productDescription ?? "")"
        priceLabel.text = String(format: "Price: $%.2f", product.price)
        providerLabel.text = "Provider: \(product.provider ?? "")"
        updateNavigationButtons()
    }

    func updateNavigationButtons() {
        previousButton.isEnabled = currentIndex > 0
        nextButton.isEnabled = currentIndex < products.count - 1
    }

    func reloadProducts(showLastProduct: Bool) {
        products = repository.fetchAllProducts()

        guard !products.isEmpty else {
            updateNavigationButtons()
            return
        }

        currentIndex = showLastProduct ? products.count - 1 : 0
        displayProduct(products[currentIndex])
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAddProduct",
           let addProductViewController = segue.destination as? AddProductViewController {
            addProductViewController.onProductSaved = { [weak self] in
                self?.reloadProducts(showLastProduct: true)
            }
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            return
        }

        let results = repository.searchProducts(byName: searchText)

        if let firstMatch = results.first {
            products = results
            currentIndex = 0
            displayProduct(firstMatch)
        } else {
            let alert = UIAlertController(
                title: "No Results",
                message: "No product found with that name.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }

        searchBar.resignFirstResponder()
    }
}
