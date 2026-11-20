MODEL ?= openai/gpt-5.2-codex

.PHONY: help apply submit

help:
	@printf '%s\n' \
	  'make apply                                      Render, lint, and apply the bundle' \
	  'make submit REPOSITORY=owner/repo ISSUE=n [MODEL=model]' \
	  '                                                Submit and watch initial-release' \
	  'Set ACR in the environment. MODEL defaults to openai/gpt-5.2-codex.'

apply:
	mkdir -p tmp && kubectl kustomize . > tmp/initial-release-manifests.yaml
	argo lint --offline tmp/initial-release-manifests.yaml
	kubectl apply -f tmp/initial-release-manifests.yaml

submit:
	$(if $(strip $(REPOSITORY)),,$(error REPOSITORY is required))
	$(if $(strip $(ISSUE)),,$(error ISSUE is required))
	$(if $(strip $(ACR)),,$(error ACR is required))
	argo submit --from workflowtemplate/initial-release -n agents \
	  -p acr='$(ACR)' \
	  -p repository='$(REPOSITORY)' \
	  -p issue='$(ISSUE)' \
	  -p model='$(MODEL)' \
	  --watch --log
