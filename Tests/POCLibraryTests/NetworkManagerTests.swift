import XCTest
@testable import POCLibrary

final class NetworkManagerTests: XCTestCase {

    func testSuccessfulResponse() throws {
        
        let mockResponseData = try Mocks.testDataWithData.getData()
        let repo = NetworkManager()
        let expectation = XCTestExpectation(description: "Response")
        repo.apiService = MockWebserviceHelper(responseData: mockResponseData, error: .serverError(statusCode: 200))
        repo.getGitHubRepositoryDetails(quary: "test", org: "test") { ( items, error) in
            XCTAssertEqual(items?.count, 1, "Expected 1 item")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFailureResponse() throws {
        
        let mockResponseData = Data()
        let repo = NetworkManager()
        let expectation = XCTestExpectation(description: "Response")
        repo.apiService = MockWebserviceHelper(responseData: mockResponseData, error: .noData)
        repo.getGitHubRepositoryDetails(quary: "test", org: "test") { ( items, error) in
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testNoItemResponse() throws {
        
        let mockResponseData: Data? = try Mocks.testDataWithNoItem.getData()
        let repo = NetworkManager()
        let expectation = XCTestExpectation(description: "Response")
        repo.apiService = MockWebserviceHelper(responseData: mockResponseData, error: .noData)
        repo.getGitHubRepositoryDetails(quary: "test", org: "test") { ( items, error) in
            XCTAssertNil(items)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}

class MockWebserviceHelper: RestServiceProtocol{
    
    let responseData: Data?
    let error: NetworkError
    
    init(responseData: Data?, error: NetworkError) {
        self.responseData = responseData
        self.error = error
    }
    
    func request<T>(baseURL: String, q: String, org: String, completion: @escaping (Result<T, POCLibrary.NetworkError>) -> Void) where T : Decodable {
        
        guard let data = responseData else {
            return completion(.failure(.noData))
        }
        do {
            let responseData = try JSONDecoder().decode(T.self, from: data)
            completion(.success(responseData))
            
        } catch {
            completion(.failure(.decodingError(error)))
        }
    }
}
