import SwiftUI

struct ListingsContentView: View {
    @StateObject private var favoritesModel = FavoritesModel()

    var body: some View {
        ListingsView()
            .environmentObject(favoritesModel)
    }
}
