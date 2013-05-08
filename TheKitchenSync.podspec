Pod::Spec.new do |s|
  s.name         = "TheKitchenSync"
  s.version      = "0.0.1"
  s.summary      = "iOS Concurrency Library from Cue."
  s.homepage     = "https://www.cueup.com"
  s.license      = 'Apache'
  s.authors      = { "Aaron Sarazan" => "aaron@cueup.com", "Robby Walker" => "robbyw@cueup.com" }
  s.source       = { :git => "https://github.com/Cue/TheKitchenSync.git", :tag => "0.0.1" }
  s.platform     = :ios, '5.0'
  s.source_files = "Classes/**/*.{h,hpp,m,mm,cc,c,cpp}"
  s.exclude_files = 'TheKitchenSyncTests'
  s.libraries     = 'c++'
  s.requires_arc = false
  s.prefix_header_file = 'TheKitchenSync-Prefix.pch'
  s.xcconfig = { 'CLANG_CXX_LIBRARY' => 'libc++', 'CLANG_CXX_LANGUAGE_STANDARD' => 'c++0x' }
end
