export

	#advection_diffusion.jl
	FEM_heatflow,
	implicitEulerStepFamily,
	ADimplicitEulerStep,

	#ellipticLCS.jl
	Singularity,
	# getcoords,
	# getindices,
	# EllipticBarrier,
	# EllipticVortex,
	LCSParameters,
	S1Dist,
	P1Dist,
	# compute_singularities,
	# singularity_detection,
	# critical_point_detection,
	# compute_returning_orbit,
	# compute_closed_orbits,
	getvortices,
	ellipticLCS,
	constrainedLCS,
	materialbarriers,
	Combine20,
	Combine20Aggressive,
	Combine31,
	flowgrow,
	FlowGrowParams,
	area,
	centroid,
	clockwise,

	#diffusion_operators.jl
	gaussian,
	gaussiancutoff,
	KNN,
	MutualKNN,
	Neighborhood,
	DM_heatflow,
	sparse_diff_op_family,
	sparse_diff_op,
	# kde_normalize!,
	row_normalize!,
	unionadjacency,
	# stationary_distribution,
	diffusion_coordinates,
	diffusion_distance,

	#dynamicmetrics
	STmetric,
	stmetric,
	# spdist,

	#FEMassembly.jl
	assemble,
	Stiffness,
	Mass,

	#gridfunctions.jl
	regular1dGridTypes,
	regular2dGridTypes,
	regular1dPCGrid,
	regular1dP1Grid,
	regular1dP2Grid,
	regularTriangularGrid,
	regularDelaunayGrid,
	irregularDelaunayGrid,
	randomDelaunayGrid,
	regularP2TriangularGrid,
	regularP2DelaunayGrid,
	regularQuadrilateralGrid,
	regularP2QuadrilateralGrid,
	regularTetrahedralGrid,
	regularP2TetrahedralGrid,
	evaluate_function_from_dofvals,
	evaluate_function_from_node_or_cellvals,
	evaluate_function_from_node_or_cellvals_multiple,
	locatePoint,
	nodal_interpolation,
    sample_to,
	undoBCS,
	doBCS,
	applyBCS,
	getHomDBCS,
	BoundaryData,
	nBCDofs,
	getDofCoordinates,
	getCellMidpoint,

	#ulam,jl
	ulam,

	#plotting.jl
	plot_u,
	plot_u!,
	plot_spectrum,
	plot_real_spectrum,
	plot_u_eulerian,
	plot_ftle,
	eulerian_videos,
	eulerian_video,
	plot_field,
	plot_field!,
	plot_barrier,
	plot_barrier!,
	plot_singularities,
	plot_singularities!,
	plot_vortices,

	#pullbacktensors.jl
	flow,
	linearized_flow,
	mean_diff_tensor,
	CG_tensor,
	pullback_tensors,
	pullback_metric_tensor,
	pullback_diffusion_tensor,
	pullback_SDE_diffusion_tensor,
	av_weighted_CG_tensor,

	#TO.jl
	nonAdaptiveTOCollocation,
	adaptiveTOCollocation,
	adaptiveTOCollocationStiffnessMatrix,
	L2GalerkinTO,
	L2GalerkinTOFromInverse,
	adaptiveTOCollocation,

	#util.jl
	tensor_invariants,
	dof2node,
	kmeansresult2LCS,
	getH,

	#velocityfields.jl
	interpolateVF,
	interp_rhs,
	interp_rhs!,
	standardMap,
	standardMapInv,
	DstandardMap,
	abcFlow,
	cylinder_flow,

	#seba.jl
	SEBA,

	#odesolvers.jl
	LinearImplicitEuler,
	LinearMEBDF2
