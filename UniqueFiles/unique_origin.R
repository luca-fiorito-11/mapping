source("global.R")

# CREATE DATAFRAME FOR FILES WITH UNIQUE ORIGINS
df <- subset(df, MFMT!=1451) # Remove rows with MF1/MT451
df_unique <- group_by(df, MAT, LIBVER) %>% 
  summarize(NDIFF=n_distinct(LIBVERORIG)) %>% # Create column NDIFF with number of different LIBVERORIG for a given MAT ...
  subset(NDIFF==1) %>% # ...then filter and keep only mats with NDIFF = 1
  merge(df) # merge again with df to have again the other columns: LIB, VER, MF, MT, ...
UNIQUES <- unique(df_unique[,c("MAT", "LIBVER", "LIBVERORIG")]) %>% # Keep only unique combinations MAT-LIBVER-LIBVERORIG
  merge(mats, by = "MAT") # Merge with mats df to get again columns Z, X, A, and M

