{ inputs, config, ...}:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = ../../../secrets.yaml;
    validateSopsFiles = false;

    age = {
      # automatically import host SSH keys as age keys
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      # this wil use an age key that is expected to already be in the filesytem
      keyFile = "/var/lib/sops-nix/key.txt";
      # generate new key if the key specified above does not exists
      generateKey = true;
    };

    # secrets will be output to /run/secrets
    # e.g. /run/secrets/p1.hostname
    # secrets required for user creation are handled in repsective ./users/<username>.nix files
    # becasue the wil be output to /run/secrets-for-users- and only when the user is assigned to a host.
    secrets = {
      sample = {};
    };
  };

}
