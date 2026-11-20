MODEL ?= openai/gpt-5.2-codex
template ?= initial-release

bundle_initial-release := .

.PHONY: help update-workflow submit-workflow

help:
	@printf '%s\n' \
	  'make update-workflow [template=name]    Render, lint, and apply the template bundle' \
	  'make submit-workflow REPOSITORY=owner/repo ISSUE=n [MODEL=model] [template=name]' \
	  '                                      Submit and watch a workflow run' \
	  'template defaults to initial-release. Updates support the initial-release bundle.' \
	  'Set ACR to your registry host ending in .azurecr.io. MODEL defaults to openai/gpt-5.2-codex.'

update-workflow:
	$(if $(bundle_$(template)),,$(error No Kustomize bundle configured for template '$(template)'))
	mkdir -p tmp-manifests && kubectl kustomize '$(bundle_$(template))' > tmp-manifests/$(template)-manifests.yaml
	argo lint --offline tmp-manifests/$(template)-manifests.yaml
	kubectl apply -f tmp-manifests/$(template)-manifests.yaml

submit-workflow:
	$(if $(strip $(REPOSITORY)),,$(error REPOSITORY is required))
	$(if $(strip $(ISSUE)),,$(error ISSUE is required))
	$(if $(strip $(ACR)),,$(error ACR is required))
	$(if $(filter-out .azurecr.io,$(filter %.azurecr.io,$(ACR))),,$(error ACR must be a registry host ending in .azurecr.io))
	argo submit --from 'workflowtemplate/$(template)' -n agents \
	  -p acr='$(ACR)' \
	  -p repository='$(REPOSITORY)' \
	  -p issue='$(ISSUE)' \
	  -p model='$(MODEL)' \
	  --watch --log
