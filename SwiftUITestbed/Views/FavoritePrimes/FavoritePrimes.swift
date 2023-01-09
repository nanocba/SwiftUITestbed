import SwiftUI

struct FavoritePrimes: View {
    let store: FavoritePrimesStore

    var body: some View {
        Observing(store) { favoritePrimes in
            
        }
    }
}
