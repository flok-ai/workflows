MODEL ?= openai/gpt-5.2-codex

.PHONY: help kustomize submit

help:
	@printf '%s\n' \
	  'make kustomize                                  Render, lint, and apply the bundle' \
	  'make submit REPOSITORY=owner/repo ISSUE=n [MODEL=model]' \
	  '                                                Submit and watch initial-release' \
	  'Set ACR in the environment. MODEL defaults to openai/gpt-5.2-codex.'

kustomize:
	mkdir -p tmp-manifests && kubectl kustomize . > tmp-manifests/initial-release-manifests.yaml
	argo lint --offline tmp-manifests/initial-release-manifests.yaml
	kubectl apply -f tmp-manifests/initial-release-manifests.yaml

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
