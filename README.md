# TaskLocalValues

Task local storage in Julia allows developers to store data within a task.
TaskLocalValues.jl solves two problems of task local storage:
1. Accesses to task local storage is not type-stable.
2. Keys can conflict between users.

A common pattern in Julia currently is to use symbols as keys to task local
storage. If two packages use the same symbol they would silently conflict.
TaskLocalValues.jl does not use symbols, but rather uses the object identity
of the task local value itself, guaranteeing that no silent conflicts can occur.

The `TaskLocalValue` struct also carries an initializer and type-information.

## Usage

```julia
import Base.Threads: @spawn
using TaskLocalValues

const counter = TaskLocalValue{Int}(()->0)

@show counter[] # 0 -- initialized on first use
counter[] += 1
@show counter[] # 1
@sync begin
    @spawn begin
        @show counter[] # 0 -- each tasks gets their own copy
        counter[] += 1
    end
end
```
