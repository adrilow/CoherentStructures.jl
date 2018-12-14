# # The standard map
#
#md # The (computable) notebook for this example can be found
#md # [here](https://nbviewer.jupyter.org/github/CoherentStructures/CoherentStructures.jl/blob/gh-pages/latest/generated/standard_map.ipynb).
#md #
# The standard map
# ```math
# f(x,y) = (x+y+a\sin(x),y+a\sin(x))
# ```
# is an area-preserving map on the 2-torus $[0,2\pi]^2$ resulting from a symplectic
# time-discretization of the planar pendulum.  For $a = 0.971635$, its phase space
# shows the characteristic mixture of regular (periodic or quasi-periodic) and
# chaotic motion.  Here, we repeat the experiment in
# [Froyland & Junge (2015)](https://arxiv.org/abs/1505.05056) and compute coherent structures.
#
# We first visualize the phase space by plotting 500 iterates of 50 random seed points.

using Random

a = 0.971635
f(a,x) = (mod(x[1] + x[2] + a*sin(x[1]), 2π),
          mod(x[2] + a*sin(x[1]), 2π))

X = []
for i in 1:50
    Random.seed!(i)
    x = 2π*rand(2)
    for i in 1:500
        x = f(a,x)
        push!(X,x)
    end
end

using Plots
gr(aspect_ratio=1, legend=:none)
scatter([x[1] for x in X], [x[2] for x in X], markersize=1)

# Approximating the Dynamic Laplacian by FEM methods is straightforward:

using Arpack, CoherentStructures, Tensors

Df(a,x) = Tensor{2,2}((1.0+a*cos(x[1]), a*cos(x[1]), 1.0, 1.0))

n, ll, ur = 100, [0.0,0.0], [2π,2π]               # grid size, domain corners
ctx, _ = regularTriangularGrid((n,n), ll, ur)
pred(x,y) = peuclidean(x[1], y[1], 2π) < 1e-9 &&
            peuclidean(x[2], y[2], 2π) < 1e-9
bd = boundaryData(ctx, pred)                      # periodic boundary

I = one(Tensor{2,2})                              # identity matrix
Df2(x) = Df(a,f(a,x))⋅Df(a,x)                     # consider 2. iterate
cg(x) = 0.5*(I + dott(inv(Df2(x))))               # avg. inv. Cauchy-Green tensor

K = assembleStiffnessMatrix(ctx, cg, bdata=bd)
M = assembleMassMatrix(ctx, bdata=bd)
λ, v = eigs(K, M, which=:SM)

using Printf
title = [ @sprintf("\\lambda = %.3f",λ[i]) for i = 1:4 ]
p = [ plot_u(ctx, v[:,i], bdata=bd, title=title[i],
             clim=(-0.25,0.25), cb=false) for i in 1:4 ]
plot(p...)
