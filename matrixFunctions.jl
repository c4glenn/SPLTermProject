# https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/

module matrixFunctions
    using LinearAlgebra
    function dimensions(a)
        rows = size(a)[1]
        cols = size(a)[2]
        return [rows, cols]
    end

    function transposer(a)
        dim = dimensions(a)
        b = zeros(Int64, (dim[2], dim[1]))
        # println(b)
        for i in 1:dim[2]
            for k in 1:dim[1]
                b[i, k] = a[k, i]
            end
        end
        return b
        # return LinearAlgebra.transpose(a)
    end

    #braden
    function RREF(a)
        # throw("unimplemented")
        return nothing
    end

    #braden
    function trace(a)
        # throw("unimplemented")
        return nothing
    end

    #ronni
    function determinant(a)
        # throw("unimplemented")
        try
            return LinearAlgebra.det(a)
        catch
            return "Matrix not square :("
        end
    end

    #ronni
    function rank(a)
        # throw("unimplemented")
        return LinearAlgebra.rank(a)
    end

    #ronni
    function nullality(a)
        # throw("unimplemented")
        return size(a)[2] - rank(a)
    end
    #rapha
    function eigenVals(a)
        # throw("unimplemented")
        try
            return LinearAlgebra.eigen(a).values
        catch
            return "Matrix not square :("
        end
    end

    #Rapha
    function eigenVectors(a)
        # throw("unimplemented")
        try
            return LinearAlgebra.eigen(a).vectors
        catch
            return "Matrix not square :("
        end
    end

end
export matrixFunctions