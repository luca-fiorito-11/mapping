# call to global.R in shiny app in order to always have consistent data 

setwd('../Rapp/')

source("global.R")

myparams<-strsplit(params$SYMAMLIBVER, "-")[[1]]
mX<-myparams[1]
mA<-myparams[2]
mM<-myparams[3]
mLIB<-myparams[4]
mVER<-myparams[5]

mSYMAM<-paste(mX,"-", mA,"-",mM, sep ="")
mLIBVER<-paste(mLIB,"-",mVER, sep = "")

output_dir<-paste(mLIB,mVER, sep = "")
output_file<-paste(mX,mA,mM)

pdf<-df%>%subset(X==mX & A==mA & M==mM & LIBVER==mLIBVER)
tot<-dim(pdf)[1]

# preparing datatables
pdfo<-df%>%subset(X==mX & A==mA & M==mM)
lib2<-pdfo%>%subset(LIBVER==params$LIBVER2, 
                    select = c('MFMT', 'MF', 'MFDES', 'MT', "MTDES", 'LIBVER', 'LIBVERORIG'))
lib1<-pdfo%>%subset(LIBVER==mLIBVER,
                    select = c('MFMT', 'MF', 'MFDES', 'MT', "MTDES", 'LIBVER', 'LIBVERORIG'))
comp<-merge(lib1, lib2, by = c('MFMT', 'MF', 'MFDES', 'MT', "MTDES"), all=TRUE)
data.table::setnames(comp, old=c("LIBVERORIG.x","LIBVERORIG.y"), new=c("LIB1","LIB2"))
data.table::setnames(comp, old=c("MFDES","MTDES"), new=c("MF TYPE","MT TYPE"))
comp<-subset(comp, select = c('MF TYPE', 'MT TYPE', 'MF', 'MT', 'LIB1', 'LIB2'))

#counting : 
totalupdated<-dim(comp%>%subset(LIB1!=LIB2 | is.na(LIB1) | is.na(LIB2)))[1]
newinlib1<-dim(comp%>%subset(is.na(LIB2)))[1]
erasedfromlib2<-dim(comp%>%subset(is.na(LIB1)))[1]

comp[is.na(comp)] <- 'NA'

UpdatedColor <-"Gray"
NewColor <-"Gray"
ErasedColor <-"Gray"
if(totalupdated > 0) UpdatedColor <- "#b3ffb3"
if(newinlib1 > 0) NewColor <- "#b3ffb3"
if(erasedfromlib2> 0) ErasedColor <- "#ffb3b3"

LIBLINK <-"https://www.oecd-nea.org/dbdata"

