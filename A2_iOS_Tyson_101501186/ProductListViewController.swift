// Tyson Ward-Dicks - 101501186
// Lab Test 2 (Assignment) - COMP3097


import UIKit

class ProductListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let repository = ProductRepository()
    var products: [Product] = []
    var onProductSelected: ((Product) -> Void)?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        styleScreen()
        products = repository.fetchAllProducts()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        products = repository.fetchAllProducts()
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath)
        let product = products[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = product.name
        content.secondaryText = product.productDescription
        content.image = UIImage(systemName: iconName(for: product))
        content.imageProperties.tintColor = UIColor(red: 28 / 255, green: 74 / 255, blue: 132 / 255, alpha: 1.0)
        content.imageProperties.maximumSize = CGSize(width: 42, height: 42)
        content.textProperties.font = UIFont.boldSystemFont(ofSize: 18)
        content.secondaryTextProperties.color = UIColor.darkGray
        content.secondaryTextProperties.numberOfLines = 2
        content.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 18, bottom: 16, trailing: 18)
        cell.contentConfiguration = content
        var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
        backgroundConfig.backgroundColor = .white
        backgroundConfig.cornerRadius = 18
        backgroundConfig.strokeColor = UIColor(red: 191 / 255, green: 204 / 255, blue: 190 / 255, alpha: 1.0)
        backgroundConfig.strokeWidth = 1
        cell.backgroundConfiguration = backgroundConfig
        cell.selectionStyle = .default
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = products[indexPath.row]
        onProductSelected?(product)
        dismiss(animated: true)
    }

    @IBAction func doneTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }

    func styleScreen() {
        view.backgroundColor = UIColor(red: 232 / 255, green: 224 / 255, blue: 210 / 255, alpha: 1.0)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = 108
        doneButton.backgroundColor = UIColor(red: 32 / 255, green: 86 / 255, blue: 154 / 255, alpha: 1.0)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        doneButton.layer.cornerRadius = 14
        doneButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 18, bottom: 10, right: 18)
    }

    func iconName(for product: Product) -> String {
        let nameText = (product.name ?? "").lowercased()

        if nameText.contains("mug") || nameText.contains("coffee") {
            return "cup.and.saucer.fill"
        }
        if nameText.contains("notebook") {
            return "book.closed.fill"
        }
        if nameText.contains("lamp") {
            return "lamp.desk.fill"
        }
        if nameText.contains("bottle") {
            return "waterbottle.fill"
        }
        if nameText.contains("pillow") {
            return "bed.double.fill"
        }
        if nameText.contains("towel") {
            return "hands.sparkles.fill"
        }
        if nameText.contains("basket") {
            return "basket.fill"
        }
        if nameText.contains("cutting board") || nameText.contains("board") {
            return "fork.knife"
        }
        if nameText.contains("soap") {
            return "drop.fill"
        }
        if nameText.contains("yoga") || nameText.contains("mat") {
            return "figure.yoga"
        }
        return "shippingbox.fill"
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        12
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let spacer = UIView()
        spacer.backgroundColor = .clear
        return spacer
    }
}
