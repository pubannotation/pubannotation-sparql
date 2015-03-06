class Query < ActiveRecord::Base
  attr_accessible :comment, :graph, :priority, :sparql, :title
end
