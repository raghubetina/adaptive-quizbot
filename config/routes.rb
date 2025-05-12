Rails.application.routes.draw do

  # Routes for the Topic resource:

  # CREATE
  post("/insert_topic", { :controller => "topics", :action => "create" })
          
  # READ
  get("/topics", { :controller => "topics", :action => "index" })
  
  get("/topics/:path_id", { :controller => "topics", :action => "show" })
  
  # UPDATE
  
  post("/modify_topic/:path_id", { :controller => "topics", :action => "update" })
  
  # DELETE
  get("/delete_topic/:path_id", { :controller => "topics", :action => "destroy" })

  #------------------------------

  # This is a blank app! Pick your first screen, build out the RCAV, and go from there. E.g.:

  # get "/your_first_screen" => "pages#first"
  
end
