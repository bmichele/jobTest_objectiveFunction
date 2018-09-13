# Load tensorA package and defined function
library(tensorA)
source("./buildObjectiveFunction.R")

# Here I play with the function to see if it is doing what I expect

#----------------------------------#
# I test using the following data: #
#----------------------------------#

# Index ranges (integers)
#------------------------

N <- 30L # number of road segments
M <- 40L # number of users
L <- 50L # number of time slots
P <- 25L # number of grids defining the coarse-grain traffic
Q <- 35L # number of features for road segments

# Tensors/matrices
#-----------------
# A dim NxMx2L, tensor
# X dim 2LxP, context matrix 
# Y dim NxQ, context matrix

set.seed(1)

# Tensors defined now by random entries
# In real application, replace by data
elA <- rnorm( N*M*2*L )
myA <- to.tensor( elA , c( dimN = N, dimM = M, dimL = 2*L ) )

elX <- rnorm( 2*L*P )
myX <- to.tensor( elX , c( dimL = 2*L, dimP = P ) )

elY <- rnorm( N*Q )
myY <- to.tensor( elY , c( dimN = N, dimQ = Q ) )

# Dimensions of the components of A (integers)
#---------------------------------------------

dR <- 5L
dU <- 6L
dT <- 7L

# Input tensors/matrices of the objective function
# S dim dRxdUxdT
# R dim NxdR
# U dim MxdU
# T dim 2LxdT
# F dim dRxQ
# G dim dTxP

# Tensors defined now by random entries
# In real application, replace by values used in first iteration of optimization
# algorithm
elS <- rnorm( dR*dU*dT )
elR <- rnorm( N*dR )
elU <- rnorm( M*dU )
elT <- rnorm( 2*L*dT )
elF <- rnorm( dR*Q )
elG <- rnorm( dT*P )

myS <- to.tensor( elS , c( dimdR = dR, dimdU = dU, dimdT = dT ) )
myR <- to.tensor( elR , c( dimN = N, dimdR = dR ) )
myU <- to.tensor( elU , c( dimM = M, dimdU = dU ) )
myT <- to.tensor( elT , c( dimL = 2*L, dimdT = dT ) )
myF <- to.tensor( elF , c( dimdR = dR, dimQ = Q ) )
myG <- to.tensor( elG , c( dimdT = dT, dimP = P ) )

#-------------------------#
# How to use the function #
#-------------------------#

# create the objective function L specifying:
# the tensor A to be used
# the matrices X, Y to be used
# the control parameters lambda1, lambda2, lambda3

myObjFunc <- buildObjectiveFunction(myA, myX, myY, 0.05, 0.05, 0.05)

# in each step of the optimization problem, the objective function can be
# computed as follows, giving as input the matrices S, R, U, T, F, G and the
# name of the indices shared by
# S and R
# S and U
# S and T

res <- myObjFunc( myS, myR, myU, myT, myF, myG, "dimdR", "dimdU", "dimdT" )
