n = 3
m = 2
p = 5

info("Testing ", MODPF.dotvectors!)
for T in FloatingPointTypes
    Set_X = [rand(T, p) for i = 1:n]
    Set_Y = [rand(T,p)  for i = 1:m]

    X = transpose(hcat(Set_X...))
    Y = transpose(hcat(Set_Y...))
    
    @test isapprox(MODPF.dotvectors(RowMajor(),    X), vec(sum((X.*X),2)))
    @test isapprox(MODPF.dotvectors(ColumnMajor(), X), vec(sum((X.*X),1)))

    @test isapprox(MODPF.dotvectors!(RowMajor(),    Vector{T}(n), X), vec(sum((X.*X),2)))
    @test isapprox(MODPF.dotvectors!(ColumnMajor(), Vector{T}(p), X), vec(sum((X.*X),1)))

    @test_throws DimensionMismatch MODPF.dotvectors!(RowMajor(),    Vector{T}(2), Array{T}(3,2))
    @test_throws DimensionMismatch MODPF.dotvectors!(RowMajor(),    Vector{T}(4), Array{T}(3,4))
    @test_throws DimensionMismatch MODPF.dotvectors!(ColumnMajor(), Vector{T}(2), Array{T}(2,3))
end

info("Testing ", MODPF.gramian!)
for T in FloatingPointTypes
    Set_X = [rand(T, p) for i = 1:n]
    Set_Y = [rand(T,p)  for i = 1:m]

    X = transpose(hcat(Set_X...))
    Y = transpose(hcat(Set_Y...))

    P = [dot(x,y) for x in Set_X, y in Set_X]

    @test isapprox(MODPF.gramian!(RowMajor(),    Array{T}(n,n), X,  true), P)
    @test isapprox(MODPF.gramian!(ColumnMajor(), Array{T}(n,n), X', true), P)

    P = [dot(x,y) for x in Set_X, y in Set_Y]
    @test isapprox(MODPF.gramian!(RowMajor(),    Array{T}(n,m), X,  Y),  P)
    @test isapprox(MODPF.gramian!(ColumnMajor(), Array{T}(n,m), X', Y'), P)

    @test_throws DimensionMismatch MODPF.gramian!(RowMajor(), Array{T}(n+1,n),   X, true)
    @test_throws DimensionMismatch MODPF.gramian!(RowMajor(), Array{T}(n,n+1),   X, true)
    @test_throws DimensionMismatch MODPF.gramian!(RowMajor(), Array{T}(n+1,n+1), X, true)

    @test_throws DimensionMismatch MODPF.gramian!(ColumnMajor(), Array{T}(n+1,n),   X', true)
    @test_throws DimensionMismatch MODPF.gramian!(ColumnMajor(), Array{T}(n,n+1),   X', true)
    @test_throws DimensionMismatch MODPF.gramian!(ColumnMajor(), Array{T}(n+1,n+1), X', true)

    @test_throws DimensionMismatch MODPF.gramian!(RowMajor(),    Array{T}(n+1,m), X,  Y)
    @test_throws DimensionMismatch MODPF.gramian!(RowMajor(),    Array{T}(n,m+1), X,  Y)
    @test_throws DimensionMismatch MODPF.gramian!(ColumnMajor(), Array{T}(n+1,m), X', Y')
    @test_throws DimensionMismatch MODPF.gramian!(ColumnMajor(), Array{T}(n,m+1), X', Y')

    @test_throws DimensionMismatch MODPF.gramian!(RowMajor(),    Array{T}(m+1,n), Y,  X)
    @test_throws DimensionMismatch MODPF.gramian!(RowMajor(),    Array{T}(m,n+1), Y,  X)
    @test_throws DimensionMismatch MODPF.gramian!(ColumnMajor(), Array{T}(m+1,n), Y', X')
    @test_throws DimensionMismatch MODPF.gramian!(ColumnMajor(), Array{T}(m,n+1), Y', X')
end
