
import Foundation


/// An object that interracts with the Rebrickable web service.
///
struct Rebrickable_APIClient {
    
    
    /// The Rebrickable web service's base URL.
    ///
    /// URLs to specific endpoints can be constructed by appending the
    /// appropriate path component to this URL.
    ///
    private let rebrickableBaseURL = URL(string: "https://rebrickable.com/api/v3/")!
    
    
    /// The maximum number of items per page that should be requested from the
    /// web service when retrieving large amounts of items.
    ///
    /// Rebrickable API endpoints that return multiple results use a pagination
    /// system where the items are distributed on multiple pages.
    ///
    /// - Note: The Rebrickable API currently supports a maximum of 1000 items
    ///         per page on all endpoints.
    ///
    private let maxItemsPerPage = 1000
    
    
    /// The Rebrickable API key that should be used when making requests to the
    /// Rebrickable web service.
    ///
    /// The Rebrickable web service requires all requests to include an API key.
    /// API keys can be generated from your Rebrickable profile's settings page.
    ///
    private let apiKey: Rebrickable_APIKey
    
    
    /// Creates a new instance that uses the provided API key to make requests
    /// to the Rebrickable web service.
    ///
    /// - Parameter apiKey: The API key that should be used when making requests
    ///             to the Rebrickable web service.
    ///
    init(with apiKey: Rebrickable_APIKey) {
        
        self.apiKey = apiKey
    }
}


extension Rebrickable_APIClient {
    
    
    /// Fetches all the colors.
    ///
    /// This method issues as many requests to the Rebrickable API as required
    /// in order to fetch all available LEGO colors.
    ///
    /// The `batchProcessor` closure is called multiple times with a subset of
    /// the items as they become available, while the `completionHandler`
    /// closure is called at the very end.
    ///
    /// The Rebrickable API uses a pagination system where the items are
    /// distributed on multiple pages. This method starts by requesting the
    /// first page of results, then loads subsequent pages until all items are
    /// retrieved.
    ///
    /// Pages are requested with the highest possible number of items in order
    /// to minimize the number of requests.
    ///
    /// Terminates with a fatal error if an error occurs.
    ///
    /// - Parameter batchProcessor: A closure that gets called multiple times
    ///             with a subset of the items as they become available.
    ///
    /// - Parameter completionHandler: A closure that gets called at the very
    ///             end when all items have been loaded.
    ///
    func getAllColors(
        
        batchProcessor: @escaping ([Rebrickable_Color]) -> Void,
        completionHandler: @escaping () -> Void
        
    ) {
        
        print("[Rebrickable_APIClient] Loading colors")
        
        let loadStartTime = Date()
        
        iterativePageLoad(
            
            initialURL: buildURL(for: .lego_colors, with: [ .page_size: maxItemsPerPage ]),
            
            pageCompletionHandler: { (items: [Rebrickable_Color]) in
                
                print("[Rebrickable_APIClient] Loaded \(items.count) colors")
                
                batchProcessor(items)
            },
            
            globalCompletionHandler: {
                
                print("[Rebrickable_APIClient] Loaded all colors in \(Date().elapsedTimeSince(loadStartTime))")
                
                completionHandler()
            }
        )
    }
    
    
    /// Fetches all the parts.
    ///
    /// This method issues as many requests to the Rebrickable API as required
    /// in order to fetch all available LEGO parts.
    ///
    /// The `batchProcessor` closure is called multiple times with a subset of
    /// the items as they become available, while the `completionHandler`
    /// closure is called at the very end.
    ///
    /// The Rebrickable API uses a pagination system where the items are
    /// distributed on multiple pages. This method starts by requesting the
    /// first page of results, then loads subsequent pages until all items are
    /// retrieved.
    ///
    /// Pages are requested with the highest possible number of items in order
    /// to minimize the number of requests.
    ///
    /// Terminates with a fatal error if an error occurs.
    ///
    /// - Parameter batchProcessor: A closure that gets called multiple times
    ///             with a subset of the items as they become available.
    ///
    /// - Parameter completionHandler: A closure that gets called at the very
    ///             end when all items have been loaded.
    ///
    func getAllParts(
        
        batchProcessor: @escaping ([Rebrickable_Part]) -> Void,
        completionHandler: @escaping () -> Void
        
    ) {
        
        print("[Rebrickable_APIClient] Loading parts")
        
        let loadStartTime = Date()
        
        iterativePageLoad(
            
            initialURL: buildURL(for: .lego_parts, with: [ .page_size: maxItemsPerPage ]),
            
            pageCompletionHandler: { (items: [Rebrickable_Part]) in
                
                print("[Rebrickable_APIClient] Loaded \(items.count) parts")
                
                batchProcessor(items)
            },
            
            globalCompletionHandler: {
                
                print("[Rebrickable_APIClient] Loaded all parts in \(Date().elapsedTimeSince(loadStartTime))")
                
                completionHandler()
            }
        )
    }
}


