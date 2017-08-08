#
#  Be sure to run `pod spec lint OCLogProj.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "OCLog"
  s.version      = "0.0.2"
  s.summary      = "a log system for iOS platform"
  s.description  = <<-DESC
  We can easy to use this lib to print a log with more infos such as time, method name, lines and other detail.
We have 5 log level. VEND/DEBUG/INFO/WARNING/ERROR.
We can catch all the crash stack infos.
We can write all the log to a local file and then you can send it to the remote server.
                   DESC

  s.homepage     = "https://github.com/leisurehuang/OCLog"
  s.license         = { :type => 'MIT', :file => 'License.txt' }
  s.author             = { "leisurehuang" => "leisure.huang34@gmail.com" }

  s.source       = { :git => "https://github.com/leisurehuang/OCLog.git", :tag => "#{s.version}" }

  s.source_files  = "OCLog", "OCLog/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"
  s.requires_arc = true
  s.ios.deployment_target = '8.0'
end
