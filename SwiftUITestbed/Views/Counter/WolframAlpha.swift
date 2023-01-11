import Foundation

private let wolframAlphaApiKey = "6H69Q3-828TKQJ4EP"

struct WolframAlphaResult: Decodable {
  let queryresult: QueryResult

  struct QueryResult: Decodable {
    let pods: [Pod]

    struct Pod: Decodable {
      let primary: Bool?
      let subpods: [SubPod]

      struct SubPod: Decodable {
        let plaintext: String
      }
    }

      var primaryPodPlainText: String? {
          pods
            .first(where: { $0.primary == .some(true) })?
            .subpods
            .first?
            .plaintext
      }
  }

    var primeResult: Int? {
        queryresult
            .primaryPodPlainText
            .flatMap(Int.init)
    }
}

func wolframAlpha(query: String) async throws -> WolframAlphaResult? {
    var components = URLComponents(string: "https://api.wolframalpha.com/v2/query")!
    components.queryItems = [
        URLQueryItem(name: "input", value: query),
        URLQueryItem(name: "format", value: "plaintext"),
        URLQueryItem(name: "output", value: "JSON"),
        URLQueryItem(name: "appid", value: wolframAlphaApiKey),
    ]

    let (data, _) = try await URLSession.shared.data(from: components.url(relativeTo: nil)!)
    return try? JSONDecoder().decode(WolframAlphaResult.self, from: data)
}
