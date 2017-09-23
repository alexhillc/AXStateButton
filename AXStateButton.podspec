Pod::Spec.new do |s|
  s.name            = "AXStateButton"
  s.version         = "1.1.2"
  s.license         = { :type  => 'MIT', :file => 'LICENSE.md' }
  s.summary         = "A simple UIButton subclass that allows for extensive button state customization."
  s.homepage        = "https://github.com/alexhillc/AXStateButton"
  s.author          = { "Alex Hill" => "alexhill.c@gmail.com" }
  s.source          = { :git => "https://github.com/alexhillc/AXStateButton.git", :tag => "v#{s.version}" }

  s.platform        = :ios, '8.0'
  s.requires_arc    = true

  s.source_files  = 'Source/*.{h,m}'
  s.frameworks    = 'UIKit'
end

