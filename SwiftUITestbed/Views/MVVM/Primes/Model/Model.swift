import Foundation

class Model: ObservableObject {
    @Published var count: Int = 0
    @Published var favoritePrimes: [Int] = []    
}
