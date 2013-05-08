## dotmation

[imagine-ware at the moment]

Github aware manager for environment files (e.g. dotfiles) inspired by fresh.

* depends on ruby (pro/con)
* ruby dsl config file

## Installation

### Get ruby and dotmation

There are several chicken and egg problems with setting up an evironment
without an environment.  This shell script solves half of them (for debian
systems).

    bash -c `curl https://raw.github.com/jtprince/dotmation/master/script/bootstrap-ruby-env.sh`

This will install:

* rbenv
* ruby-build
* critical deb packages for building:
    * git curl zlib1g-dev build-essential libssl-dev libreadline-dev
* the latest stable ruby
* dotmation

Beware, it will write to (or create) ~/.profile, remove .bash_profile, and
write to ~/.bashrc.  Of course, all of these changes will be clobbered with
your own fresh symlinks (assuming you use these files) once you run dotmation
update.  The bootstrap supports the bash shell only (but you're smart enough
to drop down to bash to run the initial update if you're using a different
shell)

#### Already have working ruby?

    gem install dotmation

### Initial run

The first time you run dotmation, you will need to give it the filename or URI
to your dotmation file.  Alternatively, give it a github username, it will
look for <user>/dotfiles/config/dotmation/config 

    dotmation init jtprince

## Example

### Usage

Assuming your dotmation file resides or is linked where expected
(~/.config/dotmation/config), then usage is trivial:

    dotmation update

### Configuration

A dotmation config file is pure ruby code, so anything you can do in ruby you
can do in your config file.  The code will be read in context of
Dotmation::Reader and dir commands are also in context of the directory you
specify.

```ruby

repo "~/dotrepos"                  # where to put all these files

github "jtprince/dotfiles" do      # stored in ~/dotrepos/jtprince/dotfiles
  dir 'config' do
    dot 'Xresources'               # symlink ~/.Xresources
    dot 'Xresources', '.Xdefaults' # symlink ~/.Xdefaults -> Xresources
    dot 'zsh/zshenv'               # symlink ~/.zshenv

    xdg 'dunstrc'                  # symlink ~/.config/dunstrc
    xdg 'zsh'                      # symlink ~/.config/zsh
    xdg 'i3/config', 'i3/'         # symlink ~/.config/i3/config
  end
end

github "robbyrussel/oh-my-zsh" do
  xdg .                            # symlink ~/.config/oh-my-zsh
end

```

Note that a trailing slash may be important so it is understood that the file
is to go under the given directory.  Otherwise, it will clobber the directory.

## todo

Add bitbucket support.

## Copying

MIT license
