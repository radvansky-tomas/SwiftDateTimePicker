#
# Be sure to run `pod lib lint SwiftDateTimePicker.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SwiftDateTimePicker"
  s.version          = "0.1.0"
  s.summary          = "SwiftDateTimePicker UIVIewController for picking NSDate"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
SwiftDateTimePicker UIVIewController for picking NSDate. Allowing user to select day from calendar and time from UIPickerView
                       DESC

  s.homepage         = "https://github.com/radvansky-tomas/SwiftDateTimePicker"
  s.license          = 'MIT'
  s.author           = { "Tomas Radvansky" => "radvansky.tomas@gmail.com" }
  s.source           = { :git => "https://github.com/radvansky-tomas/SwiftDateTimePicker.git", :tag => s.version.to_s }


  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*.swift'
  s.resource_bundles = {
    'SwiftDateTimePicker' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'DateTools'
  s.dependency 'FSCalendar'
end
