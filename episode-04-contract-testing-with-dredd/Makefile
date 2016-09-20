.PHONY: docs_test
docs_test:
		@echo "Seeding database for documentation testing"
		@RAILS_ENV=test rake db:drop db:create db:migrate db:seed:dredd
		@echo "Running dredd... check logs/dredd.log for more information"
		@RAILS_ENV=test dredd > log/dredd.log && echo "Documentation is all good!"
