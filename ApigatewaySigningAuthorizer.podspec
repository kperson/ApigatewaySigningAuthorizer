Pod::Spec.new do |spec|
    spec.name         = 'ApigatewaySigningAuthorizer'
    spec.version      = '1.0.1'
    spec.license      =  { :type => 'MIT' }
    spec.homepage     = 'https://github.com/kperson/ApigatewaySigningAuthorizer'
    spec.authors      = 'Kelton Person'
    spec.summary      = 'Request signing for Swift using API Gateway'
    spec.source       = { :git => 'https://github.com/kperson/ApigatewaySigningAuthorizer.git', :tag => '1.0.0' }
    spec.source_files = 'Sources/ApigatewaySigningAuthorizer/SignedRequest.swift'
    spec.requires_arc = true
    spec.ios.deployment_target = '10.0'
    spec.watchos.deployment_target = '3.0'
    spec.dependency 'CryptoSwift', '~> 1.1'
    spec.swift_version = '5.0'
  end