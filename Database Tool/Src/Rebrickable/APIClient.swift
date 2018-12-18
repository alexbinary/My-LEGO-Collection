
import Foundation


/// An object that interracts with the Rebrickable web service.
///
struct Rebrickable_APIClient {
    
    
    /// The Rebrickable web service's base URL.
    ///
    /// URLs to specific endpoints can be constructed by appending the appropriate path component to this URL.
    ///
    private let rebrickableBaseURL = URL(string: "https://rebrickable.com/api/v3/")!
    
    
    /// The maximum number of items per page that should be requested from the API.
    ///
    /// Rebrickable API endpoints that return multiple results use a pagination system where the items are split into multiple pages.
    ///
    /// - Note: The Rebrickable API currently supports a maximum of 1000 items per page on all endpoints.
    ///
    private let maxItemsPerPage = 1000
    
    
    /// The Rebrickable API key.
    ///
    /// The Rebrickable webservice requires all requests to include an API key.
    /// This property configures the API key that should be used when issuing requests to the Rebrickable webservice.
    ///
    /// - Note: API keys can be generated from your Rebrickable profile's settings page.
    ///
    private let apiKey: Rebrickable_APIKey
    
    
    /// Creates a new instance with the provided API key.
    ///
    /// The provided API key is used for all requests made by this client.
    ///
    /// - Note: API keys can be generated from your Rebrickable profile's settings page.
    ///
    /// - Parameter apiKey: The API key that should be used when issuing requests to the Rebrickable webservice.
    ///
    init(with apiKey: Rebrickable_APIKey) {
        
        self.apiKey = apiKey
    }
}


