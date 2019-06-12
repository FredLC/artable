# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

def shared_pods
  pod 'Firebase/Core', '6.1.0'
  pod 'Firebase/Auth', '6.1.0'
  pod 'Firebase/Analytics'
  pod 'Firebase/Firestore', '6.1.0'
  pod 'Firebase/Storage', '6.1.0'
  pod 'Firebase/Functions', '6.1.0'
  pod 'IQKeyboardManagerSwift', '6.3.0'
  pod 'Kingfisher', '~> 4.0'
end

target 'Artable' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Artable
  shared_pods
  pod 'Stripe', '~> 15.0.1'
end

target 'ArtableAdmin' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ArtableAdmin
  shared_pods
end
