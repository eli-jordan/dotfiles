
fzf-git-branches() {
	recent-branches() {
		git branch -vv --sort=-committerdate
	}

	is_git_repo() { 
		git rev-parse --is-inside-work-tree 2> /dev/null
	}

	if [[ ! "$(is_git_repo)" == "true" ]]; then
		echo "Not a git repository"
		return 1
	fi

	local selected="$(recent-branches | fzf)"
	if [[ ! -z "$selected" ]]; then
		local branch=$(echo "$selected" | awk '{ print $1 }')
		git checkout "$branch"
	fi
}

alias br=fzf-git-branches
