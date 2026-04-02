import UIKit

class AddProductViewController: UIViewController {

    let repository = ProductRepository()
    var onProductSaved: (() -> Void)?

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var providerTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        styleScreen()
    }

    func styleScreen() {
        view.backgroundColor = UIColor(red: 232 / 255, green: 224 / 255, blue: 210 / 255, alpha: 1.0)

        [nameTextField, descriptionTextField, priceTextField, providerTextField].forEach {
            $0?.backgroundColor = .white
            $0?.layer.cornerRadius = 14
            $0?.layer.masksToBounds = true
            $0?.borderStyle = .roundedRect
        }

        cancelButton.backgroundColor = UIColor(red: 148 / 255, green: 84 / 255, blue: 72 / 255, alpha: 1.0)
        saveButton.backgroundColor = UIColor(red: 51 / 255, green: 128 / 255, blue: 82 / 255, alpha: 1.0)

        [cancelButton, saveButton].forEach {
            $0?.setTitleColor(.white, for: .normal)
            $0?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            $0?.layer.cornerRadius = 14
            $0?.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        }
    }

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
