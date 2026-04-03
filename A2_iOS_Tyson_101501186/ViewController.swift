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
    @IBOutlet weak var addProductButton: UIButton!
    @IBOutlet weak var viewAllButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        styleScreen()
        repository.seedProductsIfNeeded()
        reloadProducts(showLastProduct: false)
    }

    func styleScreen() {
        view.backgroundColor = UIColor(red: 222 / 255, green: 233 / 255, blue: 245 / 255, alpha: 1.0)

        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search by name or description"

        [productIDLabel, nameLabel, descriptionLabel, priceLabel, providerLabel].forEach {
            $0?.backgroundColor = UIColor(red: 247 / 255, green: 250 / 255, blue: 253 / 255, alpha: 1.0)
            $0?.textColor = UIColor(red: 33 / 255, green: 52 / 255, blue: 77 / 255, alpha: 1.0)
            $0?.layer.cornerRadius = 12
            $0?.layer.masksToBounds = true
            $0?.layer.borderColor = UIColor(red: 188 / 255, green: 205 / 255, blue: 226 / 255, alpha: 1.0).cgColor
            $0?.layer.borderWidth = 1
            $0?.numberOfLines = 0
        }

        [previousButton, nextButton, addProductButton, viewAllButton].forEach {
            styleButton($0)
        }

        styleSecondaryButton(addProductButton)
        styleSecondaryButton(viewAllButton)
    }

    func styleButton(_ button: UIButton?) {
        button?.configuration = nil
        button?.backgroundColor = UIColor(red: 29 / 255, green: 78 / 255, blue: 137 / 255, alpha: 1.0)
        button?.setTitleColor(.white, for: .normal)
        button?.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        button?.titleLabel?.numberOfLines = 1
        button?.titleLabel?.adjustsFontSizeToFitWidth = true
        button?.titleLabel?.minimumScaleFactor = 0.8
        button?.layer.cornerRadius = 14
        button?.layer.masksToBounds = false
        button?.contentEdgeInsets = UIEdgeInsets(top: 11, left: 14, bottom: 11, right: 14)
        button?.layer.borderWidth = 0
        button?.layer.shadowColor = UIColor(red: 17 / 255, green: 41 / 255, blue: 74 / 255, alpha: 0.22).cgColor
        button?.layer.shadowOpacity = 1
        button?.layer.shadowOffset = CGSize(width: 0, height: 6)
        button?.layer.shadowRadius = 12
    }

    func styleSecondaryButton(_ button: UIButton?) {
        button?.backgroundColor = UIColor(red: 244 / 255, green: 248 / 255, blue: 252 / 255, alpha: 1.0)
        button?.setTitleColor(UIColor(red: 29 / 255, green: 78 / 255, blue: 137 / 255, alpha: 1.0), for: .normal)
        button?.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        button?.titleLabel?.adjustsFontSizeToFitWidth = true
        button?.titleLabel?.minimumScaleFactor = 0.8
        button?.layer.borderWidth = 1
        button?.layer.borderColor = UIColor(red: 162 / 255, green: 187 / 255, blue: 217 / 255, alpha: 1.0).cgColor
        button?.layer.shadowColor = UIColor(red: 17 / 255, green: 41 / 255, blue: 74 / 255, alpha: 0.10).cgColor
    }

    func displayProduct(_ product: Product) {
        applyCardText(to: productIDLabel, title: "Product ID", value: "\(product.productID)")
        applyCardText(to: nameLabel, title: "Name", value: product.name ?? "")
        applyCardText(to: descriptionLabel, title: "Description", value: product.productDescription ?? "", multiline: true)
        applyCardText(to: priceLabel, title: "Price", value: String(format: "$%.2f", product.price))
        applyCardText(to: providerLabel, title: "Provider", value: product.provider ?? "")
        updateNavigationButtons()
    }

    func applyCardText(to label: UILabel, title: String, value: String, multiline: Bool = false) {
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14, weight: .semibold),
            .foregroundColor: UIColor(red: 78 / 255, green: 102 / 255, blue: 132 / 255, alpha: 1.0)
        ]

        let valueAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: multiline ? 17 : 18, weight: .medium),
            .foregroundColor: UIColor(red: 27 / 255, green: 44 / 255, blue: 66 / 255, alpha: 1.0)
        ]

        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 3
        paragraph.paragraphSpacing = 6

        let text = NSMutableAttributedString(
            string: "  \(title)\n",
            attributes: titleAttributes.merging([.paragraphStyle: paragraph]) { _, new in new }
        )
        text.append(
            NSAttributedString(
                string: "  \(value)  ",
                attributes: valueAttributes.merging([.paragraphStyle: paragraph]) { _, new in new }
            )
        )
        label.attributedText = text
    }

    func updateNavigationButtons() {
        previousButton.isEnabled = currentIndex > 0
        nextButton.isEnabled = currentIndex < products.count - 1
        previousButton.alpha = previousButton.isEnabled ? 1.0 : 0.55
        nextButton.alpha = nextButton.isEnabled ? 1.0 : 0.55
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

    func showProduct(_ selectedProduct: Product) {
        products = repository.fetchAllProducts()

        if let selectedIndex = products.firstIndex(where: { $0.productID == selectedProduct.productID }) {
            currentIndex = selectedIndex
            displayProduct(products[currentIndex])
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAddProduct",
           let addProductViewController = segue.destination as? AddProductViewController {
            addProductViewController.onProductSaved = { [weak self] in
                self?.reloadProducts(showLastProduct: true)
            }
        } else if segue.identifier == "ShowProductList",
                  let productListViewController = segue.destination as? ProductListViewController {
            productListViewController.onProductSelected = { [weak self] product in
                self?.showProduct(product)
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
