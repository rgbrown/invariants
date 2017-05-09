function testzoomcallback(obj, event_obj)
display(get(event_obj.Axes, 'xlim'))
display(get(event_obj.Axes, 'ylim'))
end