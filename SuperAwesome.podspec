Pod::Spec.new do |s|
  s.name         = "SuperAwesome"
  s.version      = "6.1.3"
  s.summary      = "SuperAwesome Mobile SDK for iOS"
  s.description  = <<-DESC
                   The SuperAwesome Mobile SDK lets you to easily add COPPA compliant advertisements and other platform features, like user authentication and registration, to your apps. We try to make integration as easy as possible, so we provide all the necessary tools such as this guide, API documentation, screencasts and demo apps.
                   DESC

  s.homepage     = "http://developers.superawesome.tv/docs/iossdk"
  s.documentation_url = 'http://developers.superawesome.tv/docs/iossdk'
  s.license      = { :type => "GNU GENERAL PUBLIC LICENSE Version 3", :file => "LICENSE" }
  s.author             = { "Gabriel Coman" => "gabriel.coman@superawesome.tv" }
  s.platform     = :ios, "8.0"
  s.requires_arc = true
  s.source       = { :git => "https://github.com/SuperAwesomeLTD/sa-mobile-sdk-ios.git", :branch => "master" ,:tag => "6.1.3" }
  s.default_subspec = 'Full'

  s.subspec 'Base' do |b|
    b.source_files = 'Pod/Classes/**/*'
    b.frameworks = 'AdSupport'
    b.dependency 'SAVideoPlayer', '1.2.3'
    b.dependency 'SAWebPlayer', '1.2.3'
    b.dependency 'SAEvents', '1.9.5'
    b.dependency 'SAAdLoader', '1.1.6'
    b.dependency 'SABumperPage', '1.0.3'
    b.dependency 'SAParentalGate', '1.0.1'
  end

  s.subspec 'Full' do |f|
    f.dependency 'SuperAwesome/Base'
    f.dependency 'SAEvents/Moat'
  end
  
  s.subspec 'AIR' do |a|
    a.dependency 'SuperAwesome/Base'
    a.source_files = 'Pod/Plugin/AIR/*'
  end

  s.subspec 'MoPub' do |m|
    m.dependency 'SuperAwesome/Base'
    m.dependency 'mopub-ios-sdk'
    m.source_files = 'Pod/Plugin/MoPub/*'
  end

  s.subspec 'AdMob' do |am|
    am.dependency 'SuperAwesome/Base'
    am.dependency 'Google-Mobile-Ads-SDK'
    am.source_files = 'Pod/Plugin/AdMob/*'
  end

  s.subspec 'Unity' do |u|
    u.dependency 'SuperAwesome/Base'
    u.source_files = 'Pod/Plugin/Unity/*'
  end
end
