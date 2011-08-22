!
!	orthog.f90
!	new_quick
!
!	Created by Yipu Miao on 2/23/11.
!	Copyright 2011 University of Florida. All rights reserved.
!
!------------------------------------------------------------
! ORTHOG
!------------------------------------------------------------

    SUBROUTINE ORTHOG(NDIM,NVECT,JSTART,VECT,ORTH)

! CONSTRUCTS A SET OF ORTHONORMAL VECTORS FROM THE NVECT LINEARLY
! INDEPENDENT, NORMALIZED VECTORS IN THE ARRAY VECT.  THE VECTORS
! SHOULD BE STORED COLUMNWISE, STARTING IN COLUMN JSTART.  VECT IS
! OVERWRITTEN WITH THE ORTHONORMAL SET.  ALL VECTORS ARE NDIM BY 1.
! ORTH IS RETURNED WITH A VALUE OF .TRUE. IF THE SET WAS LINEARLY
! INDEPENDENT AND .FALSE. OTHERWISE.

! PROGRAMMED BY S. L. DIXON.


    use allmod
    IMPLICIT DOUBLE PRECISION (A-H,O-Z)
! DIMENSION VECT(NDIM,*)
    DIMENSION VECT(nbasis,nbasis)
    LOGICAL :: ORTH

    ORTH = .TRUE.
    ORTEST = 1.0D-8

! BEGIN ORTHOGONALIZATION.

    JSTOP = JSTART + NVECT - 1
    DO 120 J=JSTART,JSTOP
        IF(J > JSTART)THEN
        
        ! SUBTRACT OFF COMPONENTS OF PREVIOUSLY DETERMINED ORTHOGONAL
        ! VECTORS FROM THE VECTOR IN COLUMN J.
        
            DO 60 JPREV=JSTART,J-1
                DOT = 0.0D0
                DO 20 I=1,NDIM
                    DOT = DOT + VECT(I,JPREV)*VECT(I,J)
                20 ENDDO
                DO 40 I=1,NDIM
                    VECT(I,J) = VECT(I,J) - DOT*VECT(I,JPREV)
                40 ENDDO
            60 ENDDO
        ENDIF
    
    ! NORMALIZE COLUMN J.
    
        VJNORM = 0.0D0
        DO 80 I=1,NDIM
            VJNORM = VJNORM + VECT(I,J)**2
        80 ENDDO
        VJNORM = DSQRT(VJNORM)
    
    ! IF THE NORM OF THIS VECTOR IS TOO SMALL THEN THE VECTORS ARE
    ! NOT LINEARLY INDEPENDENT.
    
        IF(VJNORM < ORTEST)THEN
            ORTH = .FALSE.
            GO TO 1000
        ENDIF
        DO 100 I=1,NDIM
            VECT(I,J) = VECT(I,J)/VJNORM
        100 ENDDO
    120 ENDDO
    1000 RETURN
    end SUBROUTINE ORTHOG