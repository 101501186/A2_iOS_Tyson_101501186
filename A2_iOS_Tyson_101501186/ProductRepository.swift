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

    func seedProductsIfNeeded() {
        if !fetchAllProducts().isEmpty {
            return
        }

        addProduct(
            productID: 1,
            name: "iPhone 15",
            productDescription: "Apple smartphone with 128GB storage",
            price: 999.99,
            provider: "Apple"
        )
        addProduct(
            productID: 2,
            name: "Galaxy S24",
            productDescription: "Samsung smartphone with AMOLED display",
            price: 949.99,
            provider: "Samsung"
        )
        addProduct(
            productID: 3,
            name: "iPad Air",
            productDescription: "Apple tablet for school and entertainment",
            price: 799.99,
            provider: "Apple"
        )
        addProduct(
            productID: 4,
            name: "MacBook Air",
            productDescription: "Lightweight laptop with M-series chip",
            price: 1399.99,
            provider: "Apple"
        )
        addProduct(
            productID: 5,
            name: "Surface Laptop",
            productDescription: "Microsoft laptop for productivity tasks",
            price: 1299.99,
            provider: "Microsoft"
        )
        addProduct(
            productID: 6,
            name: "AirPods Pro",
            productDescription: "Wireless earbuds with noise cancellation",
            price: 329.99,
            provider: "Apple"
        )
        addProduct(
            productID: 7,
            name: "Sony WH-1000XM5",
            productDescription: "Over-ear headphones with premium sound",
            price: 499.99,
            provider: "Sony"
        )
        addProduct(
            productID: 8,
            name: "Apple Watch",
            productDescription: "Smartwatch for health and notifications",
            price: 559.99,
            provider: "Apple"
        )
        addProduct(
            productID: 9,
            name: "Kindle Paperwhite",
            productDescription: "E-reader with glare-free display",
            price: 219.99,
            provider: "Amazon"
        )
        addProduct(
            productID: 10,
            name: "GoPro Hero",
            productDescription: "Action camera for outdoor recording",
            price: 449.99,
            provider: "GoPro"
        )
    }

    func save() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}
