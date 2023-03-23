# What are "partial dotfiles"!?

Many nix modules generate config (your dotfiles) on your behalf. 

Some nix modules are so configurable that you can specify pretty much anything you'd ever want via the nix module's options, without needing to manually create, edit, or append the application's usual config file. 

Other nix modules provide basic options to generate a working config and provide an `extraConfig` option to hook in or append your own custom config.

This directory is for those extraConfig blobs. The config files wouldn't be enough on their own because they don't tell the full story.
