import UIKit

class ProductListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let repository = ProductRepository()
    var products: [Product] = []
    var onProductSelected: ((Product) -> Void)?

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
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
        cell.textLabel?.text = product.name
        cell.detailTextLabel?.text = product.productDescription
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
}
