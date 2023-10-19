# enter a set of messages, where they follow the pattern VAR = VALUE


function getNumOfKVPairs()
    print("How many replacements do you want to run?\n>")
    replacementNumstr::String = readline()
    replacementNumint::Int = 0
    try
        replacementNumint = parse(Int64, replacementNumstr)
    catch e
        println("you need to enter a positive non-zero integer")
        return getNumOfKVPairs()
    end

    if replacementNumint <= 0
        println("you need to enter a positive non-zero integer")
        return getNumOfKVPairs()
    end
    
    return replacementNumint
end

function getKVPairs(num::Int)
    print("enter $num lines in the format key=value\n")
    replacement::Dict{String, String} = Dict()
    for i in 1:num
        print(">")
        line = readline()
        parts = split(line, "=")
        replacement[parts[1]] = parts[2]
    end
    return replacement
end

function getAndParseText(replacment::Dict{String, String})
    print("enter text to parse, press Ctrl-D to finish\n")
    lines = readlines()
    block::String = join(lines, "\n")
    for (key, value) in replacment
        block = replace(block, key=>value)
    end

    return block

end

function runReplaceText()
    result = getAndParseText(getKVPairs(getNumOfKVPairs()))
    print("\nresult:\n")
    print("$result\n")
end

function calcAverage()
    print("enter your values as a space seperated list\n>")
    line = split(readline(), " ")
    values::Array{Int64} = []
    try
        for val in line
            val = parse(Int64, val)
            push!(values, val)
        end
    catch e
        print("Please enter a valid input $e")
        calcAverage()
    end
    return sum(values)/length(values)

end

function main()
    print("Select a tool:\n1=Text Replace\n2=Average\n>")
    try
        input = parse(Int64, readline())
        if input == 1
            runReplaceText()
            readline()
        elseif input == 2
            println(calcAverage())
        else
            throw(Exception)
        end
    catch e 
        print("Please select a valid option $e\n")
        main()
    end
end

main()