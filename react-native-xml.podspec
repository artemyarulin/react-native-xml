Pod::Spec.new do |s|
  s.name           = "react-native-xml"
  s.version        = "0.0.1"
  s.summary        = "react native xml module with xpath support"
  s.description    = "Provides you a function to parse and search inside XML using XPath and JavaScript"
  s.homepage       = "https://github.com/artemyarulin/react-native-xml"
  s.license        = { :type => 'MIT', :file => 'LICENSE' }
  s.author         = { "Artem Yarulin" => "artem.yarulin@fessguid.com" }
  s.platform       = :ios, "7.0"
  s.source         = { :git => "https://github.com/artemyarulin/react-native-xml.git", :tag => s.version.to_s }
  s.source_files   = ["rnxml/rnxml/RNMXml.{h,m}"]
  s.public_header_files = "rnxml/rnxml/RNMXml.h"
  s.requires_arc  = true
  s.dependency "GDataXML-HTML", "~> 1.1"
  s.dependency "React", "~> 0.5.0"
  # CocoaPods wouldn't handle it for us, so let's expose build flags from GDataXml-HTML
  s.library = 'xml2'
  s.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2' }
end