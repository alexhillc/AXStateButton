Pod::Spec.new do |s|
  s.name            = "AXStateButton"
  s.version         = "1.0.0"
  s.license         = { :type  => 'MIT', :file => 'LICENSE.md' }
  s.summary         = "A simple UIButton subclass that allows for extensive button state customization."
  s.homepage        = "https://github.com/alexhillc/AXStateButton"
  s.author          = { "Alex Hill" => "alexhill.c@gmail.com" }
  s.source          = { :git => "https://github.com/alexhillc/AXStateButton.git", :tag => "v#{s.version}" }

  s.platform        = :ios, '9.0'
  s.requires_arc    = true

  s.source_files  = 'Source/*.{h,m}'
  s.frameworks    = 'UIKit'
end

