require 'rails'
# require 'will_paginate'
require 'non-stupid-digest-assets'

require "caseadilla/version"
require 'caseadilla/engine'

if Caseadilla::Engine.flavor = :steak
	require 'devise'
	require 'authoreyes'
end
