use_frameworks!

workspace 'JotPackage'

project 'Jot/Jot.xcodeproj'
project 'JotModelKit/JotModelKit.xcodeproj'
project 'JotUIKit/JotUIKit.xcodeproj'

def common_pods
    pod 'SnapKit'
end

def main_pods
    pod 'WhatsNewKit'
    pod 'JGProgressHUD'
end

def firebase_pods
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'

  # Optionally, include the Swift extensions if you're using Swift.
  pod 'FirebaseFirestoreSwift'
end

target 'Jot' do 
    project 'Jot/Jot.xcodeproj'
    common_pods
    main_pods
    firebase_pods

    target 'JotTests' do
        inherit! :search_paths
        # Pods for testing
    end

    target 'JotUITests' do
        # Pods for testing
    end
end

target 'JotWidget' do
    project 'Jot/Jot.xcodeproj'
    common_pods
    firebase_pods
end

target 'JotModelKit' do 
    project 'JotModelKit/JotModelKit.xcodeproj'
end

target 'JotUIKit' do
    project 'JotUIKit/JotUIKit.xcodeproj'
    common_pods
end
