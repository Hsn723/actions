.PHONY: update-dependency-whitelist
update-dependency-whitelist: setup-aqua
	ACTIONS=$$(find .github/actions/ -mindepth 1 -type d); \
	WORKFLOWS=$$(find .github/workflows -type f -name "*.yml"); \
	WHITELIST=$$(printf 'pkg:githubactions/hsn723/actions/%s\n' $${ACTIONS} $${WORKFLOWS}) ; \
	WHITELIST="$${WHITELIST}" yq -i '(.jobs.dependency-review.steps[] | select(has("with")) | .with | select(has("allow-dependencies-licenses")) | .allow-dependencies-licenses) = strenv(WHITELIST)' .github/workflows/verify.yml

.PHONY: setup-aqua
setup-aqua:
	AQUA_VERSION=$$(grep -oP "(?<=aqua_version: )v\d+\.\d+\.\d+" .github/actions/setup-aqua/action.yml) ;\
	@if [ ! -x "$(shell command -v aqua)" ]; then \
		go install github.com/aquaproj/aqua/v2/cmd/aqua@$(AQUA_VERSION) ;\
	fi
	aqua i -l -c .github/actions/setup-aqua/aqua.yaml
