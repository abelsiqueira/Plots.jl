
typealias AVec AbstractVector
typealias AMat AbstractMatrix

immutable PlotsDisplay <: Display end

abstract AbstractBackend
abstract AbstractPlot{T<:AbstractBackend}

# -----------------------------------------------------------
# Plot
# -----------------------------------------------------------

type Plot{T<:AbstractBackend} <: AbstractPlot{T}
    o                        # the backend's plot object
    backend::T               # the backend type
    n::Int                   # number of series
    plotargs::Dict           # arguments for the whole plot
    seriesargs::Vector{Dict} # arguments for each series
end

# -----------------------------------------------------------
# Layout
# -----------------------------------------------------------

abstract SubplotLayout

# -----------------------------------------------------------
# Subplot
# -----------------------------------------------------------

type Subplot{T<:AbstractBackend, L<:SubplotLayout} <: AbstractPlot{T}
    o                           # the underlying object
    plts::Vector{Plot{T}}          # the individual plots
    backend::T
    p::Int                      # number of plots
    n::Int                      # number of series
    layout::L
    # plotargs::Vector{Dict}
    plotargs::Dict
    initialized::Bool
    linkx::Bool
    linky::Bool
    linkfunc::Function # maps (row,column) -> (BoolOrNothing, BoolOrNothing)... if xlink/ylink are nothing, then use subplt.linkx/y
end

# -----------------------------------------------------------------------
