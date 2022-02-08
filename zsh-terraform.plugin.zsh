# -*- mode: sh; sh-indentation: 4; indent-tabs-mode: nil; sh-basic-offset: 4; -*-

# Copyright (c) 2021 Thuan Duong

# According to the Zsh Plugin Standard:
# http://zdharma.org/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html

0=${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}
0=${${(M)0:#/*}:-$PWD/$0}

# Then ${0:h} to get plugin's directory

if [[ ${zsh_loaded_plugins[-1]} != */zsh-terraform && -z ${fpath[(r)${0:h}]} ]] {
    fpath+=( "${0:h}" )
}

# Standard hash for plugins, to not pollute the namespace
typeset -gA Plugins
Plugins[ZSH_TERRAFORM_DIR]="${0:h}"

#compdef terraform
complete -o nospace -C $(asdf which terraform) terraform

# https://github.com/gruntwork-io/terragrunt/issues/689
#compdef terragrunt
#complete -o nospace -C $(asdf which terraform) terragrunt

# https://terraspace.cloud/reference/terraspace-completion/
eval $(terraspace completion_script)

alias tf="terraform"
alias tg="terragrunt"
alias tsp="terraspace"
alias tfw="terraform workspace"

tfv(){
  terraform validate -var-file=vars/$(terraform workspace show).tfvars
}

tfp(){
  terraform plan -var-file=vars/$(terraform workspace show).tfvars
}

tfa(){
  terraform apply -var-file=vars/$(terraform workspace show).tfvars
}

tfc(){
  terraform console -var-file=vars/$(terraform workspace show).tfvars
}

tfd(){
  terraform destroy -var-file=vars/$(terraform workspace show).tfvars
}

# from OMZ::plugins/terraform
function tf_prompt_info() {
  # dont show 'default' workspace in home dir
  [[ "$PWD" == ~ ]] && return
  # check if in terraform dir
  if [[ -d .terraform && -r .terraform/environment  ]]; then
    workspace=$(cat .terraform/environment) || return
    echo "[${workspace}]"
  fi
}

# Use alternate vim marks [[[ and ]]] as the original ones can
# confuse nested substitutions, e.g.: ${${${VAR}}}

# vim:ft=zsh:tw=80:sw=4:sts=4:et:foldmarker=[[[,]]]
