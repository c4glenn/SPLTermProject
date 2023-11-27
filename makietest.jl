using CairoMakie
using LinearAlgebra
testMatrix = [1 2 3 4; 4 5 6 6; 7 8 9 6]
testMatrix = transpose(testMatrix)
f = Figure(resolution =(600, 600))

ax = Axis(f[1, 1], xticks = 1:4, yticks = 1:3, xaxisposition = :top)


# text!(ax, string.(testMatrix[x, y] for x in 1:4 for y in 1:3), position=[Point2f(x, y) for x in 1:4 for y in 1:3], align=(:center, :center), color=ifelse.(testMatrix[x, y]< 5, :white, :black for x in 1:4 for y in 1:3), textsize=14)


ax.yreversed = true
ax.xticksize = 1
ax.xlabelvisible = false
h = heatmap!(ax, testMatrix)
Colorbar(f[1, 2], h)
for x in 1:4, y in 1:3
    txtcolor = testMatrix[x, y] < 5 ? :white : :black
    text!(ax, string.(testMatrix[x, y]), position = Point2f(x, y),
        color = txtcolor, align=(:center, :center), fontsize=20)
end
display(f)
