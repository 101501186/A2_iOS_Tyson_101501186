import UIKit
import CoreData

class ProductRepository {

    private let context: NSManagedObjectContext

    init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
    }

    func fetchAllProducts() -> [Product] {
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "productID", ascending: true)]

        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch products: \(error)")
            return []
        }
    }

    func fetchFirstProduct() -> Product? {
        return fetchAllProducts().first
    }

    func addProduct(productID: Int64, name: String, productDescription: String, price: Double, provider: String) {
        let product = Product(context: context)
        product.productID = productID
        product.name = name
        product.productDescription = productDescription
        product.price = price
        product.provider = provider

        save()
    }

    func save() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}

