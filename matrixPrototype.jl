using Gtk
using OCReract
using Images
using CairoMakie

# Our matrix functions
include("matrixFunctions.jl")

# Set window size
window = GtkWindow("Matrix Wizard Prototype", 300, 250)

# Container object for widgets in grid layout
container = GtkGrid()

# container is added to the window; every widget should be added to the container NOT the window
push!(window, container)

# Create a label for the file path text input
path_label = GtkLabel("Path:")

# Button widget that will activate the file choosing dialog/activate the choose_file function
choose_file_button = GtkButton("Choose File")

# Text input for the file path
choose_file_input = GtkEntry()

# Button to use the OCReract on image
process_image_button = GtkButton("Process Image")

# Image output for selected image
selected_image = GtkImage("")

# Generate heatmap button widget
generate_hm_button = GtkButton("Generate Heatmap")

# Text label for the matrix that is derived from processing the image
matrix_label = GtkLabel("")

# Adding the widgets to the container using the grid coordinates
container[1,1] = path_label
container[2,1] = choose_file_input
container[3,1] = choose_file_button
container[2,2] = selected_image
container[2,3] = process_image_button
container[2,5] = matrix_label
container[3,5] = generate_hm_button 

# Placeholder text for the file text input widget
set_gtk_property!(choose_file_input, :placeholder_text, "File Not Chosen")


# Adds 3 pixels of space between the columns of a grid
set_gtk_property!(container, :column_spacing, 3) 


# Display the window
showall(window)

# Hide heatmap button
set_gtk_property!(generate_hm_button, :visible, false)

# File Dialog function
function choose_file(w)
    file_dialog = open_dialog("Pick an image file", GtkNullContainer(), ("*.png", "*.jpg", GtkFileFilter("*.png, *.jpg", name="All supported formats")))
    set_gtk_property!(choose_file_input,:text, file_dialog)
    img_path = get_gtk_property(choose_file_input, :text, String)
    set_gtk_property!(selected_image, :file, img_path)

end

# Function to derive the matrix values from the image
function process_image(w)
    set_gtk_property!(generate_hm_button, :visible, false)
    img_path = get_gtk_property(choose_file_input, :text, String)
    img = load(img_path)
    res = run_tesseract(img, psm=6)
    set_gtk_property!(matrix_label, :label, res)
    set_gtk_property!(generate_hm_button, :visible, true)
end

# Function that returns the values associated with a matrix in a dictionary
function get_matrix_values(matrix)
    return Dict(
        "matrix" => matrix,
        "dimensions" => matrixFunctions.dimensions(matrix), 
        "transpose" => matrixFunctions.transposer(matrix),
        "RREF" => matrixFunctions.RREF(matrix), 
        "trace" => matrixFunctions.trace(matrix),
        "determinant" => matrixFunctions.determinant(matrix),
        "rank" => matrixFunctions.rank(matrix), 
        "nullality" => matrixFunctions.nullality(matrix), 
        "eigenValues" => matrixFunctions.eigenVals(matrix), 
        "eigenVectors" => matrixFunctions.eigenVectors(matrix))
end

# Function that takes text from the matrix_label widget and converts it to a multidimensional array
function text_to_matrix(text)
    # \n char means next row and add 1 to dimy
    # white space means end of string on that row and add 1 to dimx
    # when string contains a character that is not a number that means negative
    numbers::Array{Int64} = []
    dimx::Int64 = 1
    dimy::Int64 = 0
    firstLineBroken::Bool = false
    number::String = ""
    for char in text
        
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
    matrix = Array{Int64}(undef, dimy, dimx)
    counter::Int64 = 1

    for y in range(1, dimy), x in range(1, dimx)
        matrix[y, x] = numbers[counter]
        counter += 1
    end
    return matrix
end

# Function to create heatmap of current loaded matrix
function create_heatmap(w)
    mat = matrixFunctions.transposer(text_to_matrix(get_gtk_property(matrix_label, :label, String)))
    dims = matrixFunctions.dimensions(mat)
    halfmax = maximum(mat)/2
    f = CairoMakie.Figure(resolution =(600, 600))
    ax = CairoMakie.Axis(f[1, 1], xticks = 1:dims[1], yticks = 1:dims[2], xaxisposition = :top)
    ax.yreversed = true
    ax.xticksize = 1
    ax.xlabelvisible = false
    h = CairoMakie.heatmap!(ax, mat)
    CairoMakie.Colorbar(f[1, 2], h)

    for x in 1:dims[1], y in 1:dims[2]
        txtcolor = mat[x, y] < halfmax ? :white : :black
        CairoMakie.text!(ax, string.(mat[x, y]), position = Point2f(x, y),
            color = txtcolor, align=(:center, :center), fontsize=20)
    end
    CairoMakie.display(f)

end

signal_connect(choose_file, choose_file_button, "clicked")
signal_connect(process_image, process_image_button, "clicked")
signal_connect(create_heatmap, generate_hm_button, "clicked")

# Close window if window is not interactive
if !isinteractive()
    @async Gtk.gtk_main()
    Gtk.waitforsignal(window,:destroy)
end
