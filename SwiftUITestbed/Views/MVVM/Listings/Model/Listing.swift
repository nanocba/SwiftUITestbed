import Foundation

struct Listing: Equatable, Identifiable {
    let id: UUID
    var title: String
    var address: Address
    var price: Double
    var parties: [Party]

    struct Address: Equatable {
        var streetName: String
        var state: String
        var city: String
        var zipCode: String

        var addressText: String {
            [streetName, city, state, zipCode]
                .filter { !$0.isEmpty }
                .joined(separator: ", ")
        }
    }
}

extension Listing {
    var listingTitle: String {
        !title.isEmpty ? title : address.addressText 
    }
}

extension Array where Element == Listing {
    static let all: Self = [
        .init(
            id: UUID(),
            title: "Listing 1",
            address: .init(
                streetName: "Infinite Loop 345",
                state: "California",
                city: "San Francisco",
                zipCode: "90210"
            ),
            price: 110000,
            parties: []
        ),
        .init(
            id: UUID(),
            title: "Listing 2",
            address: .init(
                streetName: "Park Avenue 147",
                state: "California",
                city: "San Francisco",
                zipCode: "90008"
            ),
            price: 483000,
            parties: []
        ),
        .init(
            id: UUID(),
            title: "Listing 3",
            address: .init(
                streetName: "Roak 8209",
                state: "Texas",
                city: "Austin",
                zipCode: "10025"
            ),
            price: 204000,
            parties: []
        ),
        .init(
            id: UUID(),
            title: "Listing 4",
            address: .init(
                streetName: "Main Street 20",
                state: "Colorado",
                city: "Denver",
                zipCode: "10025"
            ),
            price: 204000,
            parties: []
        )
    ]
}
