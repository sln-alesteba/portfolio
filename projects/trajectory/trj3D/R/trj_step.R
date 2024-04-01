normalize <- function(x) {x / sqrt(sum(x^2))}

euc.dist <- function(x1, x2) { sqrt(sum((x1 - x2) ^ 2)) }

euc.angle <- function(a, b) { acos( sum(a*b) / ( sqrt(sum(a * a)) * sqrt(sum(b * b)) ) )  }

rad2deg <- function(rad) { rad * 180 / pi}

deg2rad <- function(deg) { deg * pi / 180}
