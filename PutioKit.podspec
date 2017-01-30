Pod::Spec.new do |s|

  s.name         = "PutioKit"
  s.version      = "1.0.0"
  s.summary      = "A Swift framework for Put.io's API"
  s.description  = <<-DESC
  PutioKit is a modern Swift framework that interfaces with Put.io's API. It features near 100% coverage of Put.io's entire API and works with iOS, tvOS, and macOS (Linux support is currently reliant on Alamofire).

  The framework is derived from one of the same name used in the Fetch iOS app.
                   DESC

  s.homepage     = "https://github.com/TryFetch/PutioKit"
  s.license      = "GPL 3.0"


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.author             = { "Cocoon Development Ltd" => "fetch@wearecocoon.co.uk" }
  s.social_media_url   = "http://twitter.com/TryFetch"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.ios.deployment_target = "9.0"
  s.osx.deployment_target = "10.11"
  s.tvos.deployment_target = "9.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source       = { :git => "https://github.com/TryFetch/PutioKit.git", :tag => "1.0.0" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source_files  = "Sources"

  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.dependency "Alamofire", "~> 4.3"

end
