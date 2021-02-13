# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'ProductsList' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ProductsList

  ##Networking
  pod 'Alamofire'
  pod 'AlamofireImage'

  ##Views
  pod 'NVActivityIndicatorView'

  ##Others
  pod 'SwiftFormat/CLI'

  ##Dependency injection
  pod 'Swinject'
  pod 'SwinjectAutoregistration'

  def testing_pods
  pod 'Quick'
  pod 'Nimble'
  pod 'Swinject'
  pod 'SwinjectAutoregistration'

end
target 'ProductsListTests' do
  inherit! :search_paths
  # Pods for testing
  testing_pods
end

target 'ProductsListUITests' do
#  inherit! :search_paths
  # Pods for testing
  testing_pods
end

post_install do |pi|
  pi.pods_project.targets.each do |t|
    t.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
    end
  end
end
end
