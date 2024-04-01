

stepLengths <- function(trj, startIndex = 2, endIndex = length(trj$x)) {

  sum = 0

  for (t in startIndex:endIndex) {

    pt1 <- c(x = trj$x[t],  y = trj$y[t], z = trj$z[t] )

    pt2 <- c(x = trj$x[t-1], y = trj$y[t-1], z = trj$z[t-1])

    sum <- sum + euc.dist (pt1 , pt2)
  }

  return(sum)

}

straightness <- function(trj) {

  return( length(trj) / stepLengths(trj) )
}




