__device__ __noinline__  void h2_1_2(QUICKDouble* YVerticalTemp, QUICKDouble* store,
                                   QUICKDouble Ptempx, QUICKDouble Ptempy, QUICKDouble Ptempz,  \
                                   QUICKDouble WPtempx,QUICKDouble WPtempy,QUICKDouble WPtempz, \
                                   QUICKDouble Qtempx, QUICKDouble Qtempy, QUICKDouble Qtempz,  \
                                   QUICKDouble WQtempx,QUICKDouble WQtempy,QUICKDouble WQtempz, \
                                   QUICKDouble ABCDtemp,QUICKDouble ABtemp, \
                                   QUICKDouble CDtemp, QUICKDouble ABcom, QUICKDouble CDcom)
{
    // call for L =            0  B =            1
    f_0_1_t f_0_1_0 ( VY( 0, 0, 0 ), VY( 0, 0, 1 ), Qtempx, Qtempy, Qtempz, WQtempx, WQtempy, WQtempz);

    // call for L =            0  B =            1
    f_0_1_t f_0_1_1 ( VY( 0, 0, 1 ), VY( 0, 0, 2 ), Qtempx, Qtempy, Qtempz, WQtempx, WQtempy, WQtempz);

    // call for L =            0  B =            2
    f_0_2_t f_0_2_0 ( f_0_1_0, f_0_1_1, VY( 0, 0, 0 ), VY( 0, 0, 1 ), CDtemp, ABcom, Qtempx, Qtempy, Qtempz, WQtempx, WQtempy, WQtempz);

    // call for L =            0  B =            1
    f_0_1_t f_0_1_2 ( VY( 0, 0, 2 ), VY( 0, 0, 3 ), Qtempx, Qtempy, Qtempz, WQtempx, WQtempy, WQtempz);

    // call for L =            0  B =            2
    f_0_2_t f_0_2_1 ( f_0_1_1, f_0_1_2, VY( 0, 0, 1 ), VY( 0, 0, 2 ), CDtemp, ABcom, Qtempx, Qtempy, Qtempz, WQtempx, WQtempy, WQtempz);

    // call for L =            1  B =            2
    f_1_2_t f_1_2_0 ( f_0_2_0,  f_0_2_1,  f_0_1_1, ABCDtemp, Ptempx, Ptempy, Ptempz, WPtempx, WPtempy, WPtempz);

    // WRITE LAST FOR I =            1  J=           2
    LOC2(store,  1,  4, STOREDIM, STOREDIM) = f_1_2_0.x_1_4 ;
    LOC2(store,  1,  5, STOREDIM, STOREDIM) = f_1_2_0.x_1_5 ;
    LOC2(store,  1,  6, STOREDIM, STOREDIM) = f_1_2_0.x_1_6 ;
    LOC2(store,  1,  7, STOREDIM, STOREDIM) = f_1_2_0.x_1_7 ;
    LOC2(store,  1,  8, STOREDIM, STOREDIM) = f_1_2_0.x_1_8 ;
    LOC2(store,  1,  9, STOREDIM, STOREDIM) = f_1_2_0.x_1_9 ;
    LOC2(store,  2,  4, STOREDIM, STOREDIM) = f_1_2_0.x_2_4 ;
    LOC2(store,  2,  5, STOREDIM, STOREDIM) = f_1_2_0.x_2_5 ;
    LOC2(store,  2,  6, STOREDIM, STOREDIM) = f_1_2_0.x_2_6 ;
    LOC2(store,  2,  7, STOREDIM, STOREDIM) = f_1_2_0.x_2_7 ;
    LOC2(store,  2,  8, STOREDIM, STOREDIM) = f_1_2_0.x_2_8 ;
    LOC2(store,  2,  9, STOREDIM, STOREDIM) = f_1_2_0.x_2_9 ;
    LOC2(store,  3,  4, STOREDIM, STOREDIM) = f_1_2_0.x_3_4 ;
    LOC2(store,  3,  5, STOREDIM, STOREDIM) = f_1_2_0.x_3_5 ;
    LOC2(store,  3,  6, STOREDIM, STOREDIM) = f_1_2_0.x_3_6 ;
    LOC2(store,  3,  7, STOREDIM, STOREDIM) = f_1_2_0.x_3_7 ;
    LOC2(store,  3,  8, STOREDIM, STOREDIM) = f_1_2_0.x_3_8 ;
    LOC2(store,  3,  9, STOREDIM, STOREDIM) = f_1_2_0.x_3_9 ;
}
