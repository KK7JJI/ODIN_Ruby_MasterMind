def SUM(N):
    if N == 0:
        return 0
    else:
        return N + SUM(N-1)

def SUM2(N):
    sum = 0
    for i in range(0,N+1):
        sum = sum + i
    return sum


print(SUM(10))
print(SUM2(10))
