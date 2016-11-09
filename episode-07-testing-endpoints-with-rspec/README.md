# Episode 7: Testing Endpoints with RSpec

Video: https://youtu.be/tBwV_mBm3PA

I cant be bothered to write a description today. I'm too sad.

RSpec http://rspec.info/


Nope on fixtures
# config.fixture_path = "#{::Rails.root}/spec/fixtures"

Yes please
config.use_transactional_fixtures = true

(enabled by default in rails)


gem install factory_girl_rails

in spec_helper
  # Enable shorter syntax for create/build
  config.include FactoryGirl::Syntax::Methods

(explain lets() syntax)

```
gem 'rspec-json_expectations'
```
