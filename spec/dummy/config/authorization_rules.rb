authorization do

  role :admin do
  end

  role :guest do
    has_permission_on :posts, to: :read
    has_permission_on :sessions, to: [:create, :destroy]
    # has_permission_on :user_sessions, to: [:create, :destroy]
    # has_permission_on :devise_user_sessions, to: [:create, :destroy]
    # has_permission_on :devise_sessions, to: [:create, :destroy]
    has_permission_on :registrations, to: :create
    # has_permission_on :user_registrations, to: :create
  end

  role :user do
    has_permission_on :posts, to: :create
    has_permission_on :posts, to: :manage do
      if_attribute user_id: is { user.id }
    end
    has_permission_on :users, to: :manage do
      if_attribute if: is { user.id }
    end
  end

  role :admin do
    includes :user
    has_permission_on :posts, to: :manage
    has_permission_on :users, to: :manage
    has_permission_on :caseadilla_posts, to: :manage
    has_permission_on :caseadilla_users, to: [:manage, :change_password]
    has_permission_on :caseadilla_roles, to: :manage
    has_permission_on :caseadilla, to: [:access, :blank, :index, :dashboard]
  end
end

privileges do
  privilege :manage, :includes => [:create, :read, :update, :delete]
  privilege :read, :includes => [:index, :show]
  privilege :create, :includes => :new
  privilege :update, :includes => :edit
  privilege :delete, :includes => :destroy
end
