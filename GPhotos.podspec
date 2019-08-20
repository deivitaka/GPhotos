Pod::Spec.new do |s|
    s.name             = 'GPhotos'
    s.version          = '0.1.2'
    s.summary          = 'A wrapper around the Google Photos API for iOS.'
    s.description      = <<-DESC
    I wanted to consume the Google Photos API in Swift but at the time of writing there is no framework
    that does it in a simple way.
    So why not share my own take?
    This project will gradually implement all endpoints.
    DESC
    
    s.homepage     = "https://github.com/deivitaka/GPhotos.git"
    s.license      = { :type => "MIT", :file => "LICENSE" }
    s.author       = { "Deivi Taka" => "deivitaka@gmail.com" }
    s.social_media_url = 'https://www.linkedin.com/in/deivitaka/'
    
    s.source       = { :git => "https://github.com/deivitaka/GPhotos.git", :tag => "#{s.version}" }
    s.source_files  = "GPhotos/**/*"
    # s.exclude_files = "GPhotosTests/*.swift"
    s.swift_version = "5.0"
    s.platform     = :ios, "8.0"
    
    s.dependency 'GTMAppAuth', '~> 1.0.0'
    s.dependency 'AppAuth', '~> 1.0'
end