extension Rebrickable_APIClient {
    
    
    /// Fetches all the colors.
    ///
    /// This method issues multiple requests to the Rebrickable API to fetch all available colors.
    ///
    /// The `batchProcessor` closure is called multiple time with a subset of the items as they become available,
    /// while the `completionHandler` closure is called at the very end.
    ///
    /// The Rebrickable API uses a pagination system where the colors are split into multiple pages.
    /// This method requests pages with the highest number of items possible and loads each page sequentially.
    ///
    /// Terminates with a fatal error if any error occurs.
    ///
    /// - Parameter batchProcessor: A closure that gets called multiple times with a subset of the items as they become available.
    /// - Parameter completionHandler: A closure that gets called at the very end when all colors have been loaded.
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
    /// This method issues multiple requests to the Rebrickable API to fetch all available parts.
    ///
    /// The `batchProcessor` closure is called multiple time with a subset of the items as they become available,
    /// while the `completionHandler` closure is called at the very end.
    ///
    /// The Rebrickable API uses a pagination system where the parts are split into multiple pages.
    /// This method requests pages with the highest number of items possible and loads each page sequentially.
    ///
    /// Terminates with a fatal error if any error occurs.
    ///
    /// - Parameter batchProcessor: A closure that gets called multiple times with a subset of the items as they become available.
    /// - Parameter completionHandler: A closure that gets called at the very end when all parts have been loaded.
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


extension Rebrickable_APIClient {
    
    
    /// Loads all pages in a result list sequentially.
    ///
    /// Rebrickable API endpoints that return multiple results use a pagination system where the items are split into multiple pages.
    /// Use this method when you want to load all items across all pages. The generic type is the type of items (e.g. sets, parts, etc) you want to load.
    ///
    /// Results for each page of data contain the URL to the next page.
    /// This method loads the provided initial URL, then loads the next page, and repeats until the URL to the next page becomes null.
    ///
    /// The `pageCompletionHandler` closure is called once for each page of results and takes the page's items,
    /// while the `globalCompletionHandler` closure is called at the very end.
    ///
    /// Terminates with a fatal error if any error occurs.
    ///
    /// - Parameter initialURL: The URL of the first page to load.
    /// - Parameter pageCompletionHandler: A closure that gets called once for each page of results and takes the page's items.
    /// - Parameter globalCompletionHandler: A closure that gets called at the very end after all pages have been loaded.
    ///
    func iterativePageLoad<Rebrickable_Object>(
        
        initialURL: URL,
        pageCompletionHandler: @escaping ([Rebrickable_Object]) -> Void,
        globalCompletionHandler: @escaping () -> Void
        
    ) where Rebrickable_Object: Decodable {
        
        let request = buildGETRequest(from: initialURL)
        
        execute(request) { (resultList: Rebrickable_ResultsList<Rebrickable_Object>) in
            
            pageCompletionHandler(resultList.results)
            
            if let nextPageURL = resultList.next {
                
                self.iterativePageLoad(initialURL: nextPageURL, pageCompletionHandler: pageCompletionHandler, globalCompletionHandler: globalCompletionHandler)
                
            } else {
                
                globalCompletionHandler()
            }
        }
    }
}


private extension Rebrickable_APIClient {
    
    
    /// Executes the provided request, returning the JSON-decoded result.
    ///
    /// This method executes the provided requests, then attempts to JSON-decode the result into the provided type.
    ///
    /// Terminates with a fatal error if any error occurs.
    ///
    /// - Parameter request: The request to execute.
    /// - Parameter completionHandler: A closure that takes an instance of the generic type that corresponds to the request's result.
    ///
    private func execute<ResultType>(
        
        _ request: URLRequest,
        completionHandler: @escaping (ResultType) -> Void
        
    ) where ResultType: Decodable {
        
        print("[Rebrickable_APIClient] Loading \(request.url!.absoluteString)")
        
        let loadStartTime = Date()
        
        URLSession.shared.dataTask(with: request) { (data, URLResponse, error) in
            
            print("[Rebrickable_APIClient] Loaded in \(Date().elapsedTimeSince(loadStartTime))")
            
            guard error == nil else {
                
                fatalError("🚫 [Rebrickable_APIClient] data task returned an error: \(error!)")
            }
            
            guard (URLResponse as? HTTPURLResponse)?.statusCode == 200 else {
                
                fatalError("🚫 [Rebrickable_APIClient] expected HTTP status code to be 200. Response: \(String(describing: URLResponse))")
            }
            
            guard data != nil else {
                
                fatalError("🚫 [Rebrickable_APIClient] data is nil")
            }
            
            var decoded: ResultType
            
            do {
                
                decoded = try self.decode(from: data!)
                
            } catch {
                
                fatalError("🚫 [Rebrickable_APIClient] JSON decode failed: \(error)")
            }
            
            completionHandler(decoded)
            
        } .resume()
    }
    
    
    /// Decodes a given type from provided JSON-encoded data.
    ///
    /// - Parameter data: The data to decode from.
    ///
    /// - Returns: An instance of the provided type that represents the provided data.
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
    /// - Parameter parameters: A dictionary in which each key identifies a route parameter and each value represents the value of the corresponding parameter.
    ///
    /// - Returns: The URL to the provided endpoint with the provided parameters.
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
    /// - Returns: A URL request to the provided URL that includes all necessary data, including authentication.
    ///
    private func buildGETRequest(from url: URL) -> URLRequest {
        
        var request = URLRequest(url: url)
        
        addAuthentication(to: &request)
        
        return request
    }
    
    
    /// Adds authentication information to the provided request.
    ///
    /// - Parameter request: The request to modify with authentication information.
    ///
    private func addAuthentication(to request: inout URLRequest) {
        
        request.addValue("key \(apiKey)", forHTTPHeaderField: "Authorization")
    }
}


/// Rebrickable API endpoints.
///
/// Raw values are the actual URL paths that correspond to each endpoint.
///
enum Rebrickable_Route: String {
    
    case lego_colors = "lego/colors/"
    case lego_parts = "lego/parts/"
}


/// Rebrickable API URL parameters.
///
/// Raw values are the actual parameter names that should be used in URLs.
///
enum Rebrickable_RouteParameter: String {
    
    case page_size = "page_size"
    case page = "page"
}
