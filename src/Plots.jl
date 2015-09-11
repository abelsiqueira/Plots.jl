__precompile__()

module Plots

using Colors

export
  Plot,
  plotter,
  plot,
  currentPlot,
  plotDefault,
  scatter,
  bar,
  histogram,
  heatmap,

  plotter!,
  plot!,
  currentPlot!,
  plotDefault!,
  scatter!,
  bar!,
  histogram!,
  heatmap!,

  savepng

# ---------------------------------------------------------

typealias AVec AbstractVector
typealias AMat AbstractMatrix

abstract PlottingObject
abstract PlottingPackage

const IMG_DIR = Pkg.dir("Plots") * "/img/"


# ---------------------------------------------------------

type Plot <: PlottingObject
  o  # the underlying object
  plotter::PlottingPackage
  n::Int # number of series
end

Base.string(plt::Plot) = "Plot{$(plt.plotter) n=$(plt.n)}"
Base.print(io::IO, plt::Plot) = print(io, string(plt))
Base.show(io::IO, plt::Plot) = print(io, string(plt))

getplot(plt::Plot, args...) = plt

# ---------------------------------------------------------

type CurrentPlot
  nullableplot::Nullable{PlottingObject}
end
const CURRENT_PLOT = CurrentPlot(Nullable{PlottingObject}())

isplotnull() = isnull(CURRENT_PLOT.nullableplot)

function currentPlot()
  if isplotnull()
    error("No current plot/subplot")
  end
  get(CURRENT_PLOT.nullableplot)
end
currentPlot!(plot::PlottingObject) = (CURRENT_PLOT.nullableplot = Nullable(plot))

# ---------------------------------------------------------

include("qwt.jl")
include("gadfly.jl")
include("plotter.jl")

# ---------------------------------------------------------

include("utils.jl")
include("args.jl")
include("plot.jl")
include("subplot.jl")


# const LINE_TYPES = (:line, :step, :stepinverted, :sticks, :dots, :none, :heatmap, :hist, :bar)
scatter(args...; kw...)    = plot(args...; kw...,  linetype = :none, marker = :hexagon)
scatter!(args...; kw...)   = plot!(args...; kw..., linetype = :none, marker = :hexagon)
bar(args...; kw...)        = plot(args...; kw...,  linetype = :bar)
bar!(args...; kw...)       = plot!(args...; kw..., linetype = :bar)
histogram(args...; kw...)  = plot(args...; kw...,  linetype = :hist)
histogram!(args...; kw...) = plot!(args...; kw..., linetype = :hist)
heatmap(args...; kw...)    = plot(args...; kw...,  linetype = :heatmap)
heatmap!(args...; kw...)   = plot!(args...; kw..., linetype = :heatmap)


# ---------------------------------------------------------

# # TODO: how do we handle NA values in dataframes?
# function plot!(plt::Plot, df::DataFrame; kw...)                 # one line per DataFrame column, labels == names(df)
# end

# function plot!(plt::Plot, df::DataFrame, columns; kw...)        # one line per column, but on a subset of column names
# end


savepng(args...; kw...) = savepng(currentPlot(), args...; kw...)
savepng(plt::Plot, args...; kw...) = savepng(plt.plotter, plt, args...; kw...)


# ---------------------------------------------------------

end # module