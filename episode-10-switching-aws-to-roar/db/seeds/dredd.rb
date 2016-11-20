
manufacturer = Manufacturer.create(name: "Thatchers", about: "Pretty solid cider makers who are randomly moving their factories in the south west and going to Ireland...", city: "Dublin", country: "Ireland")

Product.create(manufacturer: manufacturer, name: 'Katies', description: "Unnecessarily strong fizzy cider that sells for the same price as normal ciders.", apv: 7.6, product_type: 'cider')

Product.create(manufacturer: manufacturer, name: 'Thatchers Dry', description: "As the name suggests this is dry, and a little tangy.", apv: 6.5, product_type: 'cider')
