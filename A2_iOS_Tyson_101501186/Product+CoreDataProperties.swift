// Tyson Ward-Dicks - 101501186
// Lab Test 2 (Assignment) - COMP3097

import Foundation
import CoreData

extension Product {

    @nonobjc class func fetchRequest() -> NSFetchRequest<Product> {
        NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged var productID: Int64
    @NSManaged var name: String?
    @NSManaged var productDescription: String?
    @NSManaged var price: Double
    @NSManaged var provider: String?
}

extension Product: Identifiable {
}
