
pointAt <- function(trj, distance,
                     curr_dist = 0, last_seg = 1,
                     last_delta = c(x = trj$x[1],
                                    y = trj$y[1],
                                    z = trj$z[1]))
{

  curr_dist <- curr_dist

  last_delta <- c(

    x = last_delta['x'][[1]],
    y = last_delta['y'][[1]],
    z = last_delta['z'][[1]]
  )

  end_index =length(trj$x) - 1

  for (i in last_seg:end_index)
  {
    pt1 <- c(x = trj$x[i],    y = trj$y[i]   , z = trj$z[i])
    pt2 <- c(x = trj$x[i+1],  y = trj$y[i+1] , z = trj$z[i+1])

    step_dir <- normalize(pt2 - pt1)

    dist_toEnd = euc.dist(last_delta, pt2)

    if (curr_dist + dist_toEnd <= distance)
    {
      curr_dist <- curr_dist + dist_toEnd

      last_delta <- pt2
    }
    else
    {
      delta <- last_delta + step_dir * (distance - curr_dist)

      return (c('delta' = delta, 'last_segt' = i))
    }
  }

  return (NULL)
}

resample <- function(trj, stepLength = 1)
{
  pts <- data.frame()

  currDist <- 0
  lastSeg <- 1
  resample <- c(x = trj$x[1], y = trj$y[1], z = trj$z[1])

  # include first point
  pts <- rbind(pts, as.data.frame(t(resample)))

  while(TRUE)
  {
    newDist <- (currDist + stepLength)

    res <- pointAt(trj,
                   distance = newDist,

                   curr_dist = currDist,
                   last_seg = lastSeg,
                   last_delta = resample)

    if (is.null(res)) {break}

    else
    {
      resample <- c ( x = res['delta.x'][[1]],
                      y = res['delta.y'][[1]],
                      z = res['delta.z'][[1]]  )
      currDist <- newDist
      lastSeg <- res['last_segt'][[1]]

      pts <- rbind(pts, as.data.frame(t(resample)))
    }
  }

  return(fromCoords(pts))
}
