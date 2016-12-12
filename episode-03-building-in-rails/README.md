# Episode 3: Basic Serialization 

Video: https://youtu.be/A4XLCSZBN24

https://github.com/rails-api/active_model_serializers/blob/master/docs/general/getting_started.md

For this video we'll be using the ActiveModel Serializer gem, which you'll need to include in your `Gemfile`:

~~~
gem 'active_model_serializers', '~> 0.10.0'
~~~

Install that by running bundle:

~~~ shell
$ bundle install
~~~

Now there will be a new generator available, called `resource`:

~~~ shell
$ rails g resource manufacturer name:string about:string city:string country:string manufacturer:references

$ rails g resource product name:string description:string product_type:string apv:float image_url:string references:products
~~~

These fields are taken from our API Blueprint documentation, and we already know the types.

~~~ shell
rake db:create db:migrate
~~~

Create and generate the tables from our migrations, turning them into actual schema we can populate using the rails console:

~~~ shell
$ rails console
~~~

~~~ ruby
manufacturer = Manufacturer.create(name: "Thatchers", about: "Pretty solid cider makers who are randomly moving their factories in the south west and going to Ireland...", city: "Dublin", country: "Ireland")

Product.create(manufacturer: manufacturer, name: 'Katies', description: "Unnecessarily strong fizzy cider that sells for the same price as normal ciders.", apv: 7.6, product_type: 'cider')

Product.create(manufacturer: manufacturer, name: 'Thatchers Dry', description: "As the name suggests this is dry, and a little tangy.", apv: 6.5, product_type: 'cider')
~~~

Go look at `./app/controllers` and `./app/serializers` for the rest... more notes later.

Don't forget to make `./config/initializers/serializers.rb` and fill it with:

~~~ ruby
ActiveModelSerializers.config.adapter = :json_api
~~~

Then shove this in `./config/application.rb`:

~~~ ruby
config.after_initialize do
  Rails.application.routes.default_url_options[:host] = ENV['HOST'] || 'localhost:3000'
end
~~~

By the time all thats done, you should have some slick JSON-API output:

~~~ json
{
   "data":{
      "id":"1",
      "type":"manufacturer",
      "attributes":{
         "name":"Thatchers",
         "about":"Pretty solid cider makers that are ditching their factories in the south west and going to Ireland...",
         "city":"Dublin",
         "country":"Ireland"
      },
      "relationships":{
         "products":{
            "data":[
               {
                  "id":"1",
                  "type":"product"
               }
            ]
         }
      },
      "links":{
         "self":"http://localhost:3000/manufacturers/1",
         "products":{
            "href":"/products?manufacturer=1"
         }
      }
   }
}
~~~
