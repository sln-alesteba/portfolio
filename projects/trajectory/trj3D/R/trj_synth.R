# complex number version;

generate_2D <- function(

  n = 1000,
  step_length = 2,

  angular_errorSd = 0.5, # can change it when passing function;
  angular_errorDist = function(n) stats::rnorm(n, sd = angular_errorSd),

  linear_errorSd = 0.25,
  linear_errorDist = function(n) stats::rnorm(n, sd = linear_errorSd)

) {

  angular_errors <- angular_errorDist(n)
  linear_errors <- linear_errorDist(n)

  coords  <- complex(n + 1)
  angle   <- 0

  for (i in 1:n) {

    angle <- angle + angular_errors[i]
    length <- step_length + linear_errors[i]
    coords[i + 1] <- coords[i] + complex(modulus = length, argument = angle)

  }

  traj <- data.frame(x=Re(coords), y=Im(coords))

  return(fromCoords(traj)) }

# roll, pitch, yaw -> quaternion version;

generate_3D <- function(

  n = 1000,
  step_length = 2,

  angular_errorSd = 0.5,
  angular_errorDist = function(n) stats::rnorm(n, sd = angular_errorSd),

  linear_errorSd = 0.25,
  linear_errorDist = function(n) stats::rnorm(n, sd = linear_errorSd)

) {

  angular_roll  <- angular_errorDist(n)
  angular_pitch <- angular_errorDist(n)
  angular_yaw   <- angular_errorDist(n)

  angle_roll    <- 0
  angle_pitch   <- 0
  angle_yaw     <- 0

  linear_errors <- linear_errorDist(n)

  coords <- data.frame()

  coords <- rbind(coords, as.data.frame(t(c(x=0, y=0, z=0))))

  for (i in 1:n) {

    angle_roll  <- angle_roll + angular_roll[i]
    angle_pitch <- angle_pitch + angular_pitch[i]
    angle_yaw   <- angle_yaw + angular_yaw[i]

    q <- quaternion( eulerzyx(angle_roll, angle_pitch, angle_yaw) )

    # direction vector:

    up  <- c(0,1,0)
    dir <- rotmatrix(q)[[1]] %*% matrix(up)

    # append vector3:

    last_coord <- as.numeric(tail(coords, n=1))

    p <- last_coord + dir * (step_length + linear_errors[i])

    coords <- rbind(coords, as.data.frame(t(c(x=p[1], y=p[2], z=p[3] ))) )
  }

  #print(coords)

  return(fromCoords(coords))

}

