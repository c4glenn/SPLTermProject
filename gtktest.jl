using Gtk
win = GtkWindow("My First Gtk.jl Program", 400, 200) #create window 
box = GtkBox(:h, 0) #create box container for widgets
b = GtkButton("Click Me") #button widget
label = GtkLabel("Uhhhh") #label widget

push!(box,label) #add label to box container

push!(box,b)  #add button to box container

push!(win, box) #add box to window
function on_button_clicked(w) #if button is clicked set title "new title"
    set_gtk_property!(win, :title, "New title")
end

signal_connect(on_button_clicked, b, "clicked") # attach the b button to call the on_button_clicked function when b is clicked

showall(win) #display window

if !isinteractive() # If the window hasn't been closed keep it open
    @async Gtk.gtk_main()
    Gtk.waitforsignal(win,:destroy)
end