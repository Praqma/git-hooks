#!/usr/bin/env ruby

# Script receives this line on stdin when called for each commit
# < old-value > SP < new-value > SP < ref-name > LF
# http://stackoverflow.com/questions/2569960/git-pre-receive-hook


$regex = /(^Merge\sbranch{1})(.*)|((^([Tt]icket#\d+){1}(,[Tt]icket#\d+|,#\d+)*)|(^([Tt]icket#none)))(\s|:\s?){1}(.*)/

# Simple function, just for ease of testing
def parse_message(msg,re)
  if not re.match(msg)
    return false
  else 
    return true
  end
end

# enforced custom commit message format
def check_message_format
  missed_revs = `git rev-list #{$rev_old}..#{$rev_new}`.split("\n")
  missed_revs.each do |rev|
    message = `git cat-file commit #{rev} | sed '1,/^$/d'`
    if not parse_message(message,$regex)
      STDERR.puts "[git-hook] Your commit #{ rev } was rejected."
      STDERR.puts "[git-hook] Did you forget a ticket reference? You must reword your commit. See our howto: LINK"      
      exit 1
    end  
  end
end

# The "main" method ... when executing this file:
#Only run this if the file itself is being executed
if __FILE__ == $0
  $rev_old, $rev_new, $ref = STDIN.read.split(" ")
  check_message_format
end
