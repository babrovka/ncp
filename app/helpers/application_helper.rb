# coding: utf-8

module ApplicationHelper
  
  def title
     base_title = "Научный Центр Прикладной Электродинамики"
     if @title.nil?
       base_title
     else
       "#{base_title} | #{@title}"
     end
   end
   
   def nav_link(link_text, link_path)
     class_name = current_page?(link_path) ? 'active' : ''
     link_to link_text, link_path, :class => class_name
   end
   
   def controller?(*controller)
      controller.include?(params[:controller])
    end

    def action?(*action)
      action.include?(params[:action])
    end
end
