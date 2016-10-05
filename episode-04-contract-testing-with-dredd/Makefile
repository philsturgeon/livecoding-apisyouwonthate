.PHONY: docs_test
docs_test: export RAILS_ENV=test
docs_test: docs_transclude
	@echo "Seeding database for documentation tests"
	@rake db:reset 1>/dev/null
	@rake db:seed:dredd
	@echo "Running dredd. Tail ./logs/dredd.log for more output"
	@dredd > log/dredd.log && echo "Documentation is all good!"
