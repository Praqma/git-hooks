# -*- coding: utf-8; -*-
#

require "test/unit" # Ruby's unit test framework

class TestPreReceiveHook < Test::Unit::TestCase
require_relative "../../pre-receive.rb"

def test_regexp
  
  re = $regex # Use the regex from pre-receive.rb for testing.
  
  # Few normal ways to make references:
  assert_true(parse_message("Ticket#0456 my msg",re))
  assert_true(parse_message("Ticket#456 my msg",re))
  assert_true(parse_message("Ticket#46 my msg",re))
  assert_true(parse_message("Ticket#4 my msg",re))
  # hash tag is used for comments in commit messages as defaults - so no allowed to start
  assert_false(parse_message("#0456 my msg",re))
  assert_false(parse_message("#456,ticket#45 my msg",re))
  assert_false(parse_message("#46,ticket#890 my msg",re))
  assert_false(parse_message("#4 my msg",re))

  # none reference
  assert_false(parse_message("#none my msg",re))
  assert_true(parse_message("Ticket#none my msg",re))
  # twice makes no sense or combined with other
  assert_false(parse_message("Ticket#none,#none my msg",re))
  assert_false(parse_message("Ticket#none,Ticket#none my msg",re))
  assert_false(parse_message("#45,#none my msg",re))
  assert_false(parse_message("Ticket#none,#676 my msg",re))
 
  # case insensitive 
  assert_true(parse_message("ticket#0456 my msg",re))
  
  # using colon is okay:
  assert_true(parse_message("Ticket#456: my msg",re))
  # if using colon omittnig whitespace is okay, else not
  assert_true(parse_message("Ticket#456:my msg",re))
  assert_false(parse_message("ticket#456my msg",re))

  # hash tag is a must
  assert_false(parse_message("456 my msg",re))
  assert_false(parse_message("Ticket456 my msg",re))
  assert_false(parse_message("456: my msg",re))
  assert_false(parse_message("Ticket456: my msg",re))

  # Ticket must be mentioned first, thus the following also common messages are not allowed
  assert_false(parse_message("Closing #456", re))
  assert_false(parse_message("Added new string parameter for user name, ticket #456", re))
  assert_false(parse_message("Fix for #45 by adding exception handling to parse method", re))
  
  # more than one ticket is okay, seperate by comma, just not ending with one!
  assert_true(parse_message("Ticket#456,ticket#45 my msg",re))
  assert_true(parse_message("Ticket#456,ticket#34,#9876 my msg",re))
  assert_true(parse_message("ticket#456,#45 my msg",re))
  assert_true(parse_message("Ticket#456,#34,#9876 my msg",re))
  assert_false(parse_message("ticket#456,,#6 my msg",re))
  assert_false(parse_message("ticket#456,#34,#9876, my msg",re))

  # DO NOT allow spaces between refs
  assert_false(parse_message("#456, #45 my msg",re))
  assert_false(parse_message("#456, #34, #9876 my msg",re))
  assert_false(parse_message("#456,#34, #9876 my msg",re))
  assert_false(parse_message("#456, ,#6 my msg",re))
  assert_false(parse_message("#456, , #6 my msg",re))
  assert_false(parse_message("Ticket#456, ticket#34, ticket#9876, my msg",re))
end

end
