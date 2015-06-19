MODULE Diffusion

USE VARTYPES
USE GLOBAL
USE MPI
USE PARALLELVARIABLES
USE DEBUG
USE FUNCTIONS

IMPLICIT NONE

CONTAINS

subroutine transport_NL2(nl2, nl2e, dll0, dlla)
  type(density)      ::nl2, nl2e, nl2b, nl2out
  real               ::dll0, dlla
  logical            ::isNaN
  real               ::tbout, tbin, r0, rout, dl2, lp, dll, nl
  double precision   ::lflux

  tbout=100.00 !in eV
  tbin=100.00

  r0=6.0
  dl2=(dr/Rj)/2.0
  lp=rdist+dl2
  dll=dll0*(lp/r0)**dlla
  lflux=rdist+((dr/Rj)/2.0)

  nl2out%sp =4.0E33
  nl2out%s2p=2.0E34
  nl2out%s3p=2.0E34
  nl2out%op =1.0E35
  nl2out%o2p=1.0E35

  call transport_species(nl2b%sp , nl2%sp , dll, lp, lflux, nl2e%sp , tbout, nl2out%sp )
  call transport_species(nl2b%s2p, nl2%s2p, dll, lp, lflux, nl2e%s2p, tbout, nl2out%s2p)
  call transport_species(nl2b%s3p, nl2%s3p, dll, lp, lflux, nl2e%s3p, tbout, nl2out%s3p)
  call transport_species(nl2b%op , nl2%op , dll, lp, lflux, nl2e%op , tbout, nl2out%op )
  call transport_species(nl2b%o2p, nl2%o2p, dll, lp, lflux, nl2e%o2p, tbout, nl2out%o2p)

!  call transport_species(nl2b%sp , nl2%sp , dll, lp, lflux, nl2e%sp , tbout, nl2out)
!  call transport_species(nl2b%s2p, nl2%s2p, dll, lp, lflux, nl2e%s2p, tbout, tbin)
!  call transport_species(nl2b%s3p, nl2%s3p, dll, lp, lflux, nl2e%s3p, tbout, tbin)
!  call transport_species(nl2b%op , nl2%op , dll, lp, lflux, nl2e%op , tbout, tbin)
!  call transport_species(nl2b%o2p, nl2%o2p, dll, lp, lflux, nl2e%o2p, tbout, tbin)

!  call transport_species(nl2b%XYZ, nl2%XYZ, dll, lp, lflux, nl2e%XYZ, tbout, tbin)

end subroutine transport_NL2

subroutine transport_species(nl2b, nl2, dll, lp, lflux, nl2e, tbout, nl2out)
  USE INPUTS
  double precision   ::nl2, nl2e, nl2b, nl2out 
  real               ::tbout, dt_trans, tbin
  double precision   ::gradnl2, nl2bout, tb, add, tb1
  real               ::dll, lp
  double precision   ::lflux, flux, dflux, rflux, rsquare, dtdf, dfl
  logical            ::isNan
  integer            ::i

  dt_trans=dt/(trans_it*1.0)

  nl2b=nl2
  nl2bout=GetShiftDouble(nl2b,-1)
  if(radgrid .eq. RAD_GRID) nl2bout=nl2out
  gradnl2=(nl2bout - nl2b)/(dr/Rj)
  flux=(dll/(lp**2))*gradnl2
  rflux=GetShiftDouble(flux, 1)
  if( radgrid .eq. 1) rflux=0.0 !(dll0*((rdist-(dr/Rj))/6.0)**dlla)/(lp**2)
  rsquare=rdist**2
  dtdf=dt_trans/(dr/Rj)
  dfl=flux-rflux
  add=rsquare
  add=add*dtdf
  add=add*dfl
  nl2b=nl2b+add 
  nl2=nl2b

  tbin=70.0
  tb =(tbout**(4.0/3.0))*nl2*((rdist+(dr/Rj))**2)
  tb1 =(tbin**(4.0/3.0))*nl2*((rdist+(dr/Rj))**2)


  nl2b=nl2e
  nl2bout=GetShiftDouble(nl2b,-1)
  if(radgrid .eq. RAD_GRID) nl2bout=tb
  gradnl2=(nl2bout-nl2b)/(dr/Rj)
  flux=(dll/(lp**2))*gradnl2
  rflux=GetShiftDouble(flux,1)
  if( radgrid .eq. 1) rflux=((nl2b-tb1)/(dr/Rj))*(dll/((lp-dr)**2)) !(dll0*((rdist-(dr/Rj))/6.0)**dlla)/(lp**2)
  add=(rdist**2)*(dtdf)*(flux-rflux)
  nl2b=nl2b+add
  nl2e=nl2b

