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
    Tvalue = convert(T, value)
    Base.task_local_storage(val, Tvalue)
    return Tvalue
end

end # module TaskLocalValues
