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
        m,n=size(a)
        mat = convert(Matrix{Float64}, a)
        for i=1:m
            if mat[i,i] == 0
                continue
            end 
            mat[i,:]=mat[i,:]/mat[i,i]; 
            for j=1:m 
                if j==i; continue; 
                end
            mat[j,:]=mat[j,:]-mat[j,i]*mat[i,:]
            end 
        end
        sol=mat

        return sol
    end

    #braden
    function trace(a)
        row, col = dimensions(a)
        if(row != col)
            return "Matrix not square :("
        end
        total = 0
        for i in range(1, row)
            total += a[i, i]
        end
        return total
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