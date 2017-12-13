# ruby-confluence-scripts

Some miscellaneous ruby scripts to be used with Atlassian Confluence software.

These scripts use to Confluence REST API (/rest/api): see https://docs.atlassian.com/atlassian-confluence/REST/latest-server/

## deleteConfluenceWikiPageAndChildren.rb

This ruby script delete an Atlassian Confluence wiki page and all its children (recursively).

The interactive script asks for:
* the Confluence URL (e.g. https://www.foobar.com/confluence)
* the login
* the password
* the page id of the page and its children to be deleted
