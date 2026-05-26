Pod::Spec.new do |s|
  s.name             = "toxcore"
  s.version          = "0.2.21"
  s.summary          = "Cocoapods wrapper for toxcore with Group v2 support"
  s.homepage         = "https://github.com/wcdmac/toxcore"
  s.license          = 'GPLv3'
  s.author           = { "Dmytro Vorobiev" => "d@dvor.me" }
  s.source           = {
      :git => "https://github.com/wcdmac/toxcore.git",
      :tag => s.version.to_s
  }
  s.pod_target_xcconfig = { 'ENABLE_BITCODE' => 'NO', 'OTHER_LDFLAGS' => '-read_only_relocs suppress' }
  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = '10.9'
  s.requires_arc = true
  s.header_mappings_dir = 'toxcore'
  s.source_files = 'toxcore/toxcore/*.{m,h}', 'toxcore/toxcore/events/*.{m,h}', 'toxcore/toxencryptsave/*.{m,h}', 'toxcore/toxav/*.{m,h}'
  s.dependency 'libopus-patched-config', '1.1'
  s.dependency 'libsodium', '~> 1.0.1'
  s.ios.vendored_frameworks = 'ios/vpx.framework'
  s.osx.vendored_frameworks = 'osx/vpx.framework'
  s.xcconfig = { 'FRAMEWORK_SEARCH_PATHS' => '"${PODS_ROOT}"'}
  s.prepare_command = './install-tox.sh'
end
