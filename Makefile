SOPS_FILE := "./secrets.yaml"

.DEFAULT: help
help:	## Show this help menu.
	@echo "Usage: make [TARGET ...]"
	@echo ""
	@egrep -h "#[#]" $(MAKEFILE_LIST) | sed -e 's/\\$$//' | awk 'BEGIN {FS = "[:=].*?#[#] "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
	@echo ""


sops:  ## Edit $(SOPS_FILE)
sops:
	@echo "Editing $(SOPS_FILE)"
	@nix-shell -p sops --run "SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt sops $(SOPS_FILE)"

diff:  ## git diff except flake.lock
diff:
	@git diff ':!flake.lock'

mac: ## Nix-darwin switch
mac:
	nix run nix-darwin -- switch -L --flake .

macupdate: ## Nix-darwin switch
macupdate:
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

gc: ## Garbage collect nix store
gc:
	nix store gc --debug

get-packages: ## List all installed packages
get-packages:
	nix-env -qa

