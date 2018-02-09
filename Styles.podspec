#
# Be sure to run `pod lib lint Styles.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Styles'
  s.version          = '0.1.0'
  s.summary          = 'UI Elements rapid styling'
  s.description      = <<-DESC
UIElements styling made easy, declarative and rapid.
                       DESC

  s.homepage         = 'https://github.com/inloop/Styles'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'radimhalfar' => 'radim.halfar@inloop.eu', 'jakubpetrik' => 'petrik@inloop.eu' }
  s.source           = { :git => 'https://github.com/inloop/Styles.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'Styles/Classes/**/*'
end
