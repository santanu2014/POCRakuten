
import Foundation

enum Mocks: String {
    
    case testDataWithData = "TestData.json"
    case testDataWithNoItem = "TestDataWithNoItem.json"
    
    var url: URL {
        let thisSourceFile = URL(fileURLWithPath: #file)
        let thisDirectory = thisSourceFile.deletingLastPathComponent()
        return thisDirectory.appendingPathComponent("Mocks/\(self.rawValue)")
    }

    func getData() throws -> Data {
        return try Data(contentsOf: self.url)
    }
}
