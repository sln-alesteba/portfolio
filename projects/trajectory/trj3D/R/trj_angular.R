trjArg <- function(z) {

  ifelse(Mod(z) == 0,
         NA,
         Arg(z))
}

coordsToSphere <- function (v_x,v_y,v_z){

  r <- sqrt(v_x^2+v_y^2+v_z^2)
  TAN_1 <- (v_z)/(v_x)
  TAN_2 <- (v_y)/(v_x^2+v_z^2)

  ψ <- atan2(v_z, v_x)
  θ <- atan2(v_y, sqrt(v_x^2+v_z^2))

  return( c( 'r' = r, 'θ' = θ, 'ψ' = ψ) )
}

angles_3D2 <- function(trj, lag = 1, compass.direction = NULL) {

  angles <- c()

  for (i in lag:nrow(trj) ) {

    # define function for it:

    q <- quaternion(c(trj$q1[[i]], trj$q2[[i]], trj$q3[[i]], trj$q4[[i]] ) )

    y <- NULL

    if (is.null(compass.direction)) {

      # Already mult *-1 to calculate the angular difference;
      # pre-computed into the df;

      # y <- quaternion( eulerzyx(0,0,0) )
      y <- quaternion (c(0,0,0,1))
    }
    else{

      # to spherical data:
      sph <- coordsToSphere(compass.direction['x'][[1]],
                            compass.direction['y'][[1]],
                            compass.direction['z'][[1]])

      # quaternion from data
      y <- quaternion( eulerzyx(
                                sph['r'][[1]],
                                sph['θ'][[1]],
                                sph['ψ'][[1]]) )
    }

    angles <- append( angles, rotation.distance(q,y) )
  }

  # Normalise so that -pi < angle <= pi

  ii <- which(angles <= -pi)
  angles[ii] <- angles[ii] + 2 * pi
  ii <- which(angles > pi)
  angles[ii] <- angles[ii] - 2 * pi

  return(angles)
}

directionalAutocorrelations <- function(trj, deltaSMax = round(nrow(trj) / 4)) {

  deltaSs <- 1:round(deltaSMax)

  # Calculates autocorrelation for a single delta s

  .deltaCorr <- function(deltaS, trj) {

    # Calculate difference in angle for every pair of segments which are deltaS apart,

    c <- sapply(deltaSs, function(offset) {

      t <- trj[offset : nrow(trj),]

      return(cos(
        trj3D::angles_3D2(t, deltaS)))

    })

    # Zero-length segments have angle NA, so ignore them

    return ( mean(unlist(c), na.rm = TRUE) )
  }

  return(data.frame(deltaS = deltaSs, C = sapply(deltaSs, .deltaCorr, trj)))
}

meanTurningAngles <- function(trj, compass.direction = NULL) {

  angles <- trj3D::angles_3D2(trj, compass.direction = compass.direction)

  return( mean(angles, na.rm = TRUE) )
}

directionalChange <- function(trj, nFrames = 1) {

  return(

    abs(rad2deg(trj3D::angles_3D2(trj, lag=nFrames))) / diff(trj$time, 2 * nFrames)
  )
}

sinuosity <- function(trj, compass.direction = NULL) {

  segLen <- mean( trj3D::stepLengths(trj))

  return (

    1.18 * stats::sd(

      trj3D::angles_3D2(trj, compass.direction = compass.direction),
      na.rm = TRUE
    ) / sqrt(segLen)
  )
}

emax <- function(trj, eMaxB = FALSE, compass.direction = NULL) {

  # E(cos(angles)) = mean(cos(angles))
  b <- mean(cos(trj3D::angles_3D2(trj, compass.direction = compass.direction)), na.rm = TRUE)

  # If it's E max b, multiply by mean step length
  f <- ifelse(eMaxB, mean(trj3D::stepLengths(trj)), 1)

  return(f * b / (1 - b))
}
