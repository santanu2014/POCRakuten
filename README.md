# POCLibrary

This is an search library written in Swift.

## Features
- Helps search for the specific item.


## Compatible

- iOS 10.0 or later
- Xcode 10.0 or late

## Installation

### Installation with Swift Package Manager (Xcode 11+)

SwiftPM is a tool for managing the 
distribution of Swift code as well as C-family dependency. From Xcode 11, SwiftPM got natively integrated with Xcode.

To use SwiftPM, user should use Xcode 11 to open the project. 
Click `File` -> `Swift Packages` -> `Add Package Dependency`, enter [ repo's URL]. 
Or you can login Xcode with your GitHub account and just type `repo NAME` to search.


## How to use

- Importing Library

```swift
import NetworkManager
```
- Create instance of NetworkManager and call getGitHubRepositoryDetails method with two input parameters.
- GetGitHubRepositoryDetails will return with the list of items. Item has property with name, privacy, description and language.
      
        let manager = NetworkManager()
        manager.callRestAPI(quary: "ios", org: "rakutentech") { (items, error) in
            print("Details:",items)
        }
- RepoInformation used for model, NetworkClient used for Restful API call, NetworkManager used for preparing request and parsing the data.
- Also covered unit test cases inside of the framework.