end subroutine transport_species

function NLsquared(n, T, NLsquarede, h)!nr, tr, nl2, nl2e, nar

  integer            ::numBin, i
  parameter(numBin=61)
  type(density)      ::nar(numBin),NLsquared, NLsquarede, n
  type(temp)         ::T
  type(height)       ::h
  real               ::dtheta, theta, max_theta, lat
  double precision   ::latwght
  logical            ::isNaN

  max_theta=30
  dtheta=dTOr*2.0*max_theta/(numBin-1)

!  call cm3_expand(n, nar, T, max_theta)
  do i=0, numBin-1
    lat=abs((-max_theta*dTOr+i*dtheta))
    latwght=cos(lat)**7
    NLsquared%op  =NLsquared%op +n%op *exp(-(((lat*rdist*Rj)/h%op )**2))* latwght
    NLsquared%o2p =NLsquared%o2p+n%o2p*exp(-(((lat*rdist*Rj)/h%o2p)**2))* latwght
    NLsquared%sp  =NLsquared%sp +n%sp *exp(-(((lat*rdist*Rj)/h%sp )**2))* latwght
    NLsquared%s2p =NLsquared%s2p+n%s2p*exp(-(((lat*rdist*Rj)/h%s2p)**2))* latwght
    NLsquared%s3p =NLsquared%s3p+n%s3p*exp(-(((lat*rdist*Rj)/h%s3p)**2))* latwght
  isNaN=NaNcatch(nar(i+1)%sp, 111+i, mype) 
  end do
!    NLsquared%sp =ROOTPI*n%sp *h%sp  
!    NLsquared%s2p=ROOTPI*n%s2p*h%s2p 
!    NLsquared%s3p=ROOTPI*n%s3p*h%s3p 
!    NLsquared%op =ROOTPI*n%op *h%op  
!    NLsquared%o2p=ROOTPI*n%o2p*h%o2p 

    latwght=(dtheta)*4.0*PI*((Rj*1.0e5)**3.0)*(rdist**4.0)
    NLsquared%op  =NLsquared%op  *latwght
    NLsquared%o2p =NLsquared%o2p *latwght
    NLsquared%sp  =NLsquared%sp  *latwght
    NLsquared%s2p =NLsquared%s2p *latwght
    NLsquared%s3p =NLsquared%s3p *latwght

    latwght=rdist**2
    NLsquarede%op  =NLsquared%op  *latwght *(T%op **(4.0/3.0))
    NLsquarede%o2p =NLsquared%o2p *latwght *(T%o2p**(4.0/3.0))
    NLsquarede%sp  =NLsquared%sp  *latwght *(T%sp **(4.0/3.0))
    NLsquarede%s2p =NLsquared%s2p *latwght *(T%s2p**(4.0/3.0))
    NLsquarede%s3p =NLsquared%s3p *latwght *(T%s3p**(4.0/3.0))
!  if(mype .eq. 0) call output(nlsquared)
!    call singleout(n,T,nlsquared,nlsquarede, mype)

  return
end function NLsquared

subroutine iterate_NL2(nl2, nl2e, n, T, h)
  type(density)      ::n, nl2, nl2e
  type(density)      ::nl2_0, nl2_p, nl2_m, nl2e_p, nl2e_m
  type(density)      ::f, df, n0, np, nm
  type(temp)         ::T
  type(height)       ::h
  integer            ::nit, i
  real               ::ep

  nit=5
  ep=.00001

  nl2_0 =nl2
  nl2_p =nl2
  nl2_m =nl2
  nl2e_p=nl2e
  nl2e_m=nl2e
  f     =nl2
  df    =nl2

  n0=n
