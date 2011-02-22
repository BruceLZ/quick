! Ed Brothers. November 27, 2001
! Xiao HE. September 14,2008
! 3456789012345678901234567890123456789012345678901234567890123456789012<<STOP

    subroutine calmp2divcon
    use allmod
    use quick_gaussian_class_module
    implicit double precision(a-h,o-z)
    include 'divcon.h'

    logical locallog1,locallog2

    real*8 Xiaotest,testtmp
 integer II,JJ,KK,LL,NBI1,NBI2,NBJ1,NBJ2,NBK1,NBK2,NBL1,NBL2
 common /hrrstore/II,JJ,KK,LL,NBI1,NBI2,NBJ1,NBJ2,NBK1,NBK2,NBL1,NBL2

 is = 0
 ishellfirst(1) = 1
 do ii=1,natom-1
      is=is+kshell(iattype(ii))
      ishelllast(ii)=is
      ishellfirst(ii+1) = is+1
 enddo
 ishelllast(natom) = nshell

 do ii=1,natom
   print*,"nshell=",ii,ishellfirst(ii),ishelllast(ii)
   print*,"nbasis=",ii,ifirst(ii),ilast(ii)
 enddo

 allocate(wtospoint(np,nbasis))
 call wtoscorr

 xiaocutoffmp2=1.0d-7

 emp2=0.0d0
 emp2temp=0.0d0


do itt=1,np

 Do i=1,nbasisdc(itt)
  Do j=1,nbasisdc(itt)
    CO(i,j)=COdcsub(i,j,itt)
  ENDDO
 ENDDO 

 Do i=1,nbasisdc(itt)
  Do j=1,nbasisdc(itt)
    HOLD(i,j)=CO(j,i)
  ENDDO
 ENDDO

 ttt=0.0d0

 do iiat=1,dcsubn(itt)
  iiatom=dcsub(itt,iiat)
  do II=ishellfirst(iiatom),ishelllast(iiatom)
    do jjat=iiat,dcsubn(itt)
     jjatom=dcsub(itt,jjat)
      do JJ=max(ishellfirst(jjatom),II),ishelllast(jjatom)
!  Do II=1,jshell
!   do JJ=II,jshell
     Testtmp=Ycutoff(II,JJ)
     ttt=max(ttt,Testtmp)
     enddo
    enddo
   enddo
 Enddo


 if(mod(nelecmp2sub(itt),2).eq.1)then
  nelecmp2sub(itt)=nelecmp2sub(itt)+1
 endif

 if(mod(nelecmp2sub(itt),2).eq.1)then
   iocc=Nelecmp2sub(itt)/2+1
   ivir=nbasisdc(itt)-iocc+1
 else
   iocc=Nelecmp2sub(itt)/2
   ivir=nbasisdc(itt)-iocc
 endif

! ivir=nbasisdc(itt)-iocc

 allocate(mp2shell(nbasisdc(itt)))
 allocate(orbmp2(iocc,ivir,ivir))
 allocate(orbmp2dcsub(iocc,ivir,ivir))
 if(ffunxiao)then
  nbasistemp=6
  allocate(orbmp2i331(nbasisdc(itt),6,6,2))
  allocate(orbmp2j331(ivir,6,6,2))
 else
  nbasistemp=10
  allocate(orbmp2i331(nbasisdc(itt),10,10,2))
  allocate(orbmp2j331(ivir,10,10,2))
 endif

 allocate(orbmp2k331(iocc,ivir,nbasisdc(itt)))
 allocate(orbmp2k331dcsub(iocc,ivir,nbasisdc(itt)))

! print*,"iocc=",iocc,"ivir=",ivir

 Nxiao1=0
 Nxiao2=0

! Schwartz cutoff is implemented here. (ab|cd)**2<=(ab|ab)*(cd|cd)
! Reference: Strout DL and Scuseria JCP 102(1995),8448.

! print*,"before 2e"

