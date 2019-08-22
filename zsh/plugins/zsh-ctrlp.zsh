CTRLP_KEYBIND=${CTRLP_KEYBIND:-'^P'}
CTRLP_FUZZER_COMMAND=${CTRLP_FUZZER_COMMAND:-'zsh-select'}
CTRLP_FINDER_COMMAND=${CTRLP_FINDER_COMMAND:-'find . -not -path '\''*/\.*'\'''}
#CTRLP_EXECUTE_LINE=${CTRLP_EXECUTE_LINE:-true}
CTRLP_SEARCH_FUZZERS=${CTRLP_SEARCH_FUZZERS:-true}

# Search for fuzzers
fuzzers=($CTRLP_FUZZER_COMMAND zsh-select fzf selecta fzy fpp peco percol pick)
for fuzzer in $fuzzers; do
    if (( $+commands[$fuzzer]  )); then
        CTRLP_FUZZER_COMMAND=$fuzzer
        break;
    fi
done

ctrlp() {
    zle reset-prompt
    # TODO FINDER_COMMAND env var is not used here
    print -z - $BUFFER $( find . -not -path '*/\.*' | $CTRLP_FUZZER_COMMAND)
    zle send-break
    # TODO EXECUTE_LINE
}

zle -N ctrlp
bindkey $CTRLP_KEYBIND ctrlp

