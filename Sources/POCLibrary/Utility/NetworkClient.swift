
import Foundation

public enum NetworkError: Error {
    
    case transportError(Error)
    case serverError(statusCode: Int)
    case noData
    case urlNotCorrect
    case decodingError(Error)
    case encodingError(Error)
}

protocol RestServiceProtocol {
    func request <T: Decodable>(baseURL: String, q: String,org: String, completion: @escaping (Result<T, NetworkError>) -> Void)
}

protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}

extension URLSession: URLSessionProtocol {

    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return (dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask) as URLSessionDataTaskProtocol
    }
}

class UrlComponents {
    
    let baseURL: String
    let org: String
    let q: String
    var url: URL {
        var query = [String]()
        query.append("q=\(q)")
        query.append("org:\(org)")
        
        guard let composedUrl = URL(string: "?" + query.joined(separator: "+"), relativeTo: NSURL(string: baseURL) as URL?) else {
            fatalError("Unable to build request url")
        }
        print(composedUrl.absoluteString)
        return composedUrl
    }
    
    init(baseURL: String, q: String, org: String) {
        
        self.baseURL = baseURL
        self.q = q
        self.org = org
    }
}


class NetworkClient: RestServiceProtocol {
    
    private var session: URLSessionProtocol
    
    init(withSession session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func request <T: Decodable>(baseURL: String, q: String,org: String, completion: @escaping (Result<T,NetworkError>) -> Void) {
        
        let urlComponents = UrlComponents(baseURL: baseURL, q: q, org: org)
        session.dataTask(with: urlComponents.url) { (data, response, error) in
            //Handle error case
            if let error = error {
                completion(.failure(.transportError(error)))
                return
            }
            if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                completion(.failure(.serverError(statusCode: response.statusCode)))
                return
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            do {
                let responseData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(responseData))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }
}
