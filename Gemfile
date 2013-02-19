source "http://rubygems.org"

gemspec

gem "rspec-rails", :group => [:test, :development]
group :test do
  gem "capybara"
  gem "guard-rspec"
  gem 'guard'
  gem 'guard-bundler'
  gem "rb-fsevent"
  gem "activerecord"
  if RUBY_PLATFORM.downcase.include?("darwin")
    gem 'ruby_gntp'
    gem 'growl' # also install growlnotify from the Extras/growlnotify/growlnotify.pkg in Growl disk image.
  end
end