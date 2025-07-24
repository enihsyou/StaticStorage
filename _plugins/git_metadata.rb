# Attach file modification time from Git history to Jekyll static files.
# https://mrinalcs.github.io/automating-jekyll-metadata-with-git-hooks

Jekyll::Hooks.register :site, :pre_render do |site|
  site.static_files.each do |static_file|
    # Skip files that are not part of project
    next unless static_file.path.start_with?(site.source)

    Jekyll.logger.debug "Git Metadata:", "Processing #{static_file.path}"
    git_dates_log_command = `git log --follow --format=%ad --date=iso-strict -- "#{static_file.path}"`
    git_dates = git_dates_log_command.split("\n")
    # Skip files that have no git history
    next if git_dates.empty?

    # Not to be confused with file.modified_time, which comes from Jekyll,
    # which would be a loss of modification time by Git clone.
    static_file.data["last_modified_at"] = git_dates.first
  end
end