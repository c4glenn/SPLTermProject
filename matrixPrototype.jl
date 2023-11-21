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
    # \n char means next row and add 1 to dimy
    # white space means end of string on that row and add 1 to dimx
    # when string contains a character that is not a number that means negative
    numbers::Array{Int64} = []
    dimx::Int64 = 1
    dimy::Int64 = 0
    firstLineBroken::Bool = false
    number::String = ""
    for char in res
        
        if char == '\n'
            dimy += 1
            firstLineBroken = true
            push!(numbers, parse(Int64,number))
            number = ""
            continue
        end

        if char == ' '
            push!(numbers, parse(Int64, number))
            number = ""
            if !firstLineBroken
                dimx += 1
                continue
            end
        end

        if char != '\n' && char != ' '
            number = number * char
        end
    end
    matrix = Array{Int64}(undef, dimx, dimy)
    counter::Int64 = 1
    for numx in range(1, dimx)
        for numy in range(1, dimy)
            matrix[numx, numy] = numbers[counter]
            counter += 1
        end
    end
    set_gtk_property!(matrix_label, :label, res)
end
# TODO: create a dictionary of all the values using the matrixfunctions module and return the dictionary
# function getMatrixValues(matrix)
#     return Dict("transpose" => , "dimensions" => , "transpose" =>, "RREF" => , "trace" => "determinant" => , "rank" => , "nullality" => , "eigenValues" => , "eigenVectors" => )
# end
signal_connect(choose_file, choose_file_button, "clicked")
signal_connect(process_image, process_image_button, "clicked")

if !isinteractive()
    @async Gtk.gtk_main()
    Gtk.waitforsignal(window,:destroy)
end
