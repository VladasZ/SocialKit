Pod::Spec.new do |s|
s.name           = 'SocialKit'
s.version        = '0.4.1'
s.summary        = "Social networks login kit"
s.homepage       = "https://github.com/VladasZ/SocialKit"
s.author         = { 'Vladas Zakrevskis' => '146100@gmail.com' }
s.source         = { :git => 'https://github.com/VladasZ/SocialKit.git', :tag => s.version }
s.ios.deployment_target = '9.0'
s.source_files   = 'Sources/**/*.swift'
s.license        = 'MIT'
s.dependency 'SwiftyVK'
s.dependency 'FacebookCore'
s.dependency 'FBSDKCoreKit'
s.dependency 'FBSDKLoginKit'
end
