.DEFAULT: help
help:	## Show this help menu.
	@echo "Usage: make [TARGET ...]"
	@echo ""
	@egrep -h "#[#]" $(MAKEFILE_LIST) | sed -e 's/\\$$//' | awk 'BEGIN {FS = "[:=].*?#[#] "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
	@echo ""

mac: ## Nix-darwin witch
mac:
	nix run nix-darwin -- switch -L --flake .

show: ## Flake show
show:
	nix flake show

history: ## View history
history:
	nix profile history --profile /nix/var/nix/profiles/system

delete7: ## Delete versions older than 7 days
delete7:
	nix profile wipe-history --older-than 7d --profile /nix/var/nix/profiles/system

gc: ## Gargage collect nix store
gc:
	nix store gc --debug

get-packages: ## List all installed packages
get-packages:
	nix-env -qa