! do jmax=1,nbasis-nelec/2
!tttmax=0.0d0
!do imax=1,nbasis
!  tttmax=max(tttmax,dabs(co(imax,jmax)))
! enddo
!print*,jmax,tttmax
!enddo
!stop

DO i3=1,iocc

     do l1=1,ivir
    do k1=1,ivir
   do j1=1,iocc
       orbmp2(j1,k1,l1)=0.0d0
     enddo
    enddo
   enddo

  do j1=1,nbasisdc(itt)
   do k1=1,ivir
 do i1=1,iocc
    orbmp2k331(i1,k1,j1)=0.0d0
   enddo
  enddo
 enddo

     do l1=1,ivir
    do k1=1,ivir
   do j1=1,iocc
       orbmp2dcsub(j1,k1,l1)=0.0d0
     enddo
    enddo
   enddo

  do j1=1,nbasisdc(itt)
   do k1=1,ivir
 do i1=1,iocc
    orbmp2k331dcsub(i1,k1,j1)=0.0d0
   enddo
  enddo
 enddo

ntemp=0

! Do II=1,jshell
!   do JJ=II,jshell
 do iiat=1,dcsubn(itt)
  iiatom=dcsub(itt,iiat)
  do II=ishellfirst(iiatom),ishelllast(iiatom)
    do jjat=iiat,dcsubn(itt)
     jjatom=dcsub(itt,jjat)
      do JJ=max(ishellfirst(jjatom),II),ishelllast(jjatom)

     Testtmp=Ycutoff(II,JJ)
!     ttt=max(ttt,Testtmp)
    if(Testtmp.gt.XiaoCUTOFFmp2/ttt)then

    do l1=1,2
  do j1=1,nbasistemp
 do i1=1,nbasistemp
   do k1=1,nbasisdc(itt)
    orbmp2i331(k1,i1,j1,l1)=0.0d0
   enddo
  enddo
 enddo
 enddo

    do l1=1,2
  do j1=1,nbasistemp
 do i1=1,nbasistemp
   do k1=1,ivir
    orbmp2j331(k1,i1,j1,l1)=0.0d0
   enddo
  enddo
 enddo
 enddo

!  do i1=1,nbasis
!    mp2shell(i1)=.false.
!  enddo

!     do KK=II,jshell
!       do LL=KK,jshell

 do kkat=1,dcsubn(itt)
  kkatom=dcsub(itt,kkat)
  do KK=ishellfirst(kkatom),ishelllast(kkatom)
    do LLat=kkat,dcsubn(itt)
     LLatom=dcsub(itt,LLat)
      do LL=max(ishellfirst(LLatom),KK),ishelllast(LLatom)

!     do KK=1,jshell
!       do LL=KK,jshell

            comax=0.d0
            XiaoTEST1 = TESTtmp*Ycutoff(KK,LL)
          If(XiaoTEST1.gt.XiaoCUTOFFmp2)then

 NKK1=Qstart(KK)
 NKK2=Qfinal(KK)
 NLL1=Qstart(LL)
 NLL2=Qfinal(LL)

   NBK1=Qsbasis(KK,NKK1)
   NBK2=Qfbasis(KK,NKK2)
   NBL1=Qsbasis(LL,NLL1)
   NBL2=Qfbasis(LL,NLL2)

   KK111=Ksumtype(KK)+NBK1
   KK112=Ksumtype(KK)+NBK2
   LL111=Ksumtype(LL)+NBL1
   LL112=Ksumtype(LL)+NBL2

       Do KKK=KK111,KK112
          Do LLL=max(KKK,LL111),LL112

!            print*,co(kkk,i3),co(lll,i3)
            comax=max(comax,dabs(co(wtospoint(itt,kkk),i3)))
            comax=max(comax,dabs(co(wtospoint(itt,lll),i3)))    
       
          Enddo
       Enddo        

            Xiaotest=xiaotest1*comax
