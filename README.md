# Usage
## Install chezmoi binary
```sh
curl -sfL https://git.io/chezmoi | sh
```
([other options](https://github.com/twpayne/chezmoi/blob/master/docs/INSTALL.md))

## Initialize dotfiles repository
```sh
~/bin/chezmoi init https://github.com/alker0/dotfiles.git
```
And input according to some questions for chezmoi configurations.

## Apply chezmoi settings
```sh
~/bin/chezmoi apply --remove
```
(It is possible to dry-run with `--dry-run --verbose`)

## More details of chezmoi
see [chezmoi repository](https://github.com/twpayne/chezmoi)

