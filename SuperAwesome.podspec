Pod::Spec.new do |s|
  s.name         = "SuperAwesome"
  s.version      = "5.2.0"
  s.summary      = "SuperAwesome Mobile SDK for iOS"
  s.description  = <<-DESC
                   The SuperAwesome Mobile SDK lets you to easily add COPPA compliant advertisements and other platform features, like user authentication and registration, to your apps. We try to make integration as easy as possible, so we provide all the necessary tools such as this guide, API documentation, screencasts and demo apps.
                   DESC

  s.homepage     = "http://developers.superawesome.tv/docs/iossdk"
  s.documentation_url = 'http://developers.superawesome.tv/docs/iossdk'
  s.license      = { :type => "GNU GENERAL PUBLIC LICENSE Version 3", :file => "LICENSE" }
  s.author             = { "Gabriel Coman" => "gabriel.coman@superawesome.tv" }
  s.platform     = :ios, "7.0"
  s.ios.deployment_target = "7.0"
  s.requires_arc = true
  s.source       = { :git => "https://github.com/SuperAwesomeLTD/sa-mobile-sdk-ios.git", :branch => "master" ,:tag => "5.2.0" }
  s.default_subspec = 'Full'

  s.subspec 'Base' do |b|
    b.source_files = 'Pod/Classes/**/*'
    b.frameworks = 'AdSupport'
    b.dependency 'SAVideoPlayer', '1.1.5'
    b.dependency 'SAWebPlayer', '1.0.8'
    b.dependency 'SAEvents', '1.5.3'
    b.dependency 'SAAdLoader', '0.6.8'
  end

  s.subspec 'Full' do |f|
    f.dependency 'SuperAwesome/Base'
    f.dependency 'SAEvents/Moat'
  end

  s.subspec 'MoPub' do |m|
    m.dependency 'SuperAwesome/Base'
    m.dependency 'mopub-ios-sdk'
    m.source_files = 'Pod/Plugin/MoPub/*'
  end

  s.subspec 'Unity' do |u|
    u.dependency 'SuperAwesome/Base'
    u.exclude_files = "Pod/Plugin/Unity/SAUnity.mm"
  end
end