private extension Rebrickable_APIClient {
    
    
    /// Loads all pages in a result list sequentially.
    ///
    /// Rebrickable API endpoints that return multiple results use a pagination
    /// system where the items are distributed on multiple pages. Use this
    /// method when you want to load all items across all pages. The type
    /// parameter refers to the type of items (e.g. colors, parts, etc) you want
    /// to load.
    ///
    /// Results for each page contain the URL to the next page. This method
    /// loads the provided initial URL, then loads subsequent pages until there
    /// is no next page.
    ///
    /// The `pageCompletionHandler` closure is called once for each page and
    /// takes the page's items, while the `globalCompletionHandler` closure is
    /// called after the last page has been loaded.
    ///
    /// Terminates with a fatal error if an error occurs.
    ///
    /// - Parameter initialURL: The URL of the first page to load.
    ///
    /// - Parameter pageCompletionHandler: A closure that gets called once for
    ///             each page and takes the page's items.
    ///
    /// - Parameter globalCompletionHandler: A closure that gets called after
    ///             the last page has been loaded.
    ///
    private func iterativePageLoad<Rebrickable_Object>(
        
        initialURL: URL,
        pageCompletionHandler: @escaping ([Rebrickable_Object]) -> Void,
        globalCompletionHandler: @escaping () -> Void
        
    ) where Rebrickable_Object: Decodable {
        
        let request = buildGETRequest(from: initialURL)
        
        execute(request) { (resultList: Rebrickable_ResultsList<Rebrickable_Object>) in
            
            pageCompletionHandler(resultList.results)
            
            if let nextPageURL = resultList.next {
                
                self.iterativePageLoad(
                    
                    initialURL: nextPageURL,
                    pageCompletionHandler: pageCompletionHandler,
                    globalCompletionHandler: globalCompletionHandler
                )
                
            } else {
                
                globalCompletionHandler()
            }
        }
    }
}


private extension Rebrickable_APIClient {
    
    
    /// Executes the provided request and decodes the JSON-encoded result into
    /// the provided type parameter.
    ///
    /// Terminates with a fatal error if an error occurs.
    ///
    /// - Parameter request: The request to execute.
    ///
    /// - Parameter completionHandler: A closure that takes an instance of the
    ///             type parameter decoded from the request's result.
    ///
    private func execute<ResultType>(
        
        _ request: URLRequest,
        completionHandler: @escaping (ResultType) -> Void
        
    ) where ResultType: Decodable {
        
        print("[Rebrickable_APIClient] Loading \(request.url?.absoluteString ?? "")")
        
        let loadStartTime = Date()
        
        URLSession.shared.dataTask(with: request) { (data, URLResponse, error) in
            
            print("[Rebrickable_APIClient] Loaded in \(Date().elapsedTimeSince(loadStartTime))")
            
            guard error == nil else {
                
                fatalError("[Rebrickable_APIClient] The data task returned an error: \(error!)")
            }
            
            guard (URLResponse as? HTTPURLResponse)?.statusCode == 200 else {
                
                fatalError("[Rebrickable_APIClient] Expected HTTP response with status code 200, got: \(String(describing: URLResponse))")
            }
            
            guard data != nil else {
                
                fatalError("[Rebrickable_APIClient] Response data is nil")
            }
            
            var decoded: ResultType
            
            do {
                
                decoded = try self.decode(from: data!)
                
            } catch {
                
                fatalError("[Rebrickable_APIClient] Failed to decode JSON: \(error). Input: \"\(String(data: data!, encoding: .utf8) ?? "<invalid utf8 string>")\"")
            }
            
            completionHandler(decoded)
            
        } .resume()
    }
    
    
    /// Decodes a given type from provided JSON-encoded data.
    ///
    /// - Parameter data: The JSON object to decode.
    ///
    /// - Returns: An instance of the provided type parameter decoded from the
    ///            provided data.
    ///
    private func decode<Type>(from data: Data) throws -> Type where Type: Decodable
    {
        let decodeStartTime = Date()
        
        defer {
            print("[Rebrickable_APIClient] Decoded in \(Date().elapsedTimeSince(decodeStartTime))")
        }
        
        return try JSONDecoder().decode(Type.self, from: data)
    }
}


private extension Rebrickable_APIClient {
    
    
    /// Builds a URL to an endpoint using the provided parameters.
    ///
    /// - Parameter route: The Rebrickable API endpoint.
    ///
    /// - Parameter parameters: A dictionary in which the keys are the route
    ///             parameters and the values are the parameter's values.
    ///
    /// - Returns: The URL to the provided endpoint with the provided
    ///            parameters.
    ///
    func buildURL(for route: Rebrickable_Route, with parameters: [Rebrickable_RouteParameter: Any]) -> URL {
        
        let url = URL(string: route.rawValue, relativeTo: rebrickableBaseURL)!
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        components!.queryItems = parameters.map { URLQueryItem(name: $0.key.rawValue, value: "\($0.value)") }
        
        return components!.url!
    }
    
    
    /// Builds a GET request from the provided URL.
    ///
    /// - Parameter url: The URL to use in the request.
    ///
    /// - Returns: A URL request to the provided URL with authentication
    ///            information.
    ///
    private func buildGETRequest(from url: URL) -> URLRequest {
        
        var request = URLRequest(url: url)
        
        addAuthentication(to: &request)
        
        return request
    }
    
    
    /// Adds authentication information to the provided request.
    ///
    /// - Parameter request: The request to modify with authentication
    ///             information.
    ///
    private func addAuthentication(to request: inout URLRequest) {
        
        request.addValue("key \(apiKey)", forHTTPHeaderField: "Authorization")
    }
}


/// Rebrickable API endpoints.
///
/// The elements in this enumeration represent the endpoints available on the
/// Rebrickable web service. The raw value of each element is the actual path
/// of the endpoint.
///
/// - Warning: Paths must not start with a slash.
///
enum Rebrickable_Route: String {
    
    case lego_colors = "lego/colors/"
    case lego_parts = "lego/parts/"
}


/// Rebrickable API URL parameters.
///
/// The elements in this enumeration represent the parameters that can be used
/// in URLs when making requests to the Rebrickable API. The raw value of each
/// element is the name of the parameter that should be used when building the
/// URL.
///
enum Rebrickable_RouteParameter: String {
    
    case page_size = "page_size"
    case page = "page"
}
