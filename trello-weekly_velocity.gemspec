Gem::Specification.new do |spec|
  spec.name        = 'trello-weekly_velocity'
  spec.version     = '1.0.0'
  spec.summary     = "Calculates weekly velocity from trello boards"
  spec.authors     = ["iainjmitchell"]
  spec.email       = 'iainjmitchell@gmail.com'
  spec.files       = Dir.glob("lib/*")
  spec.homepage    = 'https://github.com/code-computerlove/trello-weekly-velocity'
  spec.license       = 'MIT'
  spec.add_runtime_dependency 'ruby-trello' 
  spec.add_runtime_dependency 'peach'
end