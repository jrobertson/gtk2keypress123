Gem::Specification.new do |s|
  s.name = 'gtk2keypress123'
  s.version = '0.1.1'
  s.summary = 'A minimal GTK2 app which captures 1 or more key presses ' + 
      'which can trigger outgoing notifications.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/gtk2keypress123.rb']
  s.add_runtime_dependency('gtk2', '~> 3.2', '>=3.2.9')
  s.add_runtime_dependency('gtk2keypress', '~> 0.1', '>=0.1.1')  
  s.add_runtime_dependency('dynarex', '~> 1.8', '>=1.8.5')
  s.signing_key = '../privatekeys/gtk2keypress123.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@jamesrobertson.eu'
  s.homepage = 'https://github.com/jrobertson/gtk2keypress123'
end
