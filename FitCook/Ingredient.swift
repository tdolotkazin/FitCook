import Foundation

class Ingredient {
    var name: String
    var weight: Int?
    var kcal: Int?
    var totalkCal: Int? {
        if let safeWeight = weight, let safeKcal = kcal {
            return safeWeight*safeKcal/100
        } else {
            return nil
        }
        
    }
    
    init(name: String) {
        self.name = name
    }
}
