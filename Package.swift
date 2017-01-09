import PackageDescription

let package = Package(
  name: "PutioKit",
  dependencies: [
    .Package(url: "https://github.com/Alamofire/Alamofire.git", majorVersion: 4)
  ]
)
