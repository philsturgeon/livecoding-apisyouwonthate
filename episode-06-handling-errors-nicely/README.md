Video: https://youtu.be/bHUjkQz6hxI

Handling errors is tough, and often overlooked. A lot of people think returning errors is
just a case of spitting `{ "error": "Whatever went wrong." }` out to the browser with a HTTP
status code, but there is a lot more to it than that. Errors need to be human readable, and computer readable. Outputting a string is a good way to make it human readable, but computers struggle.

A HTTP Status can help computers get an idea of what _sort_ of error is happening, but a status
code is only a category of error. In most applications, multiple errors on the same endpoint could
share the same status code, so an application-specific error code should be used too. More on that
[here](https://philsturgeon.uk/http/2015/09/23/http-status-codes-are-not-enough/).

[JSON-API](http://jsonapi.org/) has some pretty good ideas about [how errors should look](http://jsonapi.org/format/#errors), so let's use that.


Firstly, lets create a convenience method in our `ApplicationController` which will let specify a status code and an error code to create an error:

``` ruby
# app/controllers/application_controller.rb

class ApplicationController < ActionController::Base

  # ...

  def render_json_error(status, error_code, extra = {})
    status = Rack::Utils::SYMBOL_TO_STATUS_CODE[status] if status.is_a? Symbol

    error = {
      title: I18n.t("error_messages.#{error_code}.title"),
      status: status,
      code: I18n.t("error_messages.#{error_code}.code")
    }.merge(extra)

    detail = I18n.t("error_messages.#{error_code}.detail", default: '')
    error[:detail] = detail unless detail.empty?

    render json: { errors: [error] }, status: status
  end

end
```

Then we should populate a locale file, so we have that copy written down:

``` yaml
# config/locale/errors.yml

en:
  error_messages:

    # Products
    product_not_found:
      code: 20101
      title: "Could not find product"
      detail: "This product does not exist, or has been deleted. Product can be removed by manufacturers or admins."

    # Manufacturers
    manufacturers_not_found:
      code: 20201
      title: "Could not find manufacturer"
      detail: "This manufacturer is no longer available."
```

Now, we can call it from any of of controller methods, or rescue in the controller for exceptions we expect to see from multiple methods:

``` ruby
# app/controllers/products_controller.rb

class ProductsController < ApplicationController

  rescue_from ActiveRecord::RecordNotFound do |e|
    render_json_error :not_found, :product_not_found
  end

  # ...

  def show
    product = Product.find(params[:id])
    render json: product
  end

end
```

This covers specifying errors manually, but what about validation messages?

Validation errors should be considered errors, nothing less. A validation error means the thing the caller tried to do didn't work, so that needs to be an error, and it should be as clear as possible what the issue was.

Seeing as we're already using `ActiveModel::Serializer` in other places, it seems only sensible to utilize its built in JSON-API error support.

Let's make another convenience method:

``` ruby
# app/controllers/application_controller.rb

class ApplicationController < ActionController::Base

  # ...

  def render_json_validation_error(resource)
    render json: resource, status: :bad_request, adapter: :json_api, serializer: ActiveModel::Serializer::ErrorSerializer
  end

end
```

This method takes a `resource`, which for the purposes of this video will be an ActiveRecord model, but could be anything that handles `#errors` in a similar fashion.

We can then simply call this method with a resource that has failed to save:

``` ruby
# app/controllers/products_controller.rb

class ProductsController < ApplicationController

  # ...

  def create
    product = Product.new(create_params)

    if !product.save
      render_json_validation_error product
      return
    end

    render json: product, status: :created
  end

end
```

The output that ActiveModel::Serializer gives you is not ideal, but for now its taking care of the basics, and making it clear
what the problems are.

``` json
{
  "errors": [
    {
      "source": {
        "pointer": "/data/attributes/name"
      },
      "detail": "can't be blank"
    },
    {
      "source": {
        "pointer": "/data/attributes/description"
      },
      "detail": "can't be blank"
    }
  ]
}
```

I'll improve on this output at a later time, but this will do for this draft. Onto RSpec testing next!

_Alternative solutions may include [JSONAPI::Resources](https://github.com/cerebris/jsonapi-resources), which can do a lot of JSONAPI related things for you. I've not played with this myself, but intend to in the future._
