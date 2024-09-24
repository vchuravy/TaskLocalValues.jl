using TaskLocalValues
using Test

const tlv = TaskLocalValue{Int}(()->0)

import Base.Threads: @spawn

@testset "basics" begin
    @test eltype(tlv) == Int
    @test tlv[] == 0
    tlv[] += 1
    @test tlv[] == 1
    @sync begin
        @spawn begin
            @test tlv[] == 0
            tlv[] += 1
            @test tlv[] == 1
        end
        @spawn begin
            @test tlv[] == 0
            tlv[] += 1
            @test tlv[] == 1
        end
    end
    empty!(tlv)
    @test !(haskey(Base.task_local_storage(), tlv))
    @test tlv[] == 0
    @test haskey(Base.task_local_storage(), tlv)
    # Constructor without T (inferred from initializer)
    tlv2 = TaskLocalValue(() -> 0.0)
    @test tlv2 isa TaskLocalValue{Float64}
end
