git-hooks
=========

= Introduction =

This git hook validates the commit messages of a push. This can be on a commit or multiple, spanning several branches.
It rejects everything not referencing a ticket number. That is "#123" for example for ticket number 123.
It's is possible to commit without a ticket, if you use "#none" as reference. Pushing with a "#none" referemce will issue a warning from the git hook, but the push is accepted.
There is no check for if the ticket reference is actually a valid reference.

= Installation =

This hook is a pure server side hook. It cannot be run as a client side hook.
This hook uses Bash. Make sure it is installed.

== Local installation ==

In a local --bare git repository, this hook must be placed in the hooks directory in the git directory.
If an update hook exists, the content of this hook must be pasted into the existing.
Alternatively, the pre-recieve hook can be used.

== Gitlab installation ==
http://gitlab.org/

Locate the path to the given repository, copy the pre-recieve hook into the hooks directory.
Run "chmod a+x pre-recieve" to make it executable.
If this hook should be activated on more than a few repositories, consider placing it in a central place and
link to it.

== SCM Manager installation ==
http://www.scm-manager.org/screenshots/

TODO - It should be like local installation, but it is not tested yet.



= Hook documentation =

Based on a list of SHA's retrieved from "git rev-list", each commit in the push is verified.
The verification is done by extracting the commit message with "git cat-file" and "sed".
A regular expression checks for the special wording of the message.
If the wording is correct, the commit is accepted. Otherwise the next commit must be verified.

== Update hook solution ==

Because an update hook is used, each branch being pushed to are dealt with seperately.
This means, that a bundle of commits for one branch can be verified and a bundle of commits for the next can be rejected in the same push.

== Pre-recieve hook solution ==

Given that GitLab uses the update hook for all repositories, a pre-recieve hook is created providing the same functionality.
Instead of being executed for each branch pushed, the pre-recieve hook is executed once per push.
This means, that valid commits for a branch can be rejected, because other branches have incorrect messages.

= Workflow =

== Simple workflow, one commit rejected ==

1. "git commit --amend"
1. Edit the message
1. push again
 
== Multiple commits rejected ==

1. "git log"
1. Find the last correct commit and copy the SHA
1. "git rebase -i <SHA>"
1. Mark the commits with the incorrect messages with 'r', save and exit
1. Reword the incorrect messages
1. push again
