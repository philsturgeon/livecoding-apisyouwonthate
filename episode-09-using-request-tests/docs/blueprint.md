FORMAT: 1A
HOST: https://api.example.com

# Cider tAPI

Welcome to the documentation, we'll bla bla.

# Group Product

## Product Collection [/products]

- Attributes (Product Full)

### Retrieve All [GET]

- Request (application/json; charset=utf-8)

- Response 200 (application/json; charset=utf-8)

    - Attributes (object)
        - data (array[Product Full])

### Filter [GET /products{?type,manufacturer_id}]

- Parameters

    - manufacturer_id: `54f5208f-b3e1-4712-a3b9-4b7dda7da445` (string, optional) - Restrict returned products to a specific manufacturer by their UUID.
    - type: all (enum[string], optional) - Should the response return cider, perry or
      all products.
        - all
        - cider
        - perry

- Request (application/json; charset=utf-8)

- Response 200 (application/json; charset=utf-8)

    - Attributes (object)
        - data (array[Product Full])

### Create resource [POST]

- Request (application/json; charset=utf-8)

    - Attributes (Product Create)

- Response 201 (application/json; charset=utf-8)

    - Attributes (Product Full)

## Product Resource [/products/{id}]

- Parameters
    - id: 1 (string, required) - UUID for this product.

- Attributes (Product Full)


### Retrieve resource [GET]

- Request (application/json; charset=utf-8)

- Response 200 (application/json; charset=utf-8)

    - Attributes (object)
        - data (Product Full)
            - relationships
               - manufacturer (ManufacturerLink Single)

### Update resource [PATCH]

- Request Successful Update (application/json; charset=utf-8)

    - Attributes (Product Update Valid)

- Response 201 (application/json; charset=utf-8)

    - Attributes (Product Full)
        - type: perry

- Request Unsuccessful Update (application/json; charset=utf-8)

    - Attributes (Product Update Invalid)

- Response 422 (application/json; charset=utf-8)

    - Attributes (Error Unprocessable Entity)
        - message: `This was an invalid type, please select from cider or
          perry.`
        - attribute: type

### Delete resource [DELETE]

- Response 204


# Group Manufacturer

## Manufacturer Collection [/manufacturers]

- Attributes (Manufacturer Full)

### Retrieve All [GET]

- Request (application/json; charset=utf-8)

- Response 200 (application/json; charset=utf-8)

    - Attributes (object)
        - data (array[Manufacturer Full])

### Create resource [POST]

- Request (application/json; charset=utf-8)

    - Attributes (Manufacturer Create)

- Response 201 (application/json; charset=utf-8)

    - Attributes (Manufacturer Full)

## Manufacturer Resource [/manufacturers/{id}]

- Parameters
    - id: `d66c7429-d8e0-4772-85b4-c18e66564e88` (string, required) - UUID for this product.

- Attributes (Manufacturer Full)

### Update resource [PATCH]

- Request Successful Update (application/json; charset=utf-8)

    - Attributes (Manufacturer Update Valid)

- Response 201 (application/json; charset=utf-8)

    - Attributes (Manufacturer Full)
        - name: `Fancy New Cider Brewery`

- Request Unsuccessful Update (application/json; charset=utf-8)

    - Attributes (Manufacturer Update Invalid)

- Response 422 (application/json; charset=utf-8)

    - Attributes (Error Unprocessable Entity)
        - message: `The name field is required.`
        - attribute: name

### Delete resource [DELETE]

- Response 204


# Group Review

## Review Collection [/reviews]

- Attributes (Review Full)

### Filter [GET /reviews{?product_id}]

- Parameters

    - product_id: `d66c7429-d8e0-4772-85b4-c18e66564e88` (string, required) - The product UUID for reviews.

- Request (application/json; charset=utf-8)

- Response 200 (application/json; charset=utf-8)

    - Attributes (object)
        - data (array[Review Full])

### Create resource [POST]

- Request (application/json; charset=utf-8)

    - Attributes (Review Create)

- Response 201 (application/json; charset=utf-8)

    - Attributes (Review Full)

## Review Resource [/reviews/{id}]

- Parameters
    - id: `d66c7429-d8e0-4772-85b4-c18e66564e88` (string, required) - UUID for this review.

- Attributes (Review Full)

### Delete resource [DELETE]

- Response 204


# Data Structures

## Product Create (object)
- type: product (string, required)
- attributes (object, required)
    - name: Old Bristolian (string, required) - Name of the product.
    - description: Tastes like apple juice but knocks you on your arse. (string,
      required) - Text description of outlining taste and stuff.
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
- Include Product Create
- id: `d66c7429-d8e0-4772-85b4-c18e66564e88` (string, required) - UUID for this product.
- relationships
   - manufacturer (ManufacturerLink Multiple)
- links (object)
    - self: `http://api.example.com/products/1`
    - manufacturer: `http://api.example.com/manufacturers/1`

## ManufacturerLink Single (object)
   - data (object)
       - id: 1 (string)
       - type: manufacturer (string)

## ManufacturerLink Multiple (object)
   - data (array)
       - (object)
           - id: 1 (string)
           - type: manufacturer (string)

## Manufacturer Create (object)
- name
- about
- city
- country

## Manufacturer Full (object)
- id: `54f5208f-b3e1-4712-a3b9-4b7dda7da445` (string, required) - UUID for this manufacturer.
- Include Manufacturer Create
- relationships (object)
    - top_products

## Manufacturer Update Valid (object)
- name: `Fancy New Cider Brewery`

## Manufacturer Update Invalid (object)
- name: ``

# Review Create (object)
- body
- rating
- name
- relationship (object)
    - user
    - product

# Review Full (object)
- id: `99f7cc7c-5b3d-4097-8ea0-c24b4693cecb` (string, required) - UUID for this review.
- Include Manufacturer Create
- relationships (object)
    - top_products

# User Create (object)
- username
- name
- email
- password

## Error Unprocessable Entity (object)
- title: Unprocessable Entity
- message: This resource could not be updated due to invalid arguments being
  passed.
