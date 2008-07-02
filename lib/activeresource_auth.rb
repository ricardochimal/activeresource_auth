require 'active_resource'

class ActiveResource::Connection
	attr_writer :basic_auth_user, :basic_auth_password

	def authorization_header
		if (@basic_auth_user || @basic_auth_pass)
			build_auth_header(@basic_auth_user, @basic_auth_password)
		elsif (@site.user || @site.password) # remain backwards compatible
			build_auth_header(@site.user, @site.password)
		else
			{}
		end
	end

	def build_auth_header(user, password)
		{ 'Authorization' => 'Basic ' + ["#{user}:#{password}"].pack('m').delete("\r\n") }
	end
end 

class ActiveResource::Base
	def self.auth_as(user, password)
		connection.basic_auth_user = user
		connection.basic_auth_password = password
	end

	def self.clear_auth
		connection.basic_auth_user = nil
		connection.basic_password_user = nil
	end
end
