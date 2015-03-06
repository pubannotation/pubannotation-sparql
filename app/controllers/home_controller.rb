class HomeController < ApplicationController
  def index
		@queries = Query.all
  end
end
