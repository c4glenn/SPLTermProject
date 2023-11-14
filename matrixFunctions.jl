# https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/

function dimensions(a)
    rows = size(a)[1]
    cols = size(a)[2]
    return [rows, cols]
end

function transposer(a)
    dim = dimensions(a)
    b = zeros(Int64, (dim[2], dim[1]))
    println(b)
    for i in 1:dim[2]
        for k in 1:dim[1]
            b[i, k] = a[k, i]
        end
    end
    return b
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

