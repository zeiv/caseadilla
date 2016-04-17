require "caseadilla/version"

if defined?(Rails) && Rails::VERSION::MAJOR == 4
	require 'caseadilla/engine'
	require 'will_paginate'
	require 'non-stupid-digest-assets'
	if Caseadilla::Engine.flavor = :steak
		require 'devise'
		require 'declarative_authorization'
	end
else
	puts("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	puts("!!! WARNING !!! Caseadilla requires Rails >= 4.x !!!")
	puts("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
end
