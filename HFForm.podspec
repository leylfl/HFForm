Pod::Spec.new do |s|

s.name         = 'HFForm'
s.version      = '0.0.2'
s.summary      = 'An easy way to create a editable tableview'
s.homepage     = 'https://github.com/leylfl/HFForm'
s.license      = 'MIT'
s.authors      = {'zhaomu' => 'leylfl@foxmail.com'}
s.platform     = :ios, '8.0'
s.source       = {:git => 'https://github.com/leylfl/HFForm.git', :tag => s.version}
s.source_files = 'HFForm/**/*.{h,m}'
s.requires_arc = true

end
