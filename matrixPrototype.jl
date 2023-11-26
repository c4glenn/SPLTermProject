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


# Adding the widgets to the container using the grid coordinates
container[1,1] = path_label
container[2,1] = choose_file_input
container[3,1] = choose_file_button
container[2,2] = selected_image
container[2,3] = process_image_button
container[3,5] = generate_hm_button 
# matrix values
container[1,5] = GtkLabel("Matrix: ")
container[1,6] = GtkLabel("Dimensions: ")
container[1,7] = GtkLabel("Transpose: ")
container[1,8] = GtkLabel("RREF: ")
container[1,9] = GtkLabel("Trace: ")
container[1,10] = GtkLabel("Determinant: ")
container[1,11] = GtkLabel("Rank: ")
container[1,12] = GtkLabel("Nullity: ")
container[1,13] = GtkLabel("Eigen Values: ")
container[1,14] = GtkLabel("Eigen Vectors: ")
matrix_label = GtkLabel("")
dimension_label = GtkLabel("")
transpose_label = GtkLabel("")
rref_label = GtkLabel("")
trace_label = GtkLabel("")
determinant_label = GtkLabel("")
rank_label = GtkLabel("")
nullity_label = GtkLabel("")
eigenValues_label = GtkLabel("")
eigenVectors_label = GtkLabel("")
container[2,5] = matrix_label
container[2,6] = dimension_label
container[2,7] = transpose_label
container[2,8] = rref_label
container[2,9] = trace_label
container[2,10] = determinant_label
container[2,11] = rank_label
container[2,12] = nullity_label
container[2,13] = eigenValues_label
container[2,14] = eigenVectors_label

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
    set_gtk_property!(generate_hm_button, :visible, true)
    
    matrix_dict = get_matrix_values(text_to_matrix(res))
    display_matrix_values(matrix_dict)
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
        "nullity" => matrixFunctions.nullality(matrix), 
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

function matrix_to_text(matrix)
    text = ""
    dimx = matrixFunctions.dimensions(matrix)[1]
    dimy = matrixFunctions.dimensions(matrix)[2]
    for x in range(1, dimx)
        for y in range(1, dimy)
            if y == 1
                text = string(text, matrix[x, y])
                continue
            end
            text = string(text, " ", matrix[x, y])
        end
        text = string(text, "\n")
    end
    return text
end

# Function to create heatmap of current loaded matrix
function create_heatmap(w)
    mat = matrixFunctions.transposer(text_to_matrix(get_gtk_property(container[2,5], :label, String)))
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

function display_matrix_values(values)
    # dimension_label = string(values["dimensions"])
    # transpose_label= string(matrix_to_text(values["transpose"]))
    # rref_label = string(values["RREF"])
    # trace_label = string(values["trace"])
    # determinant_label = string(values["determinant"])
    # rank_label = string(values["rank"])
    # nullity_label= string(values["nullity"])
    # eigenValues_label = string(values["eigenValues"])
    # eigenVectors_label = string(values["eigenVectors"])
    set_gtk_property!(matrix_label, :label, string(matrix_to_text(values["matrix"])))
    set_gtk_property!(dimension_label, :label, string("rows=", values["dimensions"][1], " | columns=", values["dimensions"][2]))
    set_gtk_property!(transpose_label, :label, string(matrix_to_text(values["transpose"])))
    set_gtk_property!(rref_label, :label, string(values["RREF"]))
    set_gtk_property!(trace_label, :label, string(values["trace"]))
    set_gtk_property!(determinant_label, :label, string(values["determinant"]))
    set_gtk_property!(rank_label, :label, string(values["rank"]))
    set_gtk_property!(nullity_label, :label, string(values["nullity"]))
    set_gtk_property!(eigenValues_label, :label, string(values["eigenValues"]))
    set_gtk_property!(eigenVectors_label, :label, string(values["eigenVectors"]))
end

signal_connect(choose_file, choose_file_button, "clicked")
signal_connect(process_image, process_image_button, "clicked")
signal_connect(create_heatmap, generate_hm_button, "clicked")

# Close window if window is not interactive
if !isinteractive()
    @async Gtk.gtk_main()
    Gtk.waitforsignal(window,:destroy)
end
