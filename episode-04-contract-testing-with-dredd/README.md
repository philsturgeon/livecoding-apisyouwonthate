Video: https://youtu.be/dJXTWVuE89Q

Now that we've started building a very basic API, we should make sure that the documentation continues to keep up to date with our progress. Even better, we should use our documentation as a basic contract test, to make sure we aren't lying about what our API offers.

Basic guide over here for how dredd works in general.

https://philsturgeon.uk/api/2015/01/28/dredd-api-testing-documentation/


npm install -g dredd

dredd init

dredd > log/dredd.log


For dredd to work, there needs to be data in the database. If you make a request to `/products/1` and there is no record with ID=1 in the database, then it will return a `404` response, instead of a `200` response with all the expected attributes.

To solve this we can use database seeding. A lot of apps use seeding for other things, so it can be really useful to make a custom seed out of the way of anything else:

``` ruby
# lib/tasks/custom_seeds.rake
namespace :db do
  namespace :seed do
    Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].each do |filename|
      task_name = File.basename(filename, '.rb').intern
      task task_name => :environment do
        load(filename) if File.exist?(filename)
      end
    end
  end
end
```

Now, we can populate the seeds with really basic record creation. In fact, this is the same stuff we used in episode 3:

``` ruby
# db/seeds/dredd.rb

manufacturer = Manufacturer.create(name: "Thatchers", about: "Pretty solid cider makers who are randomly moving their factories in the south west and going to Ireland...", city: "Dublin", country: "Ireland")

Product.create(manufacturer: manufacturer, name: 'Katies', description: "Unnecessarily strong fizzy cider that sells for the same price as normal ciders.", apv: 7.6, product_type: 'cider')

Product.create(manufacturer: manufacturer, name: 'Thatchers Dry', description: "As the name suggests this is dry, and a little tangy.", apv: 6.5, product_type: 'cider')
```

To check that works, you can run it with the following command:

``` shell
rake db:seed:dredd
```

In isolation, that is not very helpful. We also don't want to mess with our development database. Using the entire following command, you can use the testing database, create a fresh DB every time, load the schema up, then run dredd.

``` shell
RAILS_ENV=test rake db:drop db:create db:migrate db:seed:dredd && dredd
```

This would be a fairly annoying command to have to remember, wrap it up in a simple `Makefile`:

``` shell
# Makefile
.PHONY: docs_test
docs_test:
		@echo "Seeding database for documentation testing"
		@RAILS_ENV=test rake db:drop db:create db:migrate db:seed:dredd
		@echo "Running dredd... check logs/dredd.log for more information"
		@RAILS_ENV=test dredd > log/dredd.log && echo "Documentation is all good!"
```

With that `Makefile` in your project root, you can simply run this:

``` shell
$ make docs_test
```

We'll be making a few more make commands over the next few videos. They're really useful!
