ActiveAdmin.register Activity do
  config.batch_actions = false
  config.clear_sidebar_sections!

   index do 
     column :title
     default_actions
   end

   form do |f|  
     f.inputs do
       f.input :title
       f.input :text, :as => :ckeditor, :label => false
     end
     f.actions
   end

  show do
    attributes_table do
      row :title
      row :text
    end  
   end
end
