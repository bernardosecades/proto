DATE    ?= $(shell date +%FT%T%z)

GO      = go
GODOC   = godoc
GOFMT   = gofmt
TIMEOUT = 15
ROOT_MODULE = protobuf
MODULES = $(shell find ./$(ROOT_MODULE) -type d)
LANGS   = go #python node
CMDSEP  = ;
$(BASE): \
    @mkdir -p $(dir $@) \
    @ln -sf $(CURDIR) $@

define generate_proto_lang
    docker run --rm --user $(shell id -u):$(shell id -g) -v $(CURDIR):/defs namely/protoc-all:1.32_2 --go-source-relative -i $(ROOT_MODULE)/ -f $1 -l $2 -o $2
endef
define generate_proto
    $(foreach lang, $(LANGS), $(call generate_proto_lang, $(1), $(lang)) $(CMDSEP))
endef
define iterate_files
    $(foreach file, $(wildcard $(1)/*.proto), $(call generate_proto, $(file)))
endef
define iterate_modules
    $(foreach module, $(MODULES), $(call iterate_files, $(module)))
endef

## Generate Proto
proto: ; $(info $(M) generating proto for $(LANGS)) @ \
    $(call iterate_modules)

## Setup for development
setup: ; $(info $(M) setup for development) @ \
    rm -rf .git/hooks/pre-push; \
    ln -s ../../.githooks/pre-push .git/hooks/pre-push; \
    chmod +x .githooks/pre-push; \

.PHONY: proto setup

# -- help

# COLORS
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
RESET  := $(shell tput -Txterm sgr0)
TARGET_MAX_CHAR_NUM=20
## Show help
help:
	@echo ''
	@echo 'Usage:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "  ${YELLOW}%-$(TARGET_MAX_CHAR_NUM)s${RESET} ${GREEN}%s${RESET}\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)
