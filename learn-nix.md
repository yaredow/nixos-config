# Learning Nix & NixOS, From Scratch

> A guide for an Arch/Omarchy user who wants to actually understand Nix — not just copy someone else's config.

## How to use this guide

Don't read this top to bottom in one sitting. It's built to be worked through **one stage at a time**, over about four weeks. Each stage has:
- A plain-English explanation of the idea
- Real commands to run
- A small hands-on exercise
- A couple of links if you want to go deeper

Do the exercise before moving to the next stage. Skimming the theory without running the commands is exactly how you ended up stuck last time.

---

## Table of Contents

1. [Why Your First Attempt Burned You Out](#why-your-first-attempt-burned-you-out)
2. [Glossary — Keep This Open in a Tab](#glossary--keep-this-open-in-a-tab)
3. [The 4-Week Plan](#the-4-week-plan)
4. [Stage 1: What Makes Nix Different](#stage-1-what-makes-nix-different)
5. [Stage 2: Using Nix as Just a Tool](#stage-2-using-nix-as-just-a-tool)
6. [Stage 3: The Nix Language](#stage-3-the-nix-language)
7. [Stage 4: How Packages Actually Get Built](#stage-4-how-packages-actually-get-built)
8. [Stage 5: Nixpkgs — Finding and Changing Packages](#stage-5-nixpkgs--finding-and-changing-packages)
9. [Stage 6: NixOS — Configuring the Whole System](#stage-6-nixos--configuring-the-whole-system)
10. [Stage 7: Flakes](#stage-7-flakes)
11. [Stage 8: Home Manager — Your Dotfiles](#stage-8-home-manager--your-dotfiles)
12. [Stage 9: Extras — Custom Scripts, Secrets, and One Thing to Avoid](#stage-9-extras--custom-scripts-secrets-and-one-thing-to-avoid)
13. [Common Mistakes and How to Read the Errors](#common-mistakes-and-how-to-read-the-errors)
14. [Where to Go for More](#where-to-go-for-more)

---

## Why Your First Attempt Burned You Out

You already know Linux well. You know `systemd`, you know how `pacman` installs things into `/usr`, you've hand-written dotfiles and linked them with Stow.

Last time, you cloned someone's NixOS + Hyprland setup, swapped in your own hostname and a few settings, and had a working desktop in two days. That's normal — Nix configs are very copy-pasteable. The problem came later, when something broke:

- `error: The option 'X' does not exist`
- `error: infinite recursion encountered`
- A new file you created wasn't picked up by the build
- `error: attribute 'foo' missing`

On Arch, you'd know exactly where to look — the log file, the PKGBUILD, `strace`. On Nix, none of that applied, because you'd never actually learned the thing you'd copied. That's not a personal failing — it's what happens when you skip the fundamentals of a genuinely different system.

This guide is built to fix that, by teaching the fundamentals **before** the copy-paste config makes sense.

---

## Glossary — Keep This Open in a Tab

Nix reuses normal-sounding English words for very specific technical things. This trips people up constantly. Skim this now, then come back whenever a term in the guide is unfamiliar.

| Term | Plain-English meaning |
| :--- | :--- |
| **Store path** | A folder inside `/nix/store/` where one specific version of one specific piece of software lives, e.g. `/nix/store/5x8...-hello-2.12.1`. Nothing here ever changes once it's built. |
| **Derivation** | The build recipe for one store path — what to download, what to run, what environment to use. Think "a very strict, hash-locked PKGBUILD." |
| **Closure** | A store path plus everything it actually needs at runtime (its libraries, and their libraries, and so on). |
| **Nix expression** | A piece of code written in the Nix language. It evaluates to a value — a string, a list, a set of settings, or a package. |
| **Attribute set** | Nix's version of a dictionary/object: `{ key = value; }`. |
| **Flake** | A folder with a `flake.nix` and a `flake.lock` file that fully pins down what a project needs, with no hidden dependencies on your machine's state. |
| **Profile** | A symlink pointing at whichever version of your installed packages is "current" right now. |
| **Generation** | A numbered snapshot of your system or profile. Every rebuild creates a new one. Rolling back just points back to an older one. |
| **Channel** | The older, pre-flakes way of pulling in Nixpkgs. Less precise than flakes — can quietly change under you. |
| **Overlay** | A way to globally patch or add to the package collection, so every package that depends on the thing you changed sees your version. |
| **Module** | A `.nix` file that defines settings (and optionally new options) for NixOS or Home Manager. |
| **IFD (Import From Derivation)** | Building something *during* the planning phase, just to read its output before continuing. Usually a performance trap — covered in Stage 9. |
| **Purity** | "This only depends on what it explicitly says it depends on" — no reading random files, no calling the internet, no reading environment variables. |
| **Garbage collection** | Deleting store paths nothing references anymore, to free disk space. |

---

## The 4-Week Plan

Meant for full days of study. Check things off as you actually *do* them, not just read them.

### Week 1 — Mental model, plain Nix, the language
- [ ] Stage 1: Understand what's actually different about Nix vs. Arch
- [ ] Stage 2: Install standalone Nix, try `nix shell`, `nix run`, `nix develop`
- [ ] Stage 2: Clean up disk space with `nix-collect-garbage -d`
- [ ] Stage 3: Work through the Nix language in `nix repl`
- [ ] Stage 3: Understand laziness (why Nixpkgs can have 100k+ packages and stay fast)

### Week 2 — How packages get built, how Nixpkgs works
- [ ] Stage 4: Write and build a tiny package by hand
- [ ] Stage 4: Look at a real `.drv` file and a real closure
- [ ] Stage 5: Learn `callPackage`, `.override`, `.overrideAttrs`
- [ ] Stage 5: Write your first overlay

### Week 3 — NixOS itself, then flakes
- [ ] Stage 6: Understand modules, options vs. config
- [ ] Stage 6: Know exactly what `nixos-rebuild switch` does, step by step
- [ ] Stage 6: Practice rolling back a generation
- [ ] Stage 7: Understand `flake.nix`, `flake.lock`, and `follows`
- [ ] Stage 7: Convert something small into a flake yourself

### Week 4 — Home Manager, extras, and putting it together
- [ ] Stage 8: Set up Home Manager, migrate one real dotfile from your old Omarchy setup
- [ ] Stage 9: Package a small script, look at secrets management, understand IFD
- [ ] **Capstone**: Build your own NixOS + Home Manager config from scratch — no copy-pasting

---

## Stage 1: What Makes Nix Different

### The idea

On Arch, installing software **changes your system in place**. `pacman -S` writes files into `/usr`, `/etc`, wherever they go. Over time your install becomes a unique snowflake — the exact state depends on every command you've ever run, in order. If your disk dies, recreating that exact state means remembering everything you did.

Nix does the opposite. Instead of mutating your system, every package and every configuration is the **output of a calculation**. Give Nix the same inputs, and it always produces the exact same result — same files, same versions, byte for byte. Nothing gets modified in place; a new result is built alongside the old one, and only then does your system switch over to it.

That's really the whole idea. Everything else in this guide is a consequence of that one design choice.

### Where it actually lives on disk

Normal Linux distros put everything into shared folders — `/usr/bin` for programs, `/usr/lib` for libraries. If two programs need different versions of the same library, that's a real problem, because there's only one `/usr/lib`.

Nix skips this entirely. Every single package — every version, every build — gets its own folder under `/nix/store/`, named using a hash of everything that went into building it:

```
/nix/store/<hash>-<package-name>-<version>
```

Because every version lives in its own separate folder, you can have five different Python versions installed side by side and nothing conflicts. Nothing you install can quietly break something else, because nothing shares a folder.

You can see this for yourself:

```bash
ldd $(which git)
```

Instead of paths like `/usr/lib/libssl.so`, you'll see every dependency pointing at its own unique `/nix/store/<hash>-...` folder.

### Quick comparison

| | Arch / Omarchy | Nix / NixOS |
| :--- | :--- | :--- |
| Installing a package | Modifies `/usr` in place | Builds a new, separate folder in `/nix/store` |
| Custom/third-party packages | AUR + PKGBUILD | Your own package definitions, or overlays |
| System config | Scattered across `/etc/*` | One (or a few) `.nix` files |
| Dotfiles | Hand-written, linked with Stow | Managed by Home Manager |
| Updating | `pacman -Syu`, changes running system directly | Build a new system, then switch to it |
| Rolling back | Snapshots (if you set them up) or manual downgrades | Built in — just boot the previous generation |

### Try it

```bash
ls -ld /nix/store          # see the store itself
ls -l /run/current-system  # this symlink is your entire current OS
```

### Go deeper
- [Nix Pills — Why You Should Give It a Try](https://nixos.org/guides/nix-pills/01-why-you-should-give-it-a-try)
- [nix.dev — What is Nix?](https://nix.dev)

---

## Stage 2: Using Nix as Just a Tool

### The idea

Don't touch NixOS yet. Nix the *package manager* works fine on plain Arch, Ubuntu, or macOS — install it standalone and get comfortable with it there first. This matters because when something eventually breaks on NixOS, you want to already know whether the problem is "a Nix thing" or "a NixOS thing." Learning both at once makes every bug ambiguous.

### Install it

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### Three ways to run software, and when to use each

**Just need something for a minute or two?** Open a temporary shell. It disappears the moment you exit — nothing is left installed.
```bash
nix shell nixpkgs#ripgrep nixpkgs#jq
```

**Just want to run one command once?**
```bash
nix run nixpkgs#cowsay -- "hello from nix"
```

**Working on a project that needs specific compilers/tools?** Define them in a `shell.nix`, and everyone working on the project gets the exact same environment:
```nix
{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [ pkgs.clang pkgs.cmake pkgs.boost ];
}
```
```bash
nix-shell
# or, with flakes: nix develop
```

**Want something installed permanently, like on Arch?**
```bash
nix profile install nixpkgs#neovim
nix profile list
nix profile remove <name>
```

### Cleaning up disk space

Old, unused builds stick around in `/nix/store` so re-running something is instant. To reclaim the space:

```bash
nix-collect-garbage -d   # remove anything not currently in use
nix store optimise       # dedupe identical files across packages
```

### Try it

1. `nix-shell -p python311 curl` — confirm Python 3.11 is available inside.
2. Type `exit`. Confirm `python311` is gone from your `$PATH`.
3. Run `nix-collect-garbage` and watch it clean up.

### Go deeper
- [nix.dev — Development environments](https://zero-to-nix.com/concepts/dev-env)
- [Nix manual — nix-shell](https://nixos.org/manual/nix/stable/command-ref/nix-shell.html)

---

## Stage 3: The Nix Language

### The idea

This is the part people skip, and it's the part that actually unlocks everything. Nix configs aren't YAML-style settings files — they're a small **programming language**. Once you can read that language fluently, a 500-line NixOS config stops looking like magic and starts looking like normal code.

Open a REPL and follow along — type each example in yourself:

```bash
nix repl
```

### Values

```nix
42                        # a number
true                      # a boolean
"hello"                   # a string
name = "arch"
"hi ${name}"              # string interpolation -> "hi arch"
```

Multiline strings use two single quotes, and strip shared leading whitespace automatically:
```nix
''
  line one
  line two
''
```

Paths are their own type, not just strings:
```nix
./flake.nix
/etc/nixos
```

> One important gotcha: if you interpolate a path into a string, Nix **copies that file into `/nix/store`** and gives you back the resulting store path. This is how local files like wallpapers or scripts get pulled into the immutable store.

### Lists and attribute sets

Lists use spaces, not commas:
```nix
[ 1 2 "three" true ]
```

Attribute sets are Nix's dictionaries:
```nix
user = { name = "yada"; shell = "fish"; }
user.name          # "yada"
```

Nested sets can be written flat — these two are identical:
```nix
{ networking.hostName = "loki"; }
{ networking = { hostName = "loki"; }; }
```

### `let`, `rec`, and `with`

`let ... in` just defines local variables:
```nix
let
  pkgName = "hyprland";
  version = "0.40.0";
in "${pkgName}-${version}"
```

Normal attribute sets **can't** reference their own keys. `rec` fixes that:
```nix
rec { a = 1; b = a + 1; }   # { a = 1; b = 2; }
```

`with` pulls all the names out of a set into scope:
```nix
let tools = { git = "2.44"; }; in
with tools; [ git ]
```

> **Careful with `with`.** It's common in old tutorials, but it hides where a name actually came from, and it can quietly clash with a local variable of the same name. Prefer writing `pkgs.git` explicitly, or use `inherit`. More on this in [Common Mistakes](#common-mistakes-and-how-to-read-the-errors).

### Functions

Every Nix function takes exactly **one** argument. Multiple arguments are done by chaining functions (this is called currying):
```nix
double = x: x * 2
double 21            # 42

add = x: y: x + y
add 10 5              # 15
```

Because functions only take one argument, when you see a function that needs several *named* inputs, it's actually taking one attribute set and unpacking it:
```nix
greet = { name, greeting ? "hi" }: "${greeting}, ${name}!"
greet { name = "yada"; }              # "hi, yada!"
```

`?` sets a default value. `...` says "allow extra fields I don't care about":
```nix
relaxed = { name, ... }: "user is ${name}"
relaxed { name = "yada"; extra = "ignored"; }   # works fine
```

### Laziness

Nix only computes a value when something actually asks for it:

```nix
set = { a = 10; b = builtins.abort "boom"; }
set.a      # 10, no error
set.b      # *now* it explodes
```

This is why Nixpkgs can define 100,000+ packages in one giant set without being slow — asking for `pkgs.ripgrep` never touches the other 99,999.

### Try it

1. Write a function `makeHost` taking `{ hostname, ip, ram ? 16 }` that returns a description string.
2. Given `[ "hyprland" "waybar" "kitty" ]`, use `builtins.map` to prefix every item with `"omarchy-"`.
3. Prove laziness to yourself: put a broken expression in an unused attribute, and confirm accessing a *different* key still works fine.

### Go deeper
- [nix.dev — Nix language tutorial](https://nix.dev/tutorials/nix-language)
- [Nix manual — the language](https://nixos.org/manual/nix/stable/language/)

---

## Stage 4: How Packages Actually Get Built

### The idea

On Arch, `makepkg` runs a bash script (the PKGBUILD) and hopes for the best — if you happen to have `clang` installed, the build might silently use it even though it wasn't declared as a dependency.

Nix doesn't hope. Every build happens in an **isolated sandbox**: no network access, no access to anything on your machine that wasn't explicitly listed. The build recipe for this is called a **derivation**.

### A derivation, stripped down to the basics

```nix
d = derivation {
  name = "my-package";
  system = "x86_64-linux";
  builder = "/bin/sh";
  args = [ "-c" "echo 'hello' > $out" ];
}
```

When Nix *builds* this, it:
1. Sets up an isolated temp folder
2. Sets `$out` to a specific `/nix/store/...` path
3. Disables network access
4. Runs the builder command
5. Whatever ends up in `$out` becomes that permanent store path

Nobody writes raw derivations like this by hand in practice — instead, everyone uses `stdenv.mkDerivation`, which adds the standard build steps (unpack, configure, build, install) automatically:

```nix
stdenv.mkDerivation rec {
  pname = "mytool";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "example"; repo = "mytool"; rev = "v${version}";
    hash = "sha256-AAAA...=";
  };
  buildInputs = [ ];        # runtime libraries
  nativeBuildInputs = [ ];  # build-time tools like cmake
}
```

### Looking at real derivations

```bash
nix derivation show nixpkgs#hello       # see the build recipe
nix-store -q --references $(which bash) # see its dependencies
nix path-info -rsh nixpkgs#hyprland     # see the full closure size
```

### One subtlety worth knowing: what actually gets kept at runtime

A build might *need* a compiler to build, but the compiler doesn't need to stick around afterward. Nix figures this out automatically: after the build finishes, it scans the resulting files for any `/nix/store/<hash>` paths that got baked in (for example, in a binary's library path). Whatever shows up gets kept as a real dependency; whatever doesn't (like the compiler) gets dropped.

### Try it

Create `simple.nix`:
```nix
let pkgs = import <nixpkgs> {}; in
pkgs.stdenv.mkDerivation {
  name = "omarchy-greeting";
  src = builtins.toFile "greeting.txt" "From Omarchy to NixOS!";
  dontUnpack = true;
  installPhase = ''
    mkdir -p $out/bin
    echo "#!${pkgs.bash}/bin/bash" > $out/bin/omarchy-greet
    echo "cat $src" >> $out/bin/omarchy-greet
    chmod +x $out/bin/omarchy-greet
  '';
}
```
```bash
nix-build simple.nix
./result/bin/omarchy-greet
```

### Go deeper
- [Nix Pills — Our First Derivation](https://nixos.org/guides/nix-pills/06-our-first-derivation)
- [Nix manual — derivations](https://nixos.org/manual/nix/stable/language/derivations.html)

---

## Stage 5: Nixpkgs — Finding and Changing Packages

### The idea

Nixpkgs isn't just a list of packages — it's a big functional library, where every package can be inspected, tweaked, or swapped out without forking anything.

### `callPackage`: how dependencies get connected automatically

Package files declare what they need as function arguments — they don't import anything themselves:

```nix
# package.nix
{ lib, stdenv, fetchFromGitHub, openssl, zlib }:
stdenv.mkDerivation { pname = "sample"; version = "1.0.0"; buildInputs = [ openssl zlib ]; }
```

`callPackage` looks at the argument names (`stdenv`, `openssl`, `zlib`) and automatically wires up the matching packages from Nixpkgs:

```nix
myPackage = pkgs.callPackage ./package.nix { };

# or override one specific input:
myPackageCustom = pkgs.callPackage ./package.nix { openssl = pkgs.openssl_1_1; };
```

### Two different ways to tweak a package

**`.override`** — change the *inputs* a package was built with (only works for things the package's function actually exposes as arguments):
```nix
customGit = pkgs.git.override { withLibsecret = true; guiSupport = false; };
```

**`.overrideAttrs`** — change the derivation directly (patches, source, build steps):
```nix
patchedHello = pkgs.hello.overrideAttrs (old: {
  patches = (old.patches or []) ++ [ ./fix-greeting.patch ];
});
```

### Overlays — patch a package everywhere it's used

An overlay is a function that takes the *current* package set (`prev`) and the *final* fully-resolved set (`final`), and returns whatever you want to add or change:

```nix
myOverlay = final: prev: {
  my-script = final.callPackage ./pkgs/my-script.nix { };
  rofi-wayland = prev.rofi-wayland.override {
    plugins = [ final.rofi-emoji ];
  };
};
```

Every other package that depends on `rofi-wayland` now sees your patched version, automatically.

### Finding things

- Packages: [search.nixos.org/packages](https://search.nixos.org/packages)
- Nixpkgs library functions: [noogle.dev](https://noogle.dev)
- "Which package has this binary?" —
  ```bash
  nix run nixpkgs#nix-index --
  nix-locate bin/hyprctl
  ```

### Try it

```nix
h = pkgs.hello.overrideAttrs (old: { pname = "omarchy-hello"; })
:b h
```
Then check the resulting path in `/nix/store`.

### Go deeper
- [Nix Pills — callPackage design pattern](https://nixos.org/guides/nix-pills/13-callpackage-design-pattern)
- [Nix Pills — override design pattern](https://nixos.org/guides/nix-pills/14-override-design-pattern)

---

## Stage 6: NixOS — Configuring the Whole System

### The idea

On Arch, system config is spread across dozens of files in `/etc`. On NixOS, you never touch `/etc` by hand — you declare what you want in **modules**, and NixOS figures out how to make it true.

### What a module looks like

A module can *declare* new options, *set* values for options, or both:

```nix
{ config, lib, pkgs, ... }:

let cfg = config.services.mybackup; in
{
  options.services.mybackup = {
    enable = lib.mkEnableOption "automated backup service";
    interval = lib.mkOption {
      type = lib.types.str;
      default = "daily";
      description = "How often to run.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.rsync ];
    systemd.timers.mybackup.timerConfig.OnCalendar = cfg.interval;
  };
}
```

A few functions you'll see constantly:
- `lib.mkIf cond { ... }` — only apply this if `cond` is true
- `lib.mkDefault value` — a low-priority default, easy for other modules to override
- `lib.mkForce value` — override everything else, no matter what

### What actually happens when you run `nixos-rebuild switch`

1. **Evaluate** — all your modules get merged and type-checked
2. **Build** — a complete new system gets built as a store path
3. **New generation** — the system profile now points at that new path
4. **Activate** — `/etc` gets updated, systemd reloads, changed services restart
5. **Bootloader** — a new boot entry is added

If evaluation or the build fails, **your running system is untouched** — you're still on the old, working generation. If something does go wrong after switching, just reboot and pick the previous generation from the boot menu.

### Try it

```bash
cat /run/current-system/activate | head -n 50
```
This is the actual script that ran the last time you rebuilt. Skim it — it's not magic, it's just a shell script.

### Go deeper
- [nix.dev — NixOS module system tutorial](https://nix.dev/tutorials/module-system/)
- [Search NixOS options](https://search.nixos.org/options)

---

## Stage 7: Flakes

### The idea

Before flakes, Nix used **channels** — mutable URLs pointing at a moving branch of Nixpkgs. Rebuild the same config on Monday and Friday, and you could get different package versions, because the channel moved underneath you. Flakes fix this by locking every input to an exact commit.

### Anatomy of `flake.nix`

```nix
{
  description = "System Configuration Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";   # important — see below
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations.loki = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/loki/configuration.nix
        home-manager.nixosModules.home-manager
        { home-manager.users.yada = import ./home; }
      ];
    };
  };
}
```

### Why `inputs.nixpkgs.follows` matters

Without it, `home-manager` would pull down its **own separate copy** of Nixpkgs. That means double the evaluation time, double the disk space for duplicate libraries, and possible version mismatches between your system packages and your user packages. `follows` tells it "use the same nixpkgs I'm already using."

### `flake.lock`

Generated automatically, and records the exact commit of every input:

```json
{
  "nodes": {
    "nixpkgs": {
      "locked": { "rev": "c374d94...", "type": "github" }
    }
  }
}
```

Run `nix flake update` to intentionally move to newer versions.

### Converting an old config to a flake

1. `git init`
2. Create `flake.nix` with a pinned `nixpkgs` input
3. Move your existing `configuration.nix` and `hardware-configuration.nix` in
4. `git add .` — **flakes ignore anything not tracked by git**, this trips people up constantly
5. `sudo nixos-rebuild switch --flake .#<hostname>`

### Try it

```bash
nix flake init
```
Add a `devShells` output with `cowsay` and `fortune`, then run `nix develop` and try `fortune | cowsay`.

### Go deeper
- [Zero to Nix — what is a flake?](https://zero-to-nix.com/concepts/flakes)
- [NixOS Wiki — Flakes](https://wiki.nixos.org/wiki/Flakes)

---

## Stage 8: Home Manager — Your Dotfiles

### The idea

Home Manager brings the same "declare it, don't mutate it" approach to your user-level dotfiles that NixOS brings to the whole system. Instead of `stow`-ing files that then get edited in place, your dotfiles are generated from Nix code, and every change creates a new, rollback-able generation.

### Two ways to run it

| Mode | Command | Trade-off |
| :--- | :--- | :--- |
| As a NixOS module | `sudo nixos-rebuild switch` | One command updates system + dotfiles together, but needs `sudo` |
| Standalone | `home-manager switch --flake .#yada` | No `sudo` needed, but it's a separate command from system rebuilds |

### Three ways to migrate a dotfile — start with #1, work up as needed

**1. Just symlink the file you already have** (fastest way to get moving):
```nix
xdg.configFile."hypr/hyprland.conf".source = ./hyprland.conf;
```

**2. Write it inline, with Nix values plugged in** (useful once you want your theme colors shared across apps):
```nix
xdg.configFile."kitty/kitty.conf".text = ''
  font_family JetBrainsMono Nerd Font
  foreground  ${theme.colors.foreground}
'';
```

**3. Use a proper typed module, if one exists for the program** (most robust, catches mistakes at build time):
```nix
programs.kitty = {
  enable = true;
  settings.font_size = 11;
};
programs.fish = {
  enable = true;
  shellAliases.rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config#loki";
};
```

### Try it

```bash
ls -l ~/.config/kitty/kitty.conf
```
It'll point into `/nix/store/...`. Try editing it directly — you'll find it's read-only. To actually change it, edit your Home Manager config and rebuild.

### Go deeper
- [Home Manager manual](https://nix-community.github.io/home-manager/)
- [Home Manager option search](https://home-manager-options.extranix.com/)

---

## Stage 9: Extras — Custom Scripts, Secrets, and One Thing to Avoid

### Packaging your own scripts

Instead of dropping a script in `~/.local/bin` and hoping the tools it calls are installed, use `writeShellApplication`. It runs ShellCheck on your script, and guarantees every tool it needs is actually present:

```nix
pkgs.writeShellApplication {
  name = "omarchy-screenshot";
  runtimeInputs = [ pkgs.grim pkgs.slurp pkgs.wl-clipboard ];
  text = ''
    GEOM=$(slurp)
    grim -g "$GEOM" - | wl-copy
  '';
}
```

### Secrets — don't put passwords in your Nix files

> **`/nix/store` is world-readable.** Anyone on the machine can read anything in there. Never write `password = "hunter2";` in a `.nix` file.

The standard fix is **sops-nix** or **agenix**: secrets are encrypted with your machine's SSH key, the encrypted file is safe to commit to git, and it only gets decrypted (into RAM, not disk) during activation.

```nix
sops.defaultSopsFile = ./secrets/secrets.yaml;
sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
sops.secrets.wifi_password = { };
networking.wireless.environmentFile = config.sops.secrets.wifi_password.path;
```

### The one thing to avoid: IFD

Normally, Nix first figures out *what* to build (evaluation), then builds it (build phase). **IFD** (Import From Derivation) happens when your code builds something and then reads the result back in *during* evaluation — which pauses everything until that build finishes. It breaks parallelism and CI caching. Don't generate Nix code by building things mid-evaluation; keep code generation outside the evaluation step entirely.

### Try it

Package a small script with two `runtimeInputs` (like `curl` and `jq`), add it to a `devShells` output, and test it.

### Go deeper
- [sops-nix](https://github.com/Mic92/sops-nix)
- [agenix](https://github.com/ryantm/agenix)

---

## Common Mistakes and How to Read the Errors

### "infinite recursion encountered"

Happens when something's definition depends on itself:
```nix
rec { a = b + 1; b = a + 1; }
```
Or, more subtly, in a module where an option's value is computed from itself. **Fix**: rerun with `--show-trace`, and look at the *last* file/line in the trace — that's the actual cycle.

### The `with` foot-gun

```nix
let lib = "my-string"; in
with pkgs;
[ lib ]
```
Is `lib` here your local variable, or `pkgs.lib`? **Local variables always win over `with`** — but it's easy to misread, and if a new attribute gets added to `pkgs` that happens to match one of your local names, your code can silently start resolving to the wrong thing.

**Fix**: avoid `with pkgs;` — write `pkgs.git` explicitly, or use `inherit (pkgs) git neovim;`.

### "No such file or directory" for a file you just created

```
error: getting status of '/nix/store/...-source/home/modules/waybar.nix': No such file or directory
```
With flakes, Nix evaluates a **copy of your git worktree** — and only tracks files git already knows about. A brand-new file you haven't `git add`-ed yet is invisible to it.

**Fix**:
```bash
git add -N .   # tracks the path without committing
```

### `nix-shell` vs `nix shell` vs `nix develop`

| Command | Use it for | Source |
| :--- | :--- | :--- |
| `nix-shell -p pkg` | Quick, old-style ad-hoc shell | Channels |
| `nix shell nixpkgs#pkg` | Quick, modern ad-hoc shell | Flake URL |
| `nix develop` | Full dev environment for a project (compilers, headers, etc.) | Flake `devShells` |

### Reading a Nix error

Nix errors read top to bottom, outermost to innermost:
```
error:
       … while evaluating 'activationScript'
       … while evaluating the module ./modules/waybar.nix:
       error: undefined variable 'foobar' at .../waybar.nix:14:7
```
**Always read the very last line first** — that's the real problem. Everything above it is just "how we got there." If it's still unclear, add `--show-trace` for the full chain.

---

## Where to Go for More

**Official docs**
- [nix.dev](https://nix.dev) — modern tutorials
- [NixOS manual](https://nixos.org/manual/nixos/stable/)
- [Nix manual](https://nixos.org/manual/nix/stable/)
- [Nix Pills](https://nixos.org/guides/nix-pills/) — the classic deep-dive series
- [Zero to Nix](https://zero-to-nix.com) — fast, modern, flakes-first
- [Home Manager manual](https://nix-community.github.io/home-manager/)

**Search tools**
- [search.nixos.org/packages](https://search.nixos.org/packages)
- [search.nixos.org/options](https://search.nixos.org/options)
- [noogle.dev](https://noogle.dev) — search Nixpkgs library functions
- [home-manager-options.extranix.com](https://home-manager-options.extranix.com/)

**Community**
- [discourse.nixos.org](https://discourse.nixos.org)
- [wiki.nixos.org](https://wiki.nixos.org)

---

## Closing

You already understand Linux at a deep level — Wayland compositors, systemd, dynamic linking, all of it. Nix isn't replacing that knowledge, it's adding a very rigorous, very predictable layer on top of it. Once the language and the store click, the rest stops feeling arbitrary.

Start with `nix repl`, work through Stage 1 for real, and build up from there.
