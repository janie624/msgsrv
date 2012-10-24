module AjaxHelpers

  def wait_for_ajax(timeout = 2) #timeout in seconds
    page.wait_until(timeout) do
      page.evaluate_script 'jQuery.isReady&&jQuery.active==0'
    end
  end

end

World(AjaxHelpers)
