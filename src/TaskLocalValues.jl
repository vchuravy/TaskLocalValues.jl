module TaskLocalValues

export TaskLocalValue

mutable struct TaskLocalValue{T, F}
    initializer::F
    TaskLocalValue{T}(initializer::F) where {T,F} = new{T,F}(initializer)
end

Base.eltype(::TaskLocalValue{T}) where T = T

function Base.getindex(val::TaskLocalValue{T}) where T
    tls = Base.task_local_storage()
    get!(()->val.initializer()::T, tls, val)::T
end

function Base.setindex!(val::TaskLocalValue{T}, value) where T
    Base.task_local_storage(val, convert(T, value))
    return value
end

Base.delete!(val::TaskLocalValue) = delete!(Base.task_local_storage(), val)

end # module TaskLocalValues
