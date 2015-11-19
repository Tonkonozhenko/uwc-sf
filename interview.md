Easy:
=========================================================================

1. What paths (HTTP verb and URL) will be defined by the following snippet in config/routes.rb? How to write the same with less code (4 lines needed)?

  ```ruby
  resources :posts do
    member do
      get 'comments'
    end
    collection do
      post 'bulk_upload'
    end
  end
  ```
  
  **Answer:**
  
  ```
  GET       '/post'               to: "posts#index"
  GET       '/post/:id'           to: "posts#show"
  GET       '/post/new'           to: "posts#new"
  GET       '/post/:id/edit'      to: "posts#edit"
  POST      '/post'               to: "posts#create"
  PUT/PATCH '/post/:id'           to: "posts#update"
  DELETE    '/post/:id'           to: "posts#destroy"
  
  GET       '/post/:id/comments'  to: "posts#comments"
  POST      '/post/bulk_upload'   to: "posts#bulk_upload"
  ```
  
  Shorten code: 
  
  ```ruby
  resources :posts do
    get 'comments', on: :member
    post 'bulk_upload', on: :collection
  end
  ```

=========================================================================

2. What is the difference between form_for and form_tag?

**Answer**

form_for is a more advanced tool that uses an object (usualy model instance) to generate your form and automaticaly takes values from object.

<% form_for(@foo) do |form| %>
  <%= form.text_field(:bar) %>
<% end %>

The form_tag method is much more primitive and just emits a tag <form>.

<% form_tag do %>
  <%= text_field_tag(:bar, 'bar_value') %>
<% end %>

=========================================================================

3) Define a Person model so that any Person can be assigned as the parent of another Person (as demonstrated in the Rails console below)? What columns would you need to define in the migration creating the table for Person?

irb(main):001:0> john = Person.create(name: "John")
irb(main):002:0> jim = Person.create(name: "Jim", parent: john)
irb(main):003:0> bob = Person.create(name: "Bob", parent: john)
irb(main):004:0> john.children.map(&:name)
=> ["Jim", "Bob"]

And for a more advanced challenge: Update the Person model so that you can also get a list of all of a person’s grandchildren, as illustrated below. Would you need to make any changes to the corresponding table in the database?

irb(main):001:0> sally = Person.create(name: "Sally")
irb(main):002:0> sue = Person.create(name: "Sue", parent: sally)
irb(main):003:0> kate = Person.create(name: "Kate", parent: sally)
irb(main):004:0> lisa = Person.create(name: "Lisa", parent: sue)
irb(main):005:0> robin = Person.create(name: "Robin", parent: kate)
irb(main):006:0> donna = Person.create(name: "Donna", parent: kate)
irb(main):007:0> sally.grandchildren.map(&:name)
=> ["Lisa", "Robin", "Donna"]

Answer

table columns: id, parent_id, name
no changes needed for part 2

class Person < ActiveRecord::Base
  # for first part:
  belongs_to :parent, class: Person
  has_many :children, class: Person, foreign_key: :parent_id
  
  # for second part:
  has_many :grandchildren, class: Person, through: :children, source: :children
end


=========================================================================
=========================================================================

Medium:

=========================================================================

1) What is polymorphic association in ActiveRecord?

Answer

With polymorphic associations, a model can belong to more than one other model, on a single association. In database it is saved as a pair of fields: <association_name>_id and <association_name>_type (e.g. imageable_id, imageable_type). <association_name>_id stores the record id and <association_name>_type stores the record class.

Example:

class Picture < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true
end
 
class Employee < ActiveRecord::Base
  has_many :pictures, as: :imageable
end
 
class Product < ActiveRecord::Base
  has_many :pictures, as: :imageable
end


=========================================================================

2) What is CSRF? How does Rails protect against it?

Answer

CSRF stands for Cross-Site Request Forgery. This is a form of an attack where the attacker submits a form on your behalf to a different website, potentially causing damage or revealing sensitive information. Since browsers will automatically include cookies for a domain on a request, if you were recently logged in to the target site, the attacker’s request will appear to come from you as a logged-in user (as your session cookie will be sent with the POST request).

In order to protect against CSRF attacks, you can add protect_from_forgery to your ApplicationController. This will then cause Rails to require a CSRF token to be present before accepting any POST, PUT, or DELETE requests. The CSRF token is included as a hidden field in every form created using Rails’ form builders. It is also included as a header in GET requests so that other, non-form-based mechanisms for sending a POST can use it as well. Attackers are prevented from stealing the CSRF token by browsers’ “same origin” policy.

=========================================================================

3) What is n+1 queries problem?

Answer

Example:

posts = User.find(id).post
commenters = post.map {|post| post.comments.pluck(:author)}.flatten.uniq


The first line will retrieve all of the Post objects from the database, but then each iteration of map will make an additional request for each Post to retrieve the corresponding Comment objects. To fix it just use:

posts = User.find(id).post.includes(:comments)

or better in this case:

posts = User.find(id).post.includes(comments: [:author])

=========================================================================
=========================================================================

Hard

=========================================================================

1) How rails knows which migrations were done and which were not? What is schema.rb file and what it stands for?

There is a special table in database (schema_migrations), were rails stores migration ids (if you are using rails generators timestamps will act as ids) for migrations which were done. That ids are used in filenames where migration code is saved, so rails always can check if migration from certain file was done.

Schema.rb is a file which is generating while migration is done. It stores the current state of the database and that state can be restored somewhere with command `rake db:schema:load` - the most common usage is populating db for tests. This file is not used anywhere else in application itself (ActiveRecord is inspecting database to know it's state).

=========================================================================

2) Please explain the process of authentication? (should be mentioned that password, saved in DB, is encrypted). Where user session is saved by default and what are alternative configurations (DB, redis, etc.)?

Answer

On registration process encrypted user's password is stored in database. When user enters his credentials into login form they are posted to the app and then app compares password to the one from database. If they are equal, app saves user_id to rails session. Session by default is stored in cookies, it is encrypted so it can be read or changed only on server side. Also session can be stored in different places - DB, redis, files, etc. In this case we store only session ID in user's cookie.
