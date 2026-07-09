require 'xcodeproj'
project_path = 'ios/Runner.xcodeproj'
project = Xcodeproj::Project.open(project_path)

target = project.targets.find { |t| t.name == 'Runner' }
group = project.main_group.find_subpath('Runner', true)

file_reference = group.files.find { |f| f.path == 'Runner.entitlements' }
if file_reference.nil?
  file_reference = group.new_reference('Runner.entitlements')
  puts "Added Runner.entitlements to the group."
end

target.build_configurations.each do |config|
  config.build_settings['CODE_SIGN_ENTITLEMENTS'] = 'Runner/Runner.entitlements'
end

project.save
puts "Project saved successfully."
