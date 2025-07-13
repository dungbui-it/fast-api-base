.PHONY: deploy destroy

ifeq ($(origin ENV), undefined)
ENV := $(shell read -p "Enter environment (dev/staging/prod): " env && echo $$env)
endif

TFVARS := $(ENV).tfvars
ifeq (,$(wildcard $(TFVARS)))
$(error File $(TFVARS) does not exist)
endif

deploy:
	@echo "🚀 Deploying to environment: $(ENV)"
	terraform init
	terraform apply -var-file=$(TFVARS) -auto-approve

destroy:
	@echo "⚠️ Destroying resources in environment: $(ENV)"
	terraform init
	terraform destroy -var-file=$(TFVARS)