!  n0%sp=n%sp*.8
!  n0%s2p=n%s2p*.8
!  n0%s3p=n%s3p*.8
!  n0%op=n%op*.8
!  n0%o2p=n%o2p*.8
  np=n
  nm=n

  do i=0, nit
   
    np%sp = n0%sp + ep*n0%sp
    np%s2p = n0%s2p + ep*n0%s2p
    np%s3p = n0%s3p + ep*n0%s3p
    np%s4p = n0%s4p + ep*n0%s4p
    np%op = n0%op + ep*n0%op
    np%o2p = n0%o2p + ep*n0%o2p

    nm%sp = n0%sp - ep*n0%sp
    nm%s2p = n0%s2p - ep*n0%s2p
    nm%s3p = n0%s3p - ep*n0%s3p
    nm%s4p = n0%s4p - ep*n0%s4p
    nm%op = n0%op - ep*n0%op
    nm%o2p = n0%o2p - ep*n0%o2p

    nl2_p=NLsquared(np, T, nl2e_p,h)
    nl2_m=NLsquared(nm, T, nl2e_m,h)
    f%sp = nl2_p%sp - nl2_0%sp
    f%s2p = nl2_p%s2p - nl2_0%s2p
    f%s3p = nl2_p%s3p - nl2_0%s3p
    f%s4p = nl2_p%s4p - nl2_0%s4p
    f%op = nl2_p%op - nl2_0%op
    f%o2p = nl2_p%o2p - nl2_0%o2p
    df%sp = (nl2_p%sp - nl2_m%sp)/(np%sp - nm%sp)
    df%s2p = (nl2_p%s2p - nl2_m%s2p)/(np%s2p - nm%s2p)
    df%s3p = (nl2_p%s3p - nl2_m%s3p)/(np%s3p - nm%s3p)
    df%s4p = (nl2_p%s4p - nl2_m%s4p)/(np%s4p - nm%s4p)
    df%op = (nl2_p%op - nl2_m%op)/(np%op - nm%op)
    df%o2p = (nl2_p%o2p - nl2_m%o2p)/(np%o2p - nm%o2p)

    if(abs(f%sp) .gt. 0) then
      n0%sp=n0%sp-f%sp/df%sp
    end if

    if(abs(f%s2p) .gt. 0) then
      n0%s2p=n0%s2p-f%s2p/df%s2p
    end if

    if(abs(f%s3p) .gt. 0) then
      n0%s3p=n0%s3p-f%s3p/df%s3p
    end if

    if(abs(f%op) .gt. 0) then
      n0%op=n0%op-f%op/df%op
    end if

    if(abs(f%o2p) .gt. 0) then
      n0%o2p=n0%o2p-f%o2p/df%o2p
    end if
!if(mype .eq. 6) call output(n0)
  end do
  
!  if(mype .eq. 0) call output(n0)
  n=n0
end subroutine iterate_NL2

