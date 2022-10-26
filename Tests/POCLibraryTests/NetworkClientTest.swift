
import XCTest
@testable import POCLibrary

final class NetworkClientTest: XCTestCase {
    
    var sut: NetworkClient!
    var mockSession: MockURLSession!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testNetworkClientForSuccessResponse() throws {
        
        let mockResponseData = try Mocks.testDataWithData.getData()
        mockSession = createMockSession(mockResponseData: mockResponseData,statusCode: 200, error: nil)
        sut = NetworkClient(withSession: mockSession)
        sut.request(baseURL: "test", q: "test", org: "test") { (result: Result< RepoInformation, NetworkError>)  in
            switch result {
            case .success(let model) :
                XCTAssertNotNil(model.items)
            case .failure(let error) :
                XCTAssertNil(error)
            }
        }
    }
    
    func testNetworkClientForFailureResponse() throws {
        
        let mockResponseData = try Mocks.testDataWithData.getData()
        mockSession = createMockSession(mockResponseData: mockResponseData,statusCode: 304, error: nil)
        sut = NetworkClient(withSession: mockSession)
        sut.request(baseURL: "test", q: "test", org: "test") { (result: Result< RepoInformation, NetworkError>)  in
            switch result {
            case .success(let model) :
                XCTAssertNil(model.items)
            case .failure(let error) :
                XCTAssertNotNil(error)
            }
        }
    }
    
    func testNetworkClientFailureWithResponseCode503() throws {
        
        let mockResponseData = try Mocks.testDataWithData.getData()
        mockSession = createMockSession(mockResponseData: mockResponseData, statusCode: 503, error: nil)
        sut = NetworkClient(withSession: mockSession)
        sut.request(baseURL: "test", q: "test", org: "test") { (result: Result< RepoInformation, NetworkError>)  in
            switch result {
            case .success(let model) :
                XCTAssertNotNil(model.items)
            case .failure(let error) :
                XCTAssertNotNil(error)
            }
        }
    }
    
    func testNetworkClientWithEmptyData() throws {
        
        mockSession = createMockSession(mockResponseData: nil, statusCode: 202, error: nil)
        sut = NetworkClient(withSession: mockSession)
        sut.request(baseURL: "test", q: "test", org: "test") { (result: Result< RepoInformation, NetworkError>)  in
            switch result {
            case .success(let model) :
                XCTAssertNil(model.items)
            case .failure(let error) :
                XCTAssertNotNil(error)
            }
        }
    }
    
    func testNetworkClientEmptyDataWithError() throws {
        mockSession = createMockSession(mockResponseData: nil, statusCode: 204, error: NetworkError.noData)
        sut = NetworkClient(withSession: mockSession)
        sut.request(baseURL: "test", q: "test", org: "test") { (result: Result< RepoInformation, NetworkError>)  in
            switch result {
            case .success(let model) :
                XCTAssertNil(model.items)
            case .failure(let error) :
                XCTAssertNotNil(error)
            }
        }
    }
    
    private func createMockSession(mockResponseData: Data?, statusCode: Int, error: Error?) -> MockURLSession? {
        
        let response = HTTPURLResponse(url: URL(string: "TestUrl")!, statusCode: statusCode, httpVersion: nil, headerFields: nil)
        return MockURLSession(completionHandler:( mockResponseData, response, error))
    }
}

// Mock

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    func resume(){}
}

class MockURLSession: URLSessionProtocol {
    
    var dataTask = MockURLSessionDataTask()
    var completionHandler: (Data?, URLResponse?, Error?)
    
    init(completionHandler:(Data?, URLResponse?, Error?)) {
        self.completionHandler = completionHandler
    }
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        completionHandler(self.completionHandler.0, self.completionHandler.1, self.completionHandler.2)
        return dataTask
    }
}
