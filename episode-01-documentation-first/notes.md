# Episode 1: Documentation First

[Video](https://www.youtube.com/watch?v=Q00H6BPVNQI)

typicode/jsonserver to make a full fake REST API for quick and easy JSON responses, maybe for designers or whatever.

API Blueprint, Swagger (Open API), RAML

Apiary is the hosted solution. Find pricing, see if theres a free account.

``` md
FORMAT: 1A
HOST: https://api.example.com/

# Cider tAPI

GET /message
+ Response 200 (text/plain)

        Hello World!
```

With a basic Hello World of documentation showing up, we now need to build out some realistic  documentation.

Just doing that off the top of your head is tough, so lets make a simple bullet list of resources and attributes that we'd like to see.

For this step, imagine you're working with the whole team, writing up this list of fields in a Dropbox Paper, Google Doc, tmux session, codepad, etc.

``` md
- products
  - name
  - description
  - style
  - apv
  - image_url
  - relationships
    - manufacturer
    - recent_reviews

- manufacturers
  - name
  - about
  - city
  - country

- reviews
  - body
  - rating
  - name
  - relationship
    - user
    - product

- users
  - username
  - full_name
  - email
  - password
```

_Skip having relationships on the user. If you pile too many relationships on the user as they can get really slow. Use links sure, but having all the IDs for each user means it has to make multiple SQL queries for it all. Things get slow._


## Data Structures

Reusable structures that can be put into requests and responses, with basic validation supplied.

We can easily convert the bullet points we just wrote into data structures using API Blueprint syntax:

``` md
# Data Structures

## Products
  - name
  - description
  - style
  - apv
  - image_url
  - relationships
    - manufacturer
    - recent_reviews

## Manufacturers
  - name
  - about
  - city
  - country

## Reviews
  - body
  - rating
  - name
  - relationship
    - user
    - product

## Users
  - username
  - full_name
  - email
  - password
```

Now they'll vanish from the output because they're secret hidden data.

Onto grouping. stuff.

``` md
# Group Section

## Resource Section

### Action Section
```

To put this syntax into action, we can build out our products section.

``` md
# Group Product

## Product Collection [/products]

### Retrieve All [GET]

- Response 200 (application/json)

    - Attributes (array[Product])
```

Next we'll need to add POST. We could manually specify a Body, but instead, let's once again use MSON:

``` md
### Create a Product [POST]

- Request (application/json)

    - Attributes (Product Create)

- Response 201 (application/json)

    - Attributes (Product Full)
```

Then update the data structures:

``` md
# Data Structures

## Product Create (object)
- name: Old Bristolian (string, required) - Name of the product.
- description: Tastes like apple juice but knocks you on your arse. (string,
  required) - Text description of outlininig taste and stuff.
- type: cider (enum[string], required) - Is it made from apples or pears.
    - cider
    - perry
- apv: 7.4 (number, optional)
- image_url: `http://example.com/ciders/old-bris.jpg` (string, optional) - URL
  of cider photo.

## Product Full (object)
- id: djkfh34t234t (string, required) - Unique identifier.
- Include Product Create
- relationships (object)
    - manufacturer
    - recent_reviews
```

To add a filtering endpoint, we can add another GET. API Blueprint will initially be upset about having two of the same HTTP method on the same URI, but for the filter we'd like to change the URI anyway. We can override the URI simply by providing it after the method.

``` md
### Filter Products [GET /products{?type}]

- Parameters

    - type (enum[string], optional) - Should the response return cider, perry or
      all.
        - Default: all
        - Members
            - all
            - cider
            - perry

- Response 200 (application/json)

    - Attributes (array[Product Full])
```

Next up, deleting stuff:

``` md
### Delete a Product [DELETE]

- Response 204
```

Nothing particularly interesting to say there. It does what it says on the tin.

For updates, we can start by documenting the happy path.

```

### Update a Product [PATCH]

- Request (application/json)

    - Attributes (Product Update)

- Response 200 (application/json)

    - Attributes (Product Full)
        - type: perry

```

Here we send a new data structure, much like Product Create:

```
## Product Update (object)
- type: perry
```

When we send this update, we can expect a response to come back, which will be the normal `Product Full`, but with the type value overridden to be perry now.

If we wanted to show off successful and unsuccessful values, we could do that with having Multiple Transactions. Transactions in API Blueprint are the same as transactions in the world of HTTP in general: the pairing of a request and a response. You can have as many transactions as you like under your Action, by providing an arbitrary string as a name after the `Request` keyword.

``` md
### Update a Product [PATCH]

- Request Successful Update (application/json)

    - Attributes (Product Update Valid)

- Response 200 (application/json)

    - Attributes (Product Full)
        - type: perry

- Request Unsuccessful Update (application/json)

    - Attributes (Product Update Invalid)

- Response 422 (application/json)

    - Attributes (Error Unprocessable Entity)
        - message: `This was an invalid type, please select from cider or
          perry.`
        - attribute: type
```

Here we have a few new data structures: `Product Update Valid`, `Product Update Invalid`, and `Error Unprocessable Entity`. They're simple enough:

``` md
# Data Structures

...

## Product Update Valid (object)
- type: perry

## Product Update Invalid (object)
- type: wine

## Error Unprocessable Entity (object)
- title: Unprocessable Entity
- message: This resource could not be updated due to invalid arguments being
  passed.
```

Fin.