subroutine cm3_expand(n, nar, T, max_theta)

  integer          ::numSpec, numBin, maxIter, i, j, k
  parameter(numSpec=7)
  parameter(numBin=61)
  type(density)    ::n, nar(numBin)
  type(temp)       ::T
  real             ::A(numSpec), Z(numSpec), n0(numSpec), Tarr(numSpec)
  real             ::max_theta, theta0, theta, dtheta, anis, fmin, kappa, phi, n1_elec
  real             ::Tkappa(numBin)
  real             ::f, df, fions(numSpec), dfions(numSpec)
  double precision ::n1_ions(numSpec)

  maxIter=20

  A = [1/1685.17,16.0,16.0,32.0,32.0,32.0,1/1685.] !mass in protons
  Z = [-1.0,1.0,2.0,1.0,2.0,3.0,-1.0]              !charge
  Tarr = [T%elec,T%op,T%o2p,T%sp,T%s2p,T%s3p,T%elecHot]
  n0 = [n%elec,n%op,n%o2p,n%sp,n%s2p,n%s3p,n%elecHot]
  n1_ions=n0
  n1_elec=n0(1)

  theta0=0.0
  anis=1.0
  fmin=0.01
  kappa=2.4

  dtheta=2*max_theta/(numBin-1)

  do i=0, numBin-1 
    theta=(-max_theta+i*dtheta)*dTOr
    
    phi=0.0
    j=1
    f=1.0
    do while (j<=maxIter .and. abs(f)>fmin) 
      j=j+1
      f=0.0
      df=0.0
      do k=1, numSpec
        call Lat_Ion_Dens(longitude*dTOr, theta0, theta, Z(k), A(k), Tarr(k), anis, n0(k),&
                          n1_ions(k),fions(k), dfions(k), phi)
        f=f+fions(k)
        df=df+dfions(k)
      end do
      if(abs(f) .ge. fmin) then
        phi=phi-f/df
      end if
    end do
    nar(i+1)%elec=n1_ions(1)
    nar(i+1)%op=n1_ions(2)
    nar(i+1)%o2p=n1_ions(3)
    nar(i+1)%sp=n1_ions(4)
    nar(i+1)%s2p=n1_ions(5)
    nar(i+1)%s3p=n1_ions(6)
    nar(i+1)%elecHot=n1_ions(7)
    if(abs(f)>fmin .and. .not. HUSH) then
      print *, "ERROR::cm3_expand (in diffusion.f90) failed to converge"
      print *, abs(f), fmin, mype
    end if
  end do
  
end subroutine cm3_expand

subroutine Lat_Ion_Dens(sys3,theta0, theta, Z, A, T, anis, n0, n1, fions, dfions, phi)
!Calculates density at a given latitude 
!assumes gaussian latitudinal distribution
!uses equatorial density to generate latitudinal densities
!from Delamere cm3_schght.pro f_df_ions

  real      ::sys3, theta0, theta,Z,A,T,anis,n0, phi, L0
  real      ::sys30, sys3t, alphat, alpha, d_offset
  real      ::thetaM, thetaM0, thetaC0, thetaC
  real      ::factor, R, R0, fcent, f1, f2, f3, fmag
  real      ::fions, dfions
  double precision ::n1, e1, e2, e3, ee  

!sys3.........system III longitude
!theta0.......Jovigraphic latitude at S_0
!theta........Jovigraphic latitude at S
!Z............charge number
!A............atomic mass number
!T............temperature_Perp
!anis.........temperature anisotropy
!n0...........density at S_0

  L0=6.0

  sys30=148.0*dTOr
  sys3t=292.0*dTOr
  alphat=0.0*dTOr
  alpha=0.0 !asin(sin(alphat)*sin(sys30-sys3t))
  d_offset=0.131 !Rj
  thetaM0=theta0-alpha
  thetaM=theta-alpha
  thetaC0=thetaM0+alpha/3.0
  thetaC=thetaM+alpha/3.0

  factor=.825 !1/2 m (v^2)/q .5*mp*(omega*Rj)^2/q

  R=rdist*cos(thetaM)**2
  R0=L0*cos(thetaM0)**2

  

  fcent=(R*cos(theta))**2 - (R0*cos(theta0))**2
 
  f1=1.0+3.0*sin(thetaM0)**2
  f2=1.0+3.0*sin(thetaM)**2
  f3=(cos(thetaM)/cos(thetaM0))**6

  fmag=log(sqrt(f1/f2)*f3)

  e1=(Z*phi*anis/T)
  e2=factor*A*fcent*anis/T
  e3=(anis-1.0)*fmag
  ee=e1+e2-e3
  
  n1=n0*exp(ee)

  fions=Z*n1
  dfions=Z*fions*anis/T

end subroutine Lat_Ion_Dens

