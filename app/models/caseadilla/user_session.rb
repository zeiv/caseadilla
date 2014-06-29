module Caseadilla
  class AdminUserSession < ::Authlogic::Session::Base
    include ActiveModel::Conversion 
    def persisted? 
      false 
    end
  end
end