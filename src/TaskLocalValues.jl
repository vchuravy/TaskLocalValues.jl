module TaskLocalValues

mutable struct TaskLocalValue{T, F}
    initializer::F
end

function Base.getindex(val::TaskLocalValue{T}) where T
    tls = Base.task_local_storage()
    get!(()->val.initializer()::T, tls, val)::T
end

function Base.setindex!(val::TaskLocalValue{T}, value::T) where T
    Base.task_local_storage(val, value)
    return value
end

end # module TaskLocalValues
