using Gtk
using OCReract
using Images

window = GtkWindow("Matrix Wizard Prototype", 300, 250)

container = GtkGrid()

push!(window, container)

path_label = GtkLabel("Path:")

choose_file_button = GtkButton("Choose File")

choose_file_input = GtkEntry()

process_image_button = GtkButton("Process Image")

selected_image = GtkImage("")

matrix_label = GtkLabel("")

container[1,1] = path_label
container[2,1] = choose_file_input
container[3,1] = choose_file_button
container[2,2] = process_image_button
container[2,3] = selected_image
container[2,4] = matrix_label


set_gtk_property!(choose_file_input, :placeholder_text, "File Not Chosen")




set_gtk_property!(container, :column_spacing, 3) 
showall(window)

function choose_file(w)
    file_dialog = open_dialog("Pick an image file", GtkNullContainer(), ("*.png", "*.jpg", GtkFileFilter("*.png, *.jpg", name="All supported formats")))
    set_gtk_property!(choose_file_input,:text, file_dialog)
    img_path = get_gtk_property(choose_file_input, :text, String)
    set_gtk_property!(selected_image, :file, img_path)

end

function process_image(w)
    img_path = get_gtk_property(choose_file_input, :text, String)
    img = load(img_path)
    res = run_tesseract(img, psm=6)
    println(res)
    set_gtk_property!(matrix_label, :label, res)
end
signal_connect(choose_file, choose_file_button, "clicked")
signal_connect(process_image, process_image_button, "clicked")

if !isinteractive()
    @async Gtk.gtk_main()
    Gtk.waitforsignal(window,:destroy)
end
