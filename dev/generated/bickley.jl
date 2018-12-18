using CoherentStructures
bickley = @velo_from_stream stream begin
    stream = psi₀ + psi₁
    psi₀   = - U₀ * L₀ * tanh(y / L₀)
    psi₁   =   U₀ * L₀ * sech(y / L₀)^2 * re_sum_term

    re_sum_term =  Σ₁ + Σ₂ + Σ₃

    Σ₁  =  ε₁ * cos(k₁*(x - c₁*t))
    Σ₂  =  ε₂ * cos(k₂*(x - c₂*t))
    Σ₃  =  ε₃ * cos(k₃*(x - c₃*t))

    k₁ = 2/r₀      ; k₂ = 4/r₀    ; k₃ = 6/r₀

    ε₁ = 0.0075    ; ε₂ = 0.15    ; ε₃ = 0.3
    c₂ = 0.205U₀   ; c₃ = 0.461U₀ ; c₁ = c₃ + (√5-1)*(c₂-c₃)

    U₀ = 62.66e-6  ; L₀ = 1770e-3 ; r₀ = 6371e-3
end

using Distributed
nprocs() == 1 && addprocs()

@everywhere using CoherentStructures, OrdinaryDiffEq, Tensors
using StaticArrays
import AxisArrays
const AA = AxisArrays
q = 81
const tspan = range(0., stop=3456000., length=q)
ny = 61
nx = (22ny) ÷ 6
xmin, xmax, ymin, ymax = 0.0 - 2.0, 6.371π + 2.0, -3.0, 3.0
xspan = range(xmin, stop=xmax, length=nx)
yspan = range(ymin, stop=ymax, length=ny)
P = AA.AxisArray(SVector{2}.(xspan, yspan'), xspan, yspan)
const δ = 1.e-6
const DiffTensor = SymmetricTensor{2,2}([2., 0., 1/2])
mCG_tensor = u -> av_weighted_CG_tensor(bickleyJet, u, tspan, δ;
          D=DiffTensor, tolerance=1e-6, solver=Tsit5())

C̅ = pmap(mCG_tensor, P; batch_size=ny)
p = LCSParameters(3*max(step(xspan), step(yspan)), 2.0, true, 60, 0.7, 1.5, 1e-4)
vortices, singularities = ellipticLCS(C̅, p)

import Plots
λ₁, λ₂, ξ₁, ξ₂, traceT, detT = tensor_invariants(C̅)
fig = Plots.heatmap(xspan, yspan, permutedims(log10.(traceT));
                    aspect_ratio=1, color=:viridis, leg=true,
                    xlims=(0, 6.371π), ylims=(-3, 3),
                    title="DBS field and transport barriers")
Plots.scatter!(fig, getcoords(singularities), color=:red)
for vortex in vortices
    Plots.plot!(fig, vortex.curve, color=:yellow, w=3, label="T = $(round(vortex.p, digits=2))")
    Plots.scatter!(fig, vortex.core, color=:yellow)
end

Plots.plot(fig)

LL = [0.0, -3.0]; UR = [6.371π, 3.0]
ctx, _ = regularP2TriangularGrid((50, 15), LL, UR, quadrature_order=2)
predicate = (p1,p2) -> abs(p1[2] - p2[2]) < 1e-10 && peuclidean(p1[1], p2[1], 6.371π) < 1e-10
bdata = CoherentStructures.boundaryData(ctx, predicate, []);

using Arpack
cgfun = (x -> mean_diff_tensor(bickley, x, range(0.0, stop=40*3600*24, length=81),
     1.e-8; tolerance=1.e-5))

K = assembleStiffnessMatrix(ctx, cgfun, bdata=bdata)
M = assembleMassMatrix(ctx, bdata=bdata)
λ, v = eigs(K, M, which=:SM, nev= 10)

import Plots
plot_real_spectrum(λ)

using Clustering
ctx2, _ = regularTriangularGrid((200, 60), LL, UR)
v_upsampled = sample_to(v, ctx, ctx2, bdata=bdata)

function iterated_kmeans(numiterations, args...)
    best = kmeans(args...)
    for i in 1:(numiterations - 1)
        cur = kmeans(args...)
        if cur.totalcost < best.totalcost
            best = cur
        end
    end
    return best
end

n_partition = 8
res = iterated_kmeans(20, permutedims(v_upsampled[:,2:n_partition]), n_partition)
u = kmeansresult2LCS(res)
u_combined = sum([u[:,i] * i for i in 1:n_partition])
fig = plot_u(ctx2, u_combined, 400, 400;
    color=:rainbow, colorbar=:none, title="$n_partition-partition of Bickley jet")

Plots.plot(fig)

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

