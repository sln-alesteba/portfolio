
.fillInTime <- function(trj, fps)
{
  trj$time <- (seq_len(nrow(trj)) - 1) / fps

  trj$time_d <- c(0, diff(trj$time))

  return(trj)
}

.fillInSpherical <- function(trj) {

  roll <- c()
  pitch <- c()
  yaw <- c()

  for (i in 1:nrow(trj)){

    res <- coordsToSphere(trj$x[[i]], trj$y[[i]], trj$z[[i]])

    roll <-append(roll, res['r'][[1]] )
    pitch <-append(pitch, res['θ'][[1]] )
    yaw <-append(yaw, res['ψ'][[1]] )

  }

  trj$roll <-roll
  trj$pitch <-pitch
  trj$yaw <-yaw

  return(trj)
}

.fillInDisplacement <- function(trj)
{
  dis <- c(0)

  for (i in 2:nrow(trj)){

    resA <- c(trj$x[[i]]  , trj$y[[i]]  , trj$z[[i]])
    resB <- c(trj$x[[i-1]], trj$y[[i-1]], trj$z[[i-1]])

    dis<-append( dis, euc.dist(resA, resB) )

  }

  trj$displacement <- dis

  return(trj)

}


# different ways to append data:

.fillInQuaternion <- function(trj) {

  q11 <- c(0)
  q22 <- c(0)
  q33 <- c(0)
  q44 <- c(0)

  # https://forum.unity.com/threads/get-the-difference-between-two-quaternions-and-add-it-to-another-quaternion.513187/

  for (i in 2:nrow(trj)){

    resA <- coordsToSphere(trj$x[[i]]  , trj$y[[i]]  , trj$z[[i]])
    resB <- coordsToSphere(trj$x[[i-1]], trj$y[[i-1]], trj$z[[i-1]])

    x <- quaternion( eulerzyx(resA['r'][[1]],resA['θ'][[1]],resA['ψ'][[1]]) )
    y <- quaternion( eulerzyx(resB['r'][[1]],resB['θ'][[1]],resB['ψ'][[1]]) )
    #  trj$displacement_3D <- c(trj$displacement_3D, rotation.distance(x,y) )

    displacement_3D <- quaternion( ( x %*% orientlib::t(y) ) )
    displacement_3D <- displacement_3D[[1]]

    q11<-append( q11, displacement_3D['q1'][[1]] )
    q22<-append( q22, displacement_3D['q2'][[1]] )
    q33<-append( q33, displacement_3D['q3'][[1]] )
    q44<-append( q44, displacement_3D['q4'][[1]] )
  }

  trj$q1 <- q11
  trj$q2 <- q22
  trj$q3 <- q33
  trj$q4 <- q44

  return(trj)

}

# just for two dimensional coordinates;

.fillInCoords <- function(trj, dim = c("2D", "3D")) {

  trj$polar <- complex(real = trj$x, imaginary = trj$y)

  trj$displacement <- c(0)

  if (nrow(trj) > 0){
    trj$displacement <- c(0, diff(trj$polar))
  }else{
    trj$displacement <- numeric()
  }

  return(trj)
}

# https://mathinsight.org/spherical_coordinates

fromCoords <- function(track,
                       timeCol = NULL, fps = 50,
                       spatialUnits = "m", timeUnits = "s") {
  trj <- track

  if (is.null(trj$z)) {
    trj$z <- rep(0, nrow(trj))
  }

  # trj <- .fillInCoords(trj)

  trj <- .fillInDisplacement(trj)

  trj <- .fillInSpherical(trj)

  trj <- .fillInQuaternion(trj)

  trj <- .fillInTime(trj, fps)

  return(trj)
}

TrajFromTrjPoints <- function(trj, idx) {

  TrajFromCoords(trj[idx, ],
                 xCol = "x", yCol = "y", timeCol = "time",
                 fps = TrajGetFPS(trj),
                 spatialUnits = TrajGetUnits(trj),
                 timeUnits = TrajGetTimeUnits(trj))

}