subroutine transport_flux(n, t, DLL0, DLL_alpha, h, mdot)
!should solve the diffusion equation thus determining
!  the amount of plasma to be transported 
  type(density)      ::nl2, nl2e, n
  type(temp)         ::t
  type(height)       ::h
  integer            ::i
  double precision   ::tout, tin, rout, r0
  double precision   ::DLL0, DLL_alpha, mdot
  double precision   ::dll, v, r, vout

  tout=200.0 !eV
  tin=70.0   !eV

  r0=6.0 !in Rj
  rout=rdist+(dr/Rj)
  dll=DLL0*(rout/r0)**DLL_alpha
  v=dll*dr
  r=2*PI*rdist*Rj*1e3
  mdot=.5*rootpi*r*1e12*mp*v*Rj* &
       (32.0*(h%sp*n%sp + h%s2p*n%s2p + h%s3p*n%s3p) + 16.0*(h%op*n%op +h%o2p*n%o2p))

  vout=GetShiftDouble(v,-1)  

  call transport_species_old(n%sp, v, vout, t%sp) 
  call transport_species_old(n%s2p, v, vout, t%s2p) 
  call transport_species_old(n%s3p, v, vout, t%s3p) 
  call transport_species_old(n%op, v, vout, t%op) 
  call transport_species_old(n%o2p, v, vout, t%o2p) 


end subroutine transport_flux

subroutine Lax_Wend(n, v, vout) !cylindrical
!  type(density)      ::n
  double precision   ::n, v, f, x2, n1, f1
  double precision   ::nout, fout, rout, rin, vout, f1in

  f=n*v
  x2=rdist+(dr/2.0)
  rout=rdist+dr
  rin=rdist-dr
  
  nout=GetShiftDouble(n,-1)
  fout=GetShiftDouble(f,-1)
!  vout=GetShiftReal(v,-1)

  n1=.5*(n+nout) - (.5*dt/(dr*x2))*rout*fout - rdist*f
  f1=n1*0.5*(vout+v)

  f1in=GetShiftDouble(f1, 1)

  x2=(rdist+rin)/2.0
  n=n-(dt/(dr*x2))*(rdist*f1-rin*f1in)

end subroutine Lax_Wend

subroutine Lax_Wend_E(nt, v, vout)
  double precision   ::nt, v, vout
  double precision   ::nt1, f1, x2, f, xp, xm, dx
  double precision   ::ntout, f1in, fout
  double precision   ::rin, rout, gama

  f= nt*v
  gama=5.0/3.0
  
  rin=rdist-dr
  rout=rdist+dr
  
  ntout=GetShiftDouble(nt, -1)
  fout=GetShiftDouble(f, -1)

  x2=.5*(rdist+rout)

  nt1=.5*(nt+ntout)-(dt/(2.0*dr*x2))*(rout*fout -rdist*f) -&
        (gama-1.0)*.5*(ntout+nt)*(dt/(2.0*dr*x2))*(rout*vout - rdist*v)

  f1=nt1*.5*(vout+v)

  f1in=GetShiftDouble(f1, 1)

  x2=rdist
  xm=.5*(rdist+rin)
  xp=2*rdist-xm
  dx=xp-xm
  nt=nt-(dt/(dx*x2))*(xp*f1 - xm*f1in) - &
      (gama-1.0)*.5*nt*(dt/(2.0*dx*x2))*(xp*vout-xm*v)

end subroutine Lax_Wend_E

subroutine transport_species_old(n, v, vout, t)
  double precision   ::n, v, vout, t, nt  

  nt=n*t
  call Lax_Wend(n, v, vout)
  call Lax_Wend_E(nt, v, vout)

end subroutine transport_species_old

