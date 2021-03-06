source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.2'

gem 'bootstrap-sass'

gem 'devise', '~> 4.6.2'

# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
gem 'devise-i18n'
gem 'rails-i18n'
# 针对下拉选项很多时的包
gem 'select2-rails'
# 动态一直新增表单
gem 'nested_form_fields'
# 选日期时间的 UI
gem 'bootstrap-datepicker-rails'
# 编辑器
gem 'ckeditor', '4.2.4'
# 自定义顺序
gem 'ranked-model'
# 拖拉的 UI 的前端套件
gem 'jquery-ui-rails'
# 分页
gem 'kaminari'
# 搜索,只要符合部分关键字就好，用数据库的 LIKE 搜寻 语法
gem 'carrierwave'
# 图片文档
gem 'ransack'
gem 'mini_magick'
# 软删除和版本控制,进行复原的动作,建立追踪和稽核的机制
gem 'paper_trail'
# 汇出Excel格式
gem 'rubyzip'
gem 'axlsx'
gem 'axlsx_rails'
# 不需要真的寄出 E-mail, 在寄信时，自动打开浏览器进行预览
gem 'letter_opener'
# E-mail CSS 样式
gem 'premailer-rails'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  gem 'rspec-rails'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  gem 'faker'

  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'listen', '~> 3.0.5'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