!            DNmax=max(4.0d0*cutmatrix(II,JJ),4.0d0*cutmatrix(KK,LL), &
!                  cutmatrix(II,LL),cutmatrix(II,KK),cutmatrix(JJ,KK),cutmatrix(JJ,LL))
!            XiaoTest=Xiaotest1*DNmax
            If(XiaoTEST.gt.XiaoCUTOFFmp2)then
              ntemp=ntemp+1
              call shellmp2divcon(i3,itt)
            Endif

           endif

       enddo
     enddo

    ENDDO
   ENDDO


 NII1=Qstart(II)
 NII2=Qfinal(II)
 NJJ1=Qstart(JJ)
 NJJ2=Qfinal(JJ)

   NBI1=Qsbasis(II,NII1)
   NBI2=Qfbasis(II,NII2)
   NBJ1=Qsbasis(JJ,NJJ1)
   NBJ2=Qfbasis(JJ,NJJ2)

   II111=Ksumtype(II)+NBI1
   II112=Ksumtype(II)+NBI2
   JJ111=Ksumtype(JJ)+NBJ1
   JJ112=Ksumtype(JJ)+NBJ2

       Do III=II111,II112
          Do JJJ=max(III,JJ111),JJ112

          IIInew=III-II111+1
          JJJnew=JJJ-JJ111+1

     do LLL=1,nbasisdc(itt)
!    if(mp2shell(LLL).eq..true.)then
   do j33=1,ivir
     j33new=j33+iocc
if(mod(nelecmp2sub(itt),2).eq.1)j33new=j33+iocc-1
       atemp=CO(LLL,j33new)
       orbmp2j331(j33,IIInew,JJJnew,1)=orbmp2j331(j33,IIInew,JJJnew,1) + &
                                     orbmp2i331(LLL,IIInew,JJJnew,1)*atemp
       if(III.ne.JJJ)then
        orbmp2j331(j33,JJJnew,IIInew,2)=orbmp2j331(j33,JJJnew,IIInew,2) + &
                                      orbmp2i331(LLL,JJJnew,IIInew,2)*atemp
       endif
     enddo
!    endif
   enddo

   do j33=1,ivir
     do k33=i3,iocc
       orbmp2k331(k33,j33,wtospoint(itt,JJJ))=orbmp2k331(k33,j33,wtospoint(itt,JJJ))+ &
                               orbmp2j331(j33,IIInew,JJJnew,1)*HOLD(k33,wtospoint(itt,III))
       if(III.ne.JJJ)then
        orbmp2k331(k33,j33,wtospoint(itt,III))=orbmp2k331(k33,j33,wtospoint(itt,III))+ &
                                orbmp2j331(j33,JJJnew,IIInew,2)*HOLD(k33,wtospoint(itt,JJJ))
       endif
!       print*,orbmp2j331(III,JJJ,j33),orbmp2k331(k33,JJJ,j33)
     enddo
   enddo

 locallog1=.false.
 locallog2=.false.

 do iiatdc=1,dccoren(itt)
  iiatomdc=dccore(itt,iiatdc)
  do IInbasisdc=ifirst(iiatomdc),ilast(iiatomdc)
   if(III.eq.IInbasisdc)locallog1=.true.
   if(JJJ.eq.IInbasisdc)locallog2=.true.
  enddo
 enddo

 if(locallog1)then
   do j33=1,ivir
     do k33=i3,iocc
       orbmp2k331dcsub(k33,j33,wtospoint(itt,JJJ))=orbmp2k331dcsub(k33,j33,wtospoint(itt,JJJ))+ &
                               orbmp2j331(j33,IIInew,JJJnew,1)*HOLD(k33,wtospoint(itt,III))
     enddo
   enddo
 endif

 if(locallog2.and.III.ne.JJJ)then
   do j33=1,ivir
     do k33=i3,iocc
        orbmp2k331dcsub(k33,j33,wtospoint(itt,III))=orbmp2k331dcsub(k33,j33,wtospoint(itt,III))+ &
                                orbmp2j331(j33,JJJnew,IIInew,2)*HOLD(k33,wtospoint(itt,JJJ))
     enddo
   enddo
 endif

           Enddo
       Enddo

   endif

   enddo
 enddo

 ENDDO
