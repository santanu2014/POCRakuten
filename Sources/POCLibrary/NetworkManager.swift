

import Foundation

protocol EndPointProtocol {
    func getGitHubRepositoryDetails(quary: String, org: String, completion: @escaping([Item]?, NetworkError?) ->Void)
}
open class NetworkManager : EndPointProtocol {
    
    var apiService: RestServiceProtocol
    
    public init() {
        self.apiService = NetworkClient()
    }
    
    open func getGitHubRepositoryDetails(quary: String, org: String, completion: @escaping([Item]?, NetworkError?) ->Void) {
        
        apiService.request(baseURL: WebserviceConstant.baseURL, q: quary,org: org) { (result: Result< RepoInformation, NetworkError>) in
            switch result {
            case .success(let model):
                guard let items = model.items else {
                    return  completion(nil, .noData)
                }
                debugPrint("List of items: ",items)
                completion(items, nil)
                
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
