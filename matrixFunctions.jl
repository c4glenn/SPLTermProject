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

#braden
function RREF(a)
    throw("unimplemented")
end

#Rapha
function trace(a)
    throw("unimplemented")
end

#braden
function determinant(a)
    throw("unimplemented")
end

#ronni
function rank(a)
throw("unimplemented")
end

#ronni
function nullality(a)
    throw("unimplemented")
end
#rapha
function eigenVals(a)
    throw("unimplemented")
end

#braden
function eigenVectors(a)
    throw("unimplemented")
end

