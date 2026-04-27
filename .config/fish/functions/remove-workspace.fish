function remove-workspace
    set -l force_worktree_flag
    set -l skip_docker 0

    argparse f/force no-docker -- $argv; or begin
        echo "remove-workspace: usage: remove-workspace [--force] [--no-docker]" >&2
        return 1
    end

    if set -q _flag_force
        set force_worktree_flag --force
    end

    if set -q _flag_no_docker
        set skip_docker 1
    end

    set -l main_repo (_git_main_repo); or return 1

    set -l current_worktree (command git rev-parse --show-toplevel 2>/dev/null)
    test -n "$current_worktree"; or begin
        echo "remove-workspace: failed to resolve current worktree" >&2
        return 1
    end

    if test "$current_worktree" = "$main_repo"
        echo "remove-workspace: must be run from a linked worktree" >&2
        return 1
    end

    set -l branch_name (command git branch --show-current 2>/dev/null)
    test -n "$branch_name"; or begin
        echo "remove-workspace: detached HEAD is not supported" >&2
        return 1
    end

    if contains -- "$branch_name" main master
        echo "remove-workspace: refusing to delete protected branch '$branch_name'" >&2
        return 1
    end

    set -l worktree_status (command git status --porcelain)
    if test -n "$worktree_status"; and test -z "$force_worktree_flag"
        echo "remove-workspace: worktree has uncommitted changes; rerun with --force" >&2
        return 1
    end

    # Clean up docker compose resources if present
    if test $skip_docker -eq 0
        set -l project_name (path basename "$current_worktree" | string lower | string replace -ra '[^a-z0-9]' '')
        
        # Check if any docker resources exist for this project
        set -l containers (docker ps -aq --filter "label=com.docker.compose.project=$project_name" 2>/dev/null)
        if test (count $containers) -gt 0
            echo "remove-workspace: stopping and removing docker containers for project '$project_name'"
            docker rm -f $containers 2>/dev/null
        end

        set -l volumes (docker volume ls -q --filter "label=com.docker.compose.project=$project_name" 2>/dev/null)
        if test (count $volumes) -gt 0
            echo "remove-workspace: removing docker volumes for project '$project_name'"
            docker volume rm $volumes 2>/dev/null
        end

        set -l networks (docker network ls -q --filter "label=com.docker.compose.project=$project_name" 2>/dev/null)
        if test (count $networks) -gt 0
            echo "remove-workspace: removing docker networks for project '$project_name'"
            docker network rm $networks 2>/dev/null
        end
    end

    cd "$main_repo"; or begin
        echo "remove-workspace: failed to cd into '$main_repo'" >&2
        return 1
    end

    command git -C "$main_repo" worktree remove $force_worktree_flag "$current_worktree"; or begin
        echo "remove-workspace: failed to remove worktree '$current_worktree'" >&2
        return 1
    end

    echo "remove-workspace: removed '$current_worktree' for branch '$branch_name'"
end
