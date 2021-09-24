# Protobuf Library

Example of repo to share protobuf between microservices

## Development

### Setup

Make sure you have the webhooks installed:

```bash
make setup
```

### Usage of common/protobuf definitions

All protobuf definitions under protobuf/common are for global usage.

### Guidelines

Make sure you apply the [defined style guide](https://developers.google.com/protocol-buffers/docs/style)
to your protobuf definitions.

Keep in mind the following rules to prevent introducing breaking changes:

* **Never** delete/rename a field from an existing message. Just mark it as deprecated;
* **Never** change the field number;
* **Never** renaming service endpoints;
* **Never** renaming message names;

Before you commit make sure you run `make proto` to compile the protos.

### Add support for a new language

To add support for a new language, let's say **python**, we need to add it to:

* Makefile: append `python` to the variable `LANGS`;
* .githooks/pre-push: set new language under protobuf languages final result
should be `set -- "go/protobuf" "python/protobuf"`

### Make file

To generate protobuffers in specific language you can execute

- `make proto`

By default only will generate for golang but you can add another language if you want

## Versioning

In order to release a new version of this repo the recommended flow is that you create
a new release in github.
