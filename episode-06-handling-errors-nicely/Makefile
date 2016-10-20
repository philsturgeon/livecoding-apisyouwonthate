.PHONY: docs_test
docs_test: export RAILS_ENV=test
docs_test:
	@echo "Seeding database for documentation tests"
	@rake db:reset db:seed:dredd 1>/dev/null
	@echo "Running dredd. Tail ./log/dredd.log for more output"
	@dredd > log/dredd.log && echo "Documentation is all good!"
