using Plots
using Printf

file = open("input.txt")
pose = readline(file)
poselist = rsplit(pose," ")
initialpose = map(x -> parse(Float64, x) , poselist)

t = readline(file)
deltat = parse(Int64,t)

vect = readline(file)
vectlist = rsplit(vect," ")
vectorlist = map(x -> parse(Float64, x) , vectlist)
velocity = 1 # set constant speed

currentx = Array{Float64}(undef, length(vectorlist) * deltat + 1)
currenty = Array{Float64}(undef, length(vectorlist) * deltat + 1)
currentheading = Array{Float64}(undef, length(vectorlist) * deltat + 1)
currentx[1] = initialpose[1]
currenty[1] = initialpose[2]
currentheading[1] = initialpose[3]
curheading = currentheading[1]
index = 2
prevx = initialpose[1]
prevy = initialpose[2]
println(@sprintf("Initial: X = %.2f, Y = % .2f, Heading = %.2f", prevx, prevy, (curheading % 360)))
for i in 1:length(vectorlist)
    for j in 1:deltat
        global curheading += vectorlist[i]
        global prevx += velocity * cos((curheading) * (pi / 180)) # Euler's Method
        global prevy += velocity * sin((curheading) * (pi / 180))
        currentx[index] = prevx
        currenty[index] = prevy
        currentheading[index] = curheading
        global index += 1
    end
    println(@sprintf("After Timestamp %d: X = %.2f, Y = %.2f, Heading = %.2f",i, prevx, prevy, (curheading % 360)))
end
k = range(start = 1, stop = length(currentx))
x1 = currentx[k]
y1 = currenty[k]


@userplot Trajectory
@recipe function f(cp::Trajectory)
    x, y, i = cp.args
    n = length(x)
    inds = circshift(1:n, 1 - i)
    linewidth --> 4
    seriesalpha --> range(0, 1, length = n)
    aspect_ratio --> 1
    label --> false
    x[inds], y[inds]
end

# Gif Option 1
gify = @animate for i ∈ 1:length(currentx)-1
    trajectory(x1,y1, i)
end when i < length(currentx)

# Gif Option 2
# p = plot(1)
# gify = @animate for i=1:1:length(currentx)
#   push!(p, 1, (currentx[i],currenty[i]))
# end
gif(gify, "unicycle.gif", fps = 50)
