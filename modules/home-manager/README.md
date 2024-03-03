# Niv 

[niv](https://github.com/nmattia/niv) is a painless dependencies for nix project 


## Init

Basic file initialization without nixpkg sources

```bash
$ niv init --no-nixpkgs
Initializing
  Creating nix/sources.nix
  Creating nix/sources.json
  Not importing 'nixpkgs'.
Done: Initializing
```

## Add sample

Sample with astronvim:

```bash
niv add AstroNvim/AstroNvim --name astronvim --branch v3.44.1
```

## Update sample

Sample with astronvim:


```bash
niv update astronvim --branch <tag>
```

