library(rEDM)
raw_time <- read.table("ts_lf_0072.txt", header=F)[261:501,1]
raw_time_series <- read.table("ts_lf_0072.txt", header=F)[261:501,2]

#x_trend <- 0.3
#x_bif <- 0.49

#seg1 <- 0.38995
#seg2 <- 0.41495
#seg3 <- 0.43995
#seg4 <- 0.46495

E <- 2
E2 <- E+2
tau <- 2
theta <- seq(0,2.5,by=0.5)
window_size <- 50
step_size <- 1

### start algorithm
window_indices <- seq(window_size, NROW(raw_time_series), step_size)
matrix_result <- matrix(NaN, nrow = length(window_indices), ncol = 4)
index <- 0

for(j in window_indices)
{
    index <- index + 1
    rolling_window <- raw_time_series[(j-window_size+1):j]
    
    norm_rolling_window <- (rolling_window - mean(rolling_window, na.rm=TRUE))/sd(rolling_window, na.rm=TRUE)
    
    # calculate best theta
    smap <- s_map(norm_rolling_window, E=E, tau=tau, theta=theta, silent=TRUE)
    best <- order(-as.vector(unlist(smap$rho)))[1]
    theta_best <- smap[best,]$theta
    
    # calculate eigenvalues for best theta
    smap <- s_map(norm_rolling_window, E=E, tau=tau, theta=theta_best, silent=TRUE, save_smap_coefficients=TRUE)
    
    #smap_co <- smap[[1]]$smap_coefficients # In earlier versions of rEDM package
    smap_co <- smap$smap_coefficients[[1]]

    matrix_eigen <- matrix(NA, nrow = NROW(smap_co), ncol = 3)
    
    for(k in 2:NROW(smap_co))
    {
        if(!is.na(smap_co[k,1]))
        {
            M <- rbind(as.numeric(smap_co[k, 3:E2]), cbind(diag(E - 1), rep(0, E - 1)))
            M_eigen <- eigen(M)$values
            lambda1 <- M_eigen[order(abs(M_eigen))[E]]
            
            matrix_eigen[k,1] <- abs(lambda1)
            matrix_eigen[k,2] <- Re(lambda1)
            matrix_eigen[k,3] <- Im(lambda1)
        }
    }
    
    # save results
    matrix_result[index,1] <- j
    matrix_result[index,2] <- mean(matrix_eigen[,1],na.rm=TRUE)
    matrix_result[index,3] <- mean(matrix_eigen[,2],na.rm=TRUE)
    matrix_result[index,4] <- mean(matrix_eigen[,3],na.rm=TRUE)
}

result <- matrix_result


par(mar=c(4.1,5,2,4)+0.1)

plot(0,0, col="white", ylim=c(0, 1.5), xlim=c(0, 500), las=0, cex.axis=1.65, cex.lab=1.75, main="", xlab="", ylab="| DEV |")

points(c(0,500), c(1,1), col="gray", type="l", lwd=3, lty=2)

mat = cbind(result[1:192,1], result[1:192,2], 1:192)
n = 255
data_seq = seq(min(mat[,3]), max(mat[,3]), length=n)
col_pal = colorRampPalette(c('tomato','red'))(n+1)
cols = col_pal[ cut(mat[,3], data_seq, include.lowest=T) ]

points(result[1:192,1], result[1:192,2], lty=1, lwd=5, type="p", cex=0.5, pch=20, col=cols)

write.table(result, "C:/Users/Administrator/Desktop/dev_lf_0072.txt", append = FALSE, sep = " ", dec = ".",
            row.names = FALSE, col.names = FALSE)

par(mar=c(4.1,5,2,6)+0.1)
f <- function(x) exp(-(0+1i)*x)
x <- seq(0, 2*pi, by=0.01)

plot(f(x), type="l", cex.lab=1.75, cex.axis=1.65, xlab="", ylab="", yaxt="n")

re_hen <- result[,3]
im_hen <- result[,4]
mat = cbind(re_hen, im_hen, 1:length(re_hen))
n = 255
data_seq = seq(min(mat[,3]), max(mat[,3]), length=n)
col_pal = colorRampPalette(c('tomato','red'))(n+1)
cols = col_pal[ cut(mat[,3], data_seq, include.lowest=T) ]

points(re_hen, im_hen, lty=1, lwd=5, type="p", cex=0.5, pch=20, col=cols)

write.table(mat, "C:/Users/Administrator/Desktop/class_lf_0072.txt", append = FALSE, sep = " ", dec = ".",
            row.names = FALSE, col.names = FALSE)