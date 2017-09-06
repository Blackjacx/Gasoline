# Let's check if there are any changes in the project folder
has_app_changes = !git.modified_files.grep(/Beiwagen/).empty?
# Then, we should check if tests are updated
has_test_changes = !git.modified_files.grep(/BeiwagenTests/).empty?

# Make it more obvious that a PR is a work in progress and shouldn't be merged yet
warn("PR is classed as Work in Progress") if github.pr_title.include? "[WIP]"

# Warn when there is a big PR
warn "Big PR, consider splitting into smaller" if git.lines_of_code > 500

# Finally, let's combine them and put extra condition 
# for changed number of lines of code
if has_app_changes && !has_test_changes && git.lines_of_code > 100
  fail("Tests were not updated", sticky: false)
end

# Mainly to encourage writing up some reasoning about the PR, rather than
# just leaving a title
if github.pr_body.length < 5
  fail "Please provide a summary in the Pull Request description"
end

# Info.plist file shouldn't change often. Leave warning if it changes.
plist_updated = !git.modified_files.grep("Beiwagen/Info.plist").empty?
if plist_updated
  warn "Plist changed, don't forget to localize your plist values"
end

# Leave warning, if Podfile changes
podfile_updated = !git.modified_files.grep("Podfile").empty?
if podfile_updated
  warn "The `Podfile` was updated"
end

# Have you updated CHANGELOG.md?
changelog.check