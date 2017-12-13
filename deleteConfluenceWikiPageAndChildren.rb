# Ruby script to delete an Atlassian Confluence page and all its children
# author: Florian Gerus

require 'net/http'
require 'net/https'
require 'rubygems'
require 'json'

def delete_page(http, login, password, page_id, page_title)

	delete_request = Net::HTTP::Delete.new("/rest/api/content/#{page_id}")
	delete_request.basic_auth "#{login}", "#{password}"

	delete_response = http.request(delete_request)
	puts "Page #{page_title} with id #{page_id} deleted"

end

def delete_children_and_page(http, login, password, page_id, page_title)

	get_page_info_request = Net::HTTP::Get.new("/rest/api/content/#{page_id}/child?expand=page.body.VIEW&limit=1000")
	get_page_info_request.basic_auth "#{login}", "#{password}"

	get_page_info_response = http.request(get_page_info_request)

	get_page_info_json = JSON.parse(get_page_info_response.body)

	children = get_page_info_json['page']['results']

	if children != nil
		for child in children
        		child_page_id = "#{child['id']}"
	        	child_page_title = "#{child['title']}"
		
			delete_children_and_page http, login, password, child_page_id, child_page_title

		end
	end

	delete_page http, login, password, page_id, page_title
end

puts "Confluence URL (e.g. https://www.foobar.com/confluence): "
confluence_url = gets.chomp

puts "Login: "
login = gets.chomp

puts "Password (hidden): "
system 'stty -echo'
password = gets.chomp
system 'stty echo'

confluence_uri = URI.parse(confluence_url)
http = Net::HTTP.new(confluence_uri.host, confluence_uri.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

puts "The parent page id to delete"
parent_page_id = gets.chomp
parent_title = 'parent'

delete_children_and_page http, login, password, parent_page_id, parent_title


