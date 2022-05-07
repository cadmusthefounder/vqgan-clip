.DEFAULT_GOAL := help


## Don't worry! We've got you covered.
.PHONY: help
help:
	@printf "Usage\n";

	@awk '{ \
			if ($$0 ~ /^.PHONY: [a-zA-Z\-\_0-9]+$$/) { \
				helpCommand = substr($$0, index($$0, ":") + 2); \
				if (helpMessage) { \
					printf "\033[36m%-20s\033[0m %s\n", \
						helpCommand, helpMessage; \
					helpMessage = ""; \
				} \
			} else if ($$0 ~ /^[a-zA-Z\-\_0-9.]+:/) { \
				helpCommand = substr($$0, 0, index($$0, ":")); \
				if (helpMessage) { \
					printf "\033[36m%-20s\033[0m %s\n", \
						helpCommand, helpMessage; \
					helpMessage = ""; \
				} \
			} else if ($$0 ~ /^##/) { \
				if (helpMessage) { \
					helpMessage = helpMessage"\n                     "substr($$0, 3); \
				} else { \
					helpMessage = substr($$0, 3); \
				} \
			} else { \
				if (helpMessage) { \
					print "\n                     "helpMessage"\n" \
				} \
				helpMessage = ""; \
			} \
		}' \
		$(MAKEFILE_LIST)


## -- Deployment --


## -- Utility --


## Run formatters and linters.
##
.PHONY: pre-commit
pre-commit:
	@poetry run pre-commit run


## Run formatters and linters on all files.
##
.PHONY: pre-commit-all
pre-commit-all:
	@poetry run pre-commit run --all-files

## Write commit messages.
##
.PHONY: commit
commit: pre-commit
	@poetry run cz commit || (echo "Message commited!"; exit 0)


## Remove __pycache__ folder and *.pyc files.
##
.PHONY: clean
clean:
	@find . -type f -name "*.py[co]" -delete
	@find . -type d -name "__pycache__" -delete


## -- Dependency --


## List python dependencies. Defaults to current directory.
##
.PHONY: list
list:
	@poetry show --tree


## Install project dependencies.
##
.PHONY: install
install:
	@poetry install
	@poetry run pre-commit install


## -- Test --

## Run unit tests.
##
.PHONY: unit
unit:
	@poetry run pytest tests/unit -v -s
