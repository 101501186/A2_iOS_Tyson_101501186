import UIKit

class AddProductViewController: UIViewController, UITextViewDelegate {

    let repository = ProductRepository()
    var onProductSaved: (() -> Void)?

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
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

        [nameTextField, priceTextField, providerTextField].forEach {
            $0?.backgroundColor = .white
            $0?.layer.cornerRadius = 14
            $0?.layer.masksToBounds = true
            $0?.borderStyle = .roundedRect
        }

        descriptionTextView.backgroundColor = .white
        descriptionTextView.layer.cornerRadius = 14
        descriptionTextView.layer.masksToBounds = true
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor.systemGray3.cgColor
        descriptionTextView.font = UIFont.systemFont(ofSize: 17)
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 12, left: 10, bottom: 12, right: 10)
        descriptionTextView.textContainer.lineFragmentPadding = 0
        descriptionTextView.text = "Product Description"
        descriptionTextView.textColor = .placeholderText
        descriptionTextView.delegate = self

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
            let description = descriptionTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            let priceText = priceTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            let provider = providerTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            !name.isEmpty,
            !description.isEmpty,
            description != "Product Description",
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

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Product Description" {
            textView.text = ""
            textView.textColor = .label
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "Product Description"
            textView.textColor = .placeholderText
        }
    }
}
