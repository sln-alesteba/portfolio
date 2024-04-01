timeDisplacement <- function(trj,
                             startIndex = 1,
                             endIndex = nrow(trj)) {
  diff(trj$time[c(startIndex, endIndex)])

}

speed <- function(trj) {

  d <- trj$displacement
  t <- trj$time

  v  <- d[2:length(d)] / diff(t)
  vt <- t[2:length(t)]

  list(speed = v, speedTimes = vt)
}

acceleration <- function(trj) {

  s <- speed(trj)

  v  <- s$speed
  vt <- s$speedTimes

  a  <- diff(v) / diff(vt)
  at <- vt[2:length(vt)]

  list(acceleration = a, accelerationTimes = at)
}
