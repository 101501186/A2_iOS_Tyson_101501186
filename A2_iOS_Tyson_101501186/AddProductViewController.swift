import UIKit

class AddProductViewController: UIViewController {

    let repository = ProductRepository()
    var onProductSaved: (() -> Void)?

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var providerTextField: UITextField!

    @IBAction func cancelTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }

    @IBAction func saveTapped(_ sender: UIButton) {
        guard
            let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            let description = descriptionTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            let priceText = priceTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            let provider = providerTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            !name.isEmpty,
            !description.isEmpty,
            !priceText.isEmpty,
            !provider.isEmpty,
            let price = Double(priceText)
        else {
            let alert = UIAlertController(
                title: "Missing Information",
                message: "Please enter a name, description, price, and provider.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        repository.addProduct(
            name: name,
            productDescription: description,
            price: price,
            provider: provider
        )

        onProductSaved?()
        dismiss(animated: true)
    }
}
