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
end
