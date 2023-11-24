#! /usr/bin/env bash

# complete -W "help version ssh login apps proxy db join play ls clusters" tsh

_print_debug()
{
    printf '\n>>>'
    echo "\n>>>"
    for i in ${!COMP_WORDS[@]}; do
        printf '${COMP_WORDS[%s]}=%s\n' "$i" "${COMP_WORDS[i]}"
    done
    echo "\$COMP_CWORD $COMP_CWORD"
    echo "line  $COMP_LINE"
    printf '<<<\n'
}

_apps_completions()
{
    arg=${COMP_WORDS[2]}
    case $arg in
        "login"|"logout")
            COMPREPLY=($(compgen -W "$(tsh apps ls -f json | jq '.[].metadata.name')" -- "${COMP_WORDS[3]}"))
            ;;

        *)
            COMPREPLY=($(compgen -W "ls login logout config" "$arg"))
            ;;
    esac
}

_proxy_completions()
{
    arg=${COMP_WORDS[2]}
    case $arg in
        "app")
            COMPREPLY=($(compgen -W "$(tsh apps ls -f json | jq '.[].metadata.name')" -- "${COMP_WORDS[3]}"))
            ;;
        *)
            COMPREPLY=($(compgen -W "ssh db app aws azure gcloud kube" "$arg"))
            ;;
    esac
}

_db_completions()
{
    arg=${COMP_WORDS[2]}
    case $arg in
        "login")
            COMPREPLY=($(compgen -W "$(tsh db ls -f json | jq '.[].metadata.name')" -- "${COMP_WORDS[3]}"))
            ;;
        *)
            COMPREPLY=($(compgen -W "ls login logout env config connect" "$arg"))
            ;;
    esac
}

_completions()
{
    #_print_debug

    comm="${COMP_WORDS[1]}"
    case $comm in
        "apps")
            _apps_completions
            ;;
        "proxy")
            _proxy_completions
            ;;
        "db")
            _db_completions
            ;;
        *)
            COMPREPLY=($(compgen -W "help version ssh aws az gcloud gsutil apps recordings proxy db join play scp ls clusters login logout status env request headless kubectl kube mfa config device" "$comm"))
            ;;
    esac
}

complete -F _completions tsh
