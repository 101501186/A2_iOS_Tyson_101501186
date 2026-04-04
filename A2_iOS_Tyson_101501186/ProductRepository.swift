// Tyson Ward-Dicks - 101501186
// Lab Test 2 (Assignment) - COMP3097

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

    func searchProducts(byName searchText: String) -> [Product] {
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "productID", ascending: true)]
        let escapedSearchText = NSRegularExpression.escapedPattern(for: searchText)
        let wholeWordPattern = ".*\\b\(escapedSearchText)\\b.*"
        request.predicate = NSPredicate(
            format: "name MATCHES[c] %@ OR productDescription MATCHES[c] %@",
            wholeWordPattern,
            wholeWordPattern
        )

        do {
            return try context.fetch(request)
        } catch {
            print("Failed to search products: \(error)")
            return []
        }
    }

    func nextProductID() -> Int64 {
        return (fetchAllProducts().last?.productID ?? 0) + 1
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

    func addProduct(name: String, productDescription: String, price: Double, provider: String) {
        addProduct(
            productID: nextProductID(),
            name: name,
            productDescription: productDescription,
            price: price,
            provider: provider
        )
    }

    func seedProductsIfNeeded() {
        if !fetchAllProducts().isEmpty {
            return
        }

        addProduct(
            productID: 1,
            name: "Ceramic Coffee Mug",
            productDescription: "Simple 12-ounce mug for hot drinks",
            price: 9.99,
            provider: "Home Basics"
        )
        addProduct(
            productID: 2,
            name: "Notebook Set",
            productDescription: "Pack of three ruled notebooks for school or work",
            price: 7.49,
            provider: "Paper House"
        )
        addProduct(
            productID: 3,
            name: "Desk Lamp",
            productDescription: "Small LED desk lamp with adjustable neck",
            price: 24.99,
            provider: "Bright Living"
        )
        addProduct(
            productID: 4,
            name: "Water Bottle",
            productDescription: "Reusable stainless steel bottle for everyday use",
            price: 18.99,
            provider: "PureSip"
        )
        addProduct(
            productID: 5,
            name: "Throw Pillow",
            productDescription: "Soft decorative pillow for sofa or bed",
            price: 15.99,
            provider: "Cozy Home"
        )
        addProduct(
            productID: 6,
            name: "Kitchen Towels",
            productDescription: "Set of four cotton towels for kitchen cleanup",
            price: 11.99,
            provider: "CleanNest"
        )
        addProduct(
            productID: 7,
            name: "Laundry Basket",
            productDescription: "Lightweight plastic basket with side handles",
            price: 13.49,
            provider: "EasyCarry"
        )
        addProduct(
            productID: 8,
            name: "Cutting Board",
            productDescription: "Medium bamboo cutting board for meal prep",
            price: 16.75,
            provider: "Kitchen Grove"
        )
        addProduct(
            productID: 9,
            name: "Hand Soap",
            productDescription: "Liquid hand soap with fresh citrus scent",
            price: 4.99,
            provider: "Fresh Day"
        )
        addProduct(
            productID: 10,
            name: "Yoga Mat",
            productDescription: "Non-slip exercise mat for stretching and workouts",
            price: 22.99,
            provider: "FlexFit"
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
