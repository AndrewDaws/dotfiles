# Extend suggestions beyond just previous command history
export ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd history completion)

# Make suggestion lookup async
export ZSH_AUTOSUGGEST_USE_ASYNC="true"
