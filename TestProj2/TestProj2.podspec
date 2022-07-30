Pod::Spec.new do |s|
  s.name             = "TestProj2"
  s.version          = "1.101.10.10"
  s.summary          = "MnaFile for MnaTeam"
  s.homepage         = "https://github.com/MnaTeam"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "mna" => "mna@tencent.com" }
  s.source           = { :git => "https://github.com/MnaTeam/FirstApp.git", :tag => s.version,:branch => 'master'}
  s.platform     = :ios, '9.0'
  s.requires_arc = true
  s.static_framework = true 
  s.source_files  = "TestProj2/Classes/**/*"
  
  s.module_name = 'TestProj2'
  
end
