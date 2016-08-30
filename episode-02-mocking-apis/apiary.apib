FORMAT: 1A
HOST: https://api.example.com

# Cider tAPI

Welcome to the documentation, we'll bla bla.

# Group Product

## Product Collection [/products]

- Attributes (Product Full)

### Retrieve All Products [GET]

- Request (application/json)

- Response 200 (application/json)

    - Attributes (array[Product Full])

### Filter Products [GET /products{?type}]

- Attributes (Product Full)

- Parameters

    - type (enum[string], optional) - Should the response return cider, perry or
      all.
        - Default: all
        - Members
            - all
            - cider
            - perry

- Request (application/json)

- Response 200 (application/json)

    - Attributes (array[Product Full])

### Create a Product [POST]

- Request (application/json)

    - Attributes (Product Create)

- Response 201 (application/json)

    - Attributes (Product Full)

## Product Resource [/products/{id}]

- Parameters
    - id: `d66c7429-d8e0-4772-85b4-c18e66564e88` (string, required) - UUID for this product.

- Attributes (Product Full)

### Update a Product [PATCH]

- Request Successful Update (application/json)

    - Attributes (Product Update Valid)

- Response 201 (application/json)

    - Attributes (Product Full)
        - type: perry

- Request Unsuccessful Update (application/json)

    - Attributes (Product Update Invalid)

- Response 422 (application/json)

    - Attributes (Error Unprocessable Entity)
        - message: `This was an invalid type, please select from cider or
          perry.`
        - attribute: type

### Delete a Product [DELETE]

- Response 204

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

## Product Update Valid (object)
- type: perry

## Product Update Invalid (object)
- type: wine

## Product Full (object)
- id: `d66c7429-d8e0-4772-85b4-c18e66564e88` (string, required) - UUID for this product.
- Include Product Create
- relationships (object)
    - manufacturer
    - recent_reviews

## Manufacturer (object)
- name
- about
- city
- country

# Review (object)
- body
- rating
- name
- relationship (object)
    - user
    - product

# User (object)
- username
- name
- email
- password

## Error Unprocessable Entity (object)
- title: Unprocessable Entity
- message: This resource could not be updated due to invalid arguments being
  passed.
