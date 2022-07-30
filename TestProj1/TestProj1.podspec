Pod::Spec.new do |s|
  s.name             = "TestProj1"
  s.version          = "1.1.100"
  s.summary          = "MnaFile for MnaTeam"
  s.homepage         = "https://github.com/MnaTeam"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "mna" => "mna@tencent.com" }
  s.source           = { :git => "https://github.com/MnaTeam/FirstApp.git", :tag => s.version,:branch => 'master'}
  s.platform     = :ios, '9.0'
  s.requires_arc = true
  s.static_framework = true 
  s.source_files  = 'TestProj1/Classes/*'
  
  s.module_name = 'TestProj1'
  
end