ENDDO

  write (ioutfile,*)"ntemp=",ntemp

                   Do LLL=1,nbasisdc(itt)
                  Do J3=1,ivir
                Do L3=1,ivir
                   L3new=L3+iocc
if(mod(nelecmp2sub(itt),2).eq.1)L3new=L3+iocc-1
                 Do k3=i3,iocc
                    orbmp2(k3,l3,j3)=orbmp2(k3,l3,j3)+orbmp2k331(k3,j3,LLL)*HOLD(L3new,LLL)
!                    print*,orbmp2(k3,l3,i3,j3),orbmp2k331(k3,JJJ,j33)
                    orbmp2dcsub(k3,l3,j3)=orbmp2dcsub(k3,l3,j3)+ &
                                          orbmp2k331dcsub(k3,j3,LLL)*HOLD(L3new,LLL)
                   Enddo
                  Enddo
                 Enddo
                Enddo

if(mod(nelecmp2sub(itt),2).eq.0)then
              do l=1,ivir
            do k=i3,iocc
          do j=1,ivir
               if(k.gt.i3)then
                emp2=emp2+2.0d0/(Evaldcsub(itt,i3)+Evaldcsub(itt,k) &
                    -Evaldcsub(itt,j+nelecmp2sub(itt)/2)-Evaldcsub(itt,l+nelecmp2sub(itt)/2)) &
       *orbmp2dcsub(k,j,l)*(2.0d0*orbmp2(k,j,l)-orbmp2(k,l,j))
               endif
               if(k.eq.i3)then
                emp2=emp2+1.0d0/(Evaldcsub(itt,i3)+Evaldcsub(itt,k) &
                    -Evaldcsub(itt,j+nelecmp2sub(itt)/2)-Evaldcsub(itt,l+nelecmp2sub(itt)/2)) &
       *orbmp2dcsub(k,j,l)*(2.0d0*orbmp2(k,j,l)-orbmp2(k,l,j))
               endif
                enddo
          enddo
      enddo
endif

if(mod(nelecmp2sub(itt),2).eq.1)then
              do l=1,ivir
            do k=i3,iocc
          do j=1,ivir
               if(k.gt.i3)then
                emp2=emp2+2.0d0/(Evaldcsub(itt,i3)+Evaldcsub(itt,k) &
                    -Evaldcsub(itt,j+nelecmp2sub(itt)/2)-Evaldcsub(itt,l+nelecmp2sub(itt)/2)) &
       *orbmp2dcsub(k,j,l)*(2.0d0*orbmp2(k,j,l)-orbmp2(k,l,j))
               endif
               if(k.eq.i3)then
                emp2=emp2+1.0d0/(Evaldcsub(itt,i3)+Evaldcsub(itt,k) &
                    -Evaldcsub(itt,j+nelecmp2sub(itt)/2)-Evaldcsub(itt,l+nelecmp2sub(itt)/2)) &
       *orbmp2dcsub(k,j,l)*(2.0d0*orbmp2(k,j,l)-orbmp2(k,l,j))
               endif
                enddo
          enddo
      enddo
endif


 ENDDO

 write(ioutfile,*)emp2,emp2-emp2temp

 emp2temp=emp2

 deallocate(mp2shell)
 deallocate(orbmp2)
  deallocate(orbmp2i331)
  deallocate(orbmp2j331)
 deallocate(orbmp2k331)
 deallocate(orbmp2dcsub)
 deallocate(orbmp2k331dcsub)

enddo

! print*,'Nxiao1=',Nxiao1,'Nxiao2=',Nxiao2,XiaoCUTOFF

!     do i=1,nbasis
!       print*,i,E(i)
!     enddo

!    print*,"max=",ttt

    return
    end subroutine calmp2divcon


