class EventSweeper < ActionController::Caching::Sweeper

  observe Event

  def after_update(event)
    expire_connected_actions(event)
  end

  def before_destroy(event)
    expire_connected_actions(event)
  end

  #private

  def expire_connected_actions(event)
    #p expire_action :controller => :main, :action => :event, :id => event.id
  end

end