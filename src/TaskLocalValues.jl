module TaskLocalValues

export TaskLocalValue

mutable struct TaskLocalValue{T, F}
    initializer::F
    TaskLocalValue{T}(initializer::F) where {T,F} = new{T,F}(initializer)
    function TaskLocalValue(initializer::F) where {F}
        return new{Base.promote_op(initializer), F}(initializer)
    end
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

"""
    empty!(tlv::TaskLocalValue)

Remove the current state of `tlv` from the current task-local-storage, potentially allowing
it to be garbage collected. Calling `getindex!` or `setindex!` on `tlv` will cause it to be
re-initialized.
"""
Base.empty!(val::TaskLocalValue) = delete!(Base.task_local_storage(), val)

end # module TaskLocalValues
