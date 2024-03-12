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
    delete!(tlv)
    @test !(haskey(Base.task_local_storage(), tlv))
    @test tlv[] == 0
    @test haskey(Base.task_local_storage(), tlv)
end
