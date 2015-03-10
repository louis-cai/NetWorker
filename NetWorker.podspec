#
# Be sure to run `pod lib lint NetWorker.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "NetWorker"
  s.version          = "1.0.0"
  s.summary          = "NetWorker是一个网络请求的隔离层，封装的AFNetWorking."
  s.description      = "NetWorker是一个基于AFNetWorking的网络请求隔离层，主要用于适配不同类型的网络请求lib。"
  s.homepage         = "https://github.com/louis-cai/NetWorker"
  s.license          = 'MIT'
  s.author           = { "cailu" => "louis.cai.cn@gmail.com" }
  s.source           = { :git => "https://github.com/louis-cai/NetWorker.git", :tag => s.version.to_s }

  s.frameworks       = 'Foundation', 'UIKit'
  s.requires_arc     = true
  s.ios.deployment_target = '7.0'

  s.default_subspec = 'Core'
    s.subspec 'Core' do |core|
    core.source_files = 'Pod/Classes/Core/*.{h,m}','Pod/Classes/NetWorker.h'
    core.dependency 'AFNetworking', '~> 2.0'
  end

  s.subspec 'RAC' do |rac|
    rac.source_files = 'Pod/Classes/RAC/*.{h,m}'
    rac.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) MNS_RAC=1' }
    rac.dependency 'NetWorker/Core'
    rac.dependency 'ReactiveCocoa', '~> 2.0'
    rac.dependency 'AFNetworking-RACExtensions'
  end

  s.subspec 'Logger' do |log|
    log.source_files = 'Pod/Classes/Logger/*.{h,m}'
    log.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) MNS_LOG=1' }
    log.dependency 'NetWorker/Core'
    log.dependency 'AFNetworkActivityLogger'
  end
end
