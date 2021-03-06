# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  #def page_title
  #  "rezervācijas: #{controller.controller_name}/#{controller.action_name}"
  #end

  # Var arī kaut kā šādi, ja gribas cilvēkiem saprotamu page title.
  # Es šos parasti lieku lokalizācijas failā un prasu pēc page_title_<controller_name> 
  # atslēgas (ok, pēc page_id no bones, bet tas gandriiz tas pats). Vai otrs variants 
  # ir viewos/kontrolieros likt <% @page_title = "Something" %> un layoutā, <%= @page_title %>
  #
  # def page_title
  #   [page_titles(controller.controller_name.to_sym), 'Rezervācijas'].join(' - ')
  # end
  # 
  # def page_titles
  #   { 
  #     :users => "Lietotāji",
  #     :batches => "Partijas"
  #   }
  # end
  
  def site_path
    path = []
    if @page_pid
      unless @page_pid[:category] == nil
        path << link_to_unless_current(category_name(@page_pid[:category]), category_path(@page_pid[:category]))
      end
      unless @page_pid[:product] == nil
        path << link_to_unless_current(product_name(@page_pid[:product]), product_path(@page_pid[:product]))
      end
      
      unless @page_pid[:order] == nil
        path << link_to_unless_current(@page_pid[:order].created_at.to_s(:short_date_time), product_order_path(@page_pid[:product], @page_pid[:order]))
      end
      
      unless @page_pid[:batches] == nil
        path << link_to_unless_current("partijas", product_batches_path(@page_pid[:product]))
      end
      unless @page_pid[:batch] == nil
        path << link_to_unless_current(@page_pid[:batch].arrive_on.to_s(:short_date), batch_path)
      end
      
      unless @page_pid[:users] == nil
        path << link_to_unless_current("lietotāji", users_path)
      end
      unless @page_pid[:user] == nil
        path << link_to_unless_current(user_login(@page_pid[:user]), user_orders_path(@page_pid[:user]))
      end
    end
    path
  end
  
  # see /app/views/categories/show.html.erb
  # Block is nested inside <tr class="even | odd"> .. </tr>
  def tr(options = {}, &block)
    with_content_of block do |content|
      tr_tag(content, options)
    end
  end
  
  # tr tag with even or odd class
  def tr_tag(content, options = {})
    content_tag(:tr, content, {:class => cycle("even", "odd")}.merge(options))
  end
  
  # Captures content_block content (in views), yields it (if block given) and concats result.
  # See BonesHelper#tr
  def with_content_of(content_block, &block)
    content = capture(&content_block)
    concat(block_given? ? yield(content) : content, content_block.binding)
  end
  
  # Labaak class, nevis dom id, jo ja ir id, tad vari htmlaa tikai 1nu reizi likt to spanu
  #
  # šo var novienkāršot lietojot with_content_of:
  #   with_content_of block do |content|
  #     content_tag :span, content, :class => :admin_area
  #   end if admin?
  #
  # railscasts 040
  def admin_area(&block)
    if admin?
      concat content_tag(:span, capture(&block), :class => 'admin_area'), block.binding
    end
  end
    
end
