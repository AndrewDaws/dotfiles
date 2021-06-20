# Aliases
alias git="hub"

hub() {
  # Declare local variables
  local command_list

  # Initialize local variables
  command_list=(
    add
    rm
    reset
    commit
    checkout
    mv
    init
  )

  # Execute original git command and check return code
  if command -- hub ${@}; then
    # Verify not attached to a pipe or redirection
    if [[ -t 0 && -t 1 && ! -p /dev/stdout ]]; then
      # Verify at least one argument provided
      if [[ -n "${1}" ]]; then
        # Prevent nested execution
        if [[ "${1}" != "status" ]]; then
          # Search command list for a match
          for command_index in "${command_list[@]}"; do
            # Compare first hub argument against list
            if [[ "${1}" == "${command_index}" ]]; then
              # Execute hub status command when match found
              command -- hub status
              break
            fi
          done
        fi
      fi
    fi
  fi
}
