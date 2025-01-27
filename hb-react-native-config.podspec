# frozen_string_literal: true

require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name         = 'hb-react-native-config'
  s.version      = package['version']
  s.summary      = 'Expose config variables to React Native apps'
  s.author       = 'Pedro Belo'

  s.homepage     = 'https://github.com/luggit/react-native-config'

  s.license      = 'MIT'
  s.ios.deployment_target = '9.0'
  s.tvos.deployment_target = '9.0'

  s.source       = { git: 'https://github.com/luggit/react-native-config.git', tag: "v#{s.version.to_s}" }
  s.script_phase = {
    name: 'Config codegen',
    script: %(
set -ex
HOST_PATH="$SRCROOT/../.."
"${PODS_TARGET_SRCROOT}/ios/HBReactNativeConfig/BuildDotenvConfig.rb" "$HOST_PATH" "${PODS_TARGET_SRCROOT}/ios/HBReactNativeConfig"
),
    execution_position: :before_compile,
    input_files: ['$PODS_TARGET_SRCROOT/ios/HBReactNativeConfig/BuildDotenvConfig.rb']
  }

  s.requires_arc = true
  s.default_subspec = 'App'

    s.subspec 'App' do |app|
    app.source_files = 'ios/**/*.{h,m}'
    app.dependency 'React-Core'
  end

  # Use this subspec for iOS extensions that cannot use React dependency
  s.subspec 'Extension' do |ext|
    # Had to duplicate the script_phase since it wasn't being passed down. Not sure why
    ext.script_phase = {
      name: 'Config codegen',
      script: %(
        set -ex
        HOST_PATH="$SRCROOT/../.."
        "${PODS_TARGET_SRCROOT}/ios/HBReactNativeConfig/BuildDotenvConfig.rb" "$HOST_PATH" "${PODS_TARGET_SRCROOT}/ios/HBReactNativeConfig"
        ),
      execution_position: :before_compile,
      input_files: ['$PODS_TARGET_SRCROOT/ios/HBReactNativeConfig/BuildDotenvConfig.rb']
    }
    ext.source_files = ['ios/**/HBReactNativeConfig.{h,m}', 'ios/**/GeneratedDotEnv.m']
  end

end
