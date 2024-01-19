{ config, lib, pkgs, ... }:

/*
This is a nix expression to build Emacs and some Emacs packages I like
from source on any distribution where Nix is installed. This will install
all the dependencies from the nixpkgs repository and build the binary files
without interfering with the host distribution.

To build the project, type the following from the current directory:

$ nix-build emacs.nix

To run the newly compiled executable:

$ ./result/bin/emacs
*/

# The first non-comment line in this file indicates that
# the whole file represents a function.
{ pkgs ? import <nixpkgs> {} }:

let
  # The let expression below defines a myEmacs binding pointing to the
  # current stable version of Emacs. This binding is here to separate
  # the choice of the Emacs binary from the specification of the
  # required packages.
  myEmacs = pkgs.emacs;
  # This generates an emacsWithPackages function. It takes a single
  # argument: a function from a package set to a list of packages
  # (the packages that will be available in Emacs).
  emacsWithPackages = (pkgs.emacsPackagesFor myEmacs).emacsWithPackages;
in
  # The rest of the file specifies the list of packages to install. In the
  # example, two packages (magit and zerodark-theme) are taken from
  # MELPA stable.
  emacsWithPackages (epkgs: (with epkgs.melpaStablePackages; [
    magit          # ; Integrate git <C-x g>
    doom-themes
  ])
  # Two packages (undo-tree and zoom-frm) are taken from MELPA.
  ++ (with epkgs.melpaPackages; [
    frames-only-mode
    lsp-mode # language server
    undo-tree      # ; <C-x u> to show the undo tree
    zoom-frm       # ; increase/decrease font size for all buffers %lt;C-x C-+>
  ])
  # Three packages are taken from GNU ELPA.
  ++ (with epkgs.elpaPackages; [
    company #completion
    vertico #completion
    beacon         # ; highlight my cursor when scrolling

  ])
  # the following are taken from nixpkgs
  ++ (with pkgs; [
    beframe #to use with frames-only-mode; am not 100% of their difference
    doom-modeline
    nav-flash #blink cursor line after big motions
    hl-todo #highlight todos
    popup #was in doom-emacs
    multiple-cursors
    god-mode #bindings modifier
    parinfer-rust-mode #used in lisp mode
    projectile #project management

    sly #common lisp IDE and REPL


    lsp-haskell
  ])