!subroutine GetShift(n, nret, shift)
!  type(density)       ::n, nret
!  integer             ::to, from, shift, i
!
!!shift of -1 corresponds to getting radially outward neighbor
!!shift of  1 corresponds to getting radially  inward neighbor
!
!  to  = mype-shift*LNG_GRID
!  from= mype+shift*LNG_GRID
!
!  if(to .le. 0) to=npes-to
!  if(to .ge. npes) to=to-npes
!
!  if(from .le. 0) from=npes-from
!  if(from .ge. npes) from=from-npes
!
!  if(to.ge.0) call MPI_SEND(n%sp, 1, MPI_DOUBLE_PRECISION, to, 22, MPI_COMM_WORLD, ierr)
!  if(from<npes) call MPI_RECV(nret%sp, 1, MPI_DOUBLE_PRECISION, from, 22, MPI_COMM_WORLD, stat, ierr)
!
!  if(to.ge.0) call MPI_SEND(n%s2p, 1, MPI_DOUBLE_PRECISION, to, 22, MPI_COMM_WORLD, ierr)
!  if(from<npes) call MPI_RECV(nret%s2p, 1, MPI_DOUBLE_PRECISION, from, 22, MPI_COMM_WORLD, stat, ierr)
!
!  if(to.ge.0) call MPI_SEND(n%s3p, 1, MPI_DOUBLE_PRECISION, to, 22, MPI_COMM_WORLD, ierr)
!  if(from<npes) call MPI_RECV(nret%s3p, 1, MPI_DOUBLE_PRECISION, from, 22, MPI_COMM_WORLD, stat, ierr)
!
!  if(to.ge.0) call MPI_SEND(n%op, 1, MPI_DOUBLE_PRECISION, to, 22, MPI_COMM_WORLD, ierr)
!  if(from<npes) call MPI_RECV(nret%op, 1, MPI_DOUBLE_PRECISION, from, 22, MPI_COMM_WORLD, stat, ierr)
!
!  if(to.ge.0) call MPI_SEND(n%o2p, 1, MPI_DOUBLE_PRECISION, to, 22, MPI_COMM_WORLD, ierr)
!  if(from<npes) call MPI_RECV(nret%o2p, 1, MPI_DOUBLE_PRECISION, from, 22, MPI_COMM_WORLD, stat, ierr)
!
!  if(to.ge.0) call MPI_SEND(n%elec, 1, MPI_DOUBLE_PRECISION, to, 22, MPI_COMM_WORLD, ierr)
!  if(from<npes) call MPI_RECV(nret%elec, 1, MPI_DOUBLE_PRECISION, from, 22, MPI_COMM_WORLD, stat, ierr)
!
!end subroutine GetShift

function GetShiftDouble(n, shift)
  double precision   ::n, GetShiftDouble
  integer            ::to, from, shift, i
  logical            ::send, receive
!shift must be 1 or -1
!shift of -1 corresponds to getting radially outward neighbor
!shift of  1 corresponds to getting radially  inward neighbor

  to  = mype+shift*LNG_GRID
  from= mype-shift*LNG_GRID

  send    = .true.
  receive = .true.
 
  GetShiftDouble=n

  if(to .lt. 0) send = .false.
  if(to .ge. (npes))  send = .false.

  if(from .lt. 0) receive=.false. 
  if(from .ge. (npes)) receive=.false. 

  call MPI_BARRIER(MPI_COMM_WORLD, ierr)

  if( send ) then
    call MPI_SEND(n, 1, MPI_DOUBLE_PRECISION, to, 22, MPI_COMM_WORLD, ierr)
  endif
  if( receive ) then
    call MPI_RECV(GetShiftDouble, 1, MPI_DOUBLE_PRECISION, from, 22, MPI_COMM_WORLD, stat, ierr)
  endif

return

end function GetShiftDouble

function GetShiftReal(n, shift)
  real               ::n, GetShiftReal
  integer            ::to, from, shift, i
  logical            ::send, receive
!shift must be 1 or -1
!shift of -1 corresponds to getting radially outward neighbor
!shift of  1 corresponds to getting radially  inward neighbor

  to  = mype+shift*LNG_GRID
  from= mype-shift*LNG_GRID

  send    = .true.
  receive = .true.

  GetShiftReal=n

  if(to .lt. 0) send=.false.
  if(to .ge. (npes)) send=.false.

  if(from .lt. 0) receive=.false.
  if(from .ge. (npes)) receive=.false.

  call MPI_BARRIER(MPI_COMM_WORLD, ierr)

  if( send ) then
    call MPI_SEND(n, 1, MPI_DOUBLE_PRECISION, to, 22, MPI_COMM_WORLD, ierr)
  endif
  if( receive ) then
    call MPI_RECV(GetShiftReal, 1, MPI_DOUBLE_PRECISION, from, 22, MPI_COMM_WORLD, stat, ierr)
  endif

return

end function GetShiftReal

subroutine whichBroke()
  call MPI_BARRIER(MPI_COMM_WORLD, ierr)
  print *, mype
  call MPI_BARRIER(MPI_COMM_WORLD, ierr)
  
end subroutine whichBroke

END MODULE

