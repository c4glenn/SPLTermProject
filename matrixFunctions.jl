# https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/

function dimensions(a)
    rows = size(a)[1]
    cols = size(a[1])[1]
    return [rows, cols]
end

function transposer(a)
    dim = dimensions(a)
    print(a)
    #this should all work but when I try to create a 2d array it makes this weird matrix thing. I dont understand whats going on >:(
    b = ones(Int, dim[2], dim[1])
    print(b)
    for i in 1:dim[2]
        for k in 1:dim[1]
            b[i][k] = a[k][i]
        end
    end
    print(b)
end


function RREF(a)
    throw("unimplemented")
end

function trace(a)
    throw("unimplemented")
end

function determinant(a)
    throw("unimplemented")
end

function rank(a)
throw("unimplemented")
end

function nullality(a)
    throw("unimplemented")
end

function eigenVals(a)
    throw("unimplemented")
end

function eigenVectors(a)
    throw("unimplemented")
end

#testing transposer
a = [[1,2,3],[4,5,6]]

c = transposer(a)

println(c)