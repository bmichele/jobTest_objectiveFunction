# Implementation of the objective function of "Y. Wang, Y. Zheng, and Y. Xue,
# 2014.Travel Time Estimation of a Path using Sparse Trajectories.", eq(3).

#--------------------------#
# buildObjectiveFunction() #
#--------------------------#
# Arguments
#----------
#  - The tensor A = Ar || Ah. Each element of Ar corresponds to the time spent
#    by a particular driver for traveling a particular road segment in a
#    particular time slot. Ah is the same, but contains historical data.
#  - The matrix X = Xr || Xh. Each element of Xr corresponds to the count of
#    vehicles in a specific grid of the city during a specific time slot. Xh is
#    similar, but contains historical data.
#  - The matrix Y, which stores geographical features of the road segments
#  - l1, l2, l3, control parameters
#
# Output
#-------
# buildObjectiveFunction(A, X, Y, l1, l2, l3) returns a function that correspond
# to the objective function L defined in eq.(3) of the main reference, with the
# specified A, X, Y, l1, l2, l3.
# Such function takes as arguments the tensors S, R, U, T, F, G, and the names
# of the indices shared by
#  - S and R (sumR),
#  - S and U (sumU),
#  - S and T (sumT).
# See the example in test_objectiveFunction.R

buildObjectiveFunction <- function(A, X, Y, l1 = 0.02, l2 = 0.02, l3= 0.02){
    
    objectiveFunction <- function( S, R, U, T, F, G , sumR, sumU, sumT){
        
        # compute tensor product SxRxTxU
        SRUT <- mul.tensor(
            mul.tensor(
                mul.tensor(
                    S,i=sumR,
                    R,j=sumR
                )
                ,i=sumU,
                U,j=sumU
            )
            ,i=sumT,
            T,j=sumT
        )
        # compute products TxG and RxF
        TG <- mul.tensor(T,i=sumT,G,j=sumT)
        RF <- mul.tensor(R,i=sumR,F,j=sumR)
        res <- ( norm(A - SRUT)^2
                 + l1/2 * norm(X - TG)^2
                 + l2/2 * norm(Y - RF)^2
                 + l3/2 * (norm(S)^2
                         + norm(R)^2
                         + norm(U)^2
                         + norm(T)^2
                         + norm(F)^2
                         + norm(G)^2
                 )
        )
        res
    }
    objectiveFunction
}
