# dot-bash-bashrc

## Initialization process order for each installation method

### Login Shell (shopt -q login_shell && echo OK)

#### For system-installed login shells

``` text
bash
  |
  +- /etc/profile -> dot-bash-bashrc/bash.profile
  |    |
  |    +- /etc/bash.bashrc -> dot-bash-bashrc/bash.bashrc
  |
  +- ~/.bash_profile
       |
       +- ~/.bashrc
```

#### For user-installed login shell

``` text
bash
  |
  +- /etc/profile
  |
  +- ~/.bash_profile
       |
       +- dot-bash-bashrc/bash.profile
       |    |
       |    +- dot-bash-bashrc/bash.bashrc
       |
       +- ~/.bashrc
```

### Interactive Shell (shopt -q login_shell || echo OK)

#### For system-installed interactive shells

``` text
bash
  |
  +- /etc/bash.bashrc -> dot-bash-bashrc/bash.bashrc
  |
  +- ~/.bashrc
```

#### For user-installed interactive shells

``` text
bash (shopt -q login_shell || echo OK)
  |
  +- /etc/bash.bashrc
  |
  +- ~/.bashrc
       |
       +- dot-bash-bashrc/bash.bashrc
```
