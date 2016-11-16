# Episode 8: Testing Endpoints with RSpec (Continued)

Video: https://youtu.be/Q5DA8EFTIWw

* Unit Testing - Models, libraries, services, controllers. Attempt to mock out database interactions whenever possible, but do not allow web requests over the wire. Mock and stub any ruby HTTP clients, RabbitMQ workers, sidekiq jobs, etc. Unit tests should be pretty quick, because they fake a lot of slow things. Intent of these tests is to confirm business logic and communication between classes. One test at each layer, so test class A attempts to talk to B correctly, but do not run B and check the result. That's another test for class B.

* Integration (Rspec type: requests) - When a HTTP call is made with valid oauth tokens, it'll show you the right resources from the database, and maybe try to contact a third-party service. Or you can use Webmock, VCR to record valid responses from third parties, and replay them.

* End to End - Multiple systems (frontend, api, multiple HTTP services, etc) all fit together. Runscope Ghost Inspect can help with that.


TODO note:

- Insert more notes. 
- JSON pointers seem to use hyphens, but we use underscores.
- passing in serializer renamed fields in deserialization doesn't work with AMS. Short of using services just to handle input massaging, maybe switch to Roar. This has always annoyed me, and Roar can handle it.
